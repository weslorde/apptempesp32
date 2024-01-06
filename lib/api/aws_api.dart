/*
 * Package : mqtt_client
 * Author : S. Hamblett <steve.hamblett@linux.com>
 * Date   : 10/07/2021
 * Copyright :  S.Hamblett
 *
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:path_provider/path_provider.dart';

/// An example of connecting to the AWS IoT Core MQTT broker and publishing to a devices topic.
/// This example uses MQTT on port 8883 using certificites
/// More instructions can be found at https://docs.aws.amazon.com/iot/latest/developerguide/mqtt.html and
/// https://docs.aws.amazon.com/iot/latest/developerguide/protocols.html, please read this
/// before setting up and running this example.

/*
late void Function(List) attPage2;
void awsRecivePage2Att(void Function(List) fun) {
  attPage2 = fun;
}*/

class AwsController {
  // Creat Singleton
  static final AwsController _shared = AwsController._sharedInstance();
  AwsController._sharedInstance();
  factory AwsController() => _shared;

  late MqttServerClient _clientAWS;

  late String _dispName;

  //Return true if all 3 files exists
  Future<bool> hasCertFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final List<String> listFileName = [
      'device.pem.crt',
      'private.pem.key',
      'rootCA.pem',
      'deviceName.key'
    ];
    for (String fileName in listFileName) {
      final file = File('${directory.path}/AWS/${fileName}');
      if (!file.existsSync()) {
        return false;
      }
    }
    return true;
  }

  Future<bool> hasInternet() async {
    var isDeviceConnected = false;

    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    print(isDeviceConnected);

    Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      print("CONECTIVTY RESULT: $result");
      if (result != ConnectivityResult.none) {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        print(isDeviceConnected);
      }
    });

    return isDeviceConnected;
  }

  Future creatClient() async {
    _dispName = await fileDataPicker();
    //_dispName = "ChurrasTech2406";
    // Your AWS IoT Core endpoint url
    const url = "a35wgflbzj4nrh-ats.iot.sa-east-1.amazonaws.com";
    // AWS IoT MQTT default port
    const port = 8883;
    // The client id unique to your device
    const clientId = 'FlutterApp';

    _clientAWS = MqttServerClient.withPort(url, clientId, port);
    // Set secure
    _clientAWS.secure = true;
    // Set Keep-Alive
    //client.keepAlivePeriod = 99999;
    // Set the protocol to V3.1.1 for AWS IoT Core, if you fail to do this you will not receive a connect ack with the response code
    _clientAWS.setProtocolV311();
    // logging if you wish
    _clientAWS.logging(on: true);

    //final readString2 = Uint8List.fromList(list).buffer.asByteData();
    //ByteData deviceCert2 = await file.readAsBytes();
    ByteData deviceCert = await certBytePicker('device.pem.crt');
    ByteData privateKey = await certBytePicker('private.pem.key');
    ByteData rootCA = await certBytePicker('rootCA.pem');

    final context = SecurityContext.defaultContext;
    context.setClientAuthoritiesBytes(rootCA.buffer.asUint8List());
    context.useCertificateChainBytes(deviceCert.buffer.asUint8List());
    context.usePrivateKeyBytes(privateKey.buffer.asUint8List());

    _clientAWS.securityContext = context;
  }

  Future connectAWS() async {
    // Setup the connection Message
    final connMess =
        MqttConnectMessage().withClientIdentifier('FlutterApp').startClean();
    _clientAWS.connectionMessage = connMess;

    // Connect the client
    try {
      print('MQTT client connecting to AWS IoT using certificates....');
      await _clientAWS.connect();
    } on Exception catch (e) {
      print('MQTT client exception - $e');
      _clientAWS.disconnect();
      exit(-1);
    }
  }

  Future arrumar() async {
    if (_clientAWS.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected to AWS IoT');

      // Publish to a topic of your choice after a slight delay, AWS seems to need this
      await MqttUtilities.asyncSleep(1);
      const topic = '/test/topic';
      final builder = MqttClientPayloadBuilder();
      builder.addString('Hello World');
      // Important: AWS IoT Core can only handle QOS of 0 or 1. QOS 2 (exactlyOnce) will fail!
      _clientAWS.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

      // Subscribe to the same topic
      _clientAWS.subscribe(
          '\$aws/things/$_dispName/shadow/name/TemperaturesShadow/update/delta',
          MqttQos.atLeastOnce);
      _clientAWS.subscribe(
          '\$aws/things/$_dispName/shadow/name/AlarmShadow/update/delta',
          MqttQos.atLeastOnce);
      // Print incoming messages from another client on this topic

      _clientAWS.updates!
          .listen((List<MqttReceivedMessage<MqttMessage>> listRecivedMsg) {
        final recMesg = listRecivedMsg[0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMesg.payload.message);
        final Map<String, dynamic> mapMsg = jsonDecode(pt);
        print(
            'Topic is <${listRecivedMsg[0].topic}>, payload is <-- ${mapMsg['state']} -->');
        _awsListener(listRecivedMsg[0].topic, mapMsg);
      });
    } else {
      print(
          'ERROR MQTT client connection failed - disconnecting, state is ${_clientAWS.connectionStatus!.state}');
      _clientAWS.disconnect();
    }
  }

  void _awsListener(String topic, Map<String, dynamic> mapMsg) {
    if (topic ==
        '\$aws/things/$_dispName/shadow/name/TemperaturesShadow/update/delta') {
      if (mapMsg['state']['Enviar'] == "0") {
        var tgrelha = mapMsg['state']['Grelha'];
        var tsensor1 = mapMsg['state']['Temp1'];
        var tsensor2 = mapMsg['state']['Temp2'];
        var tempAlvo = mapMsg['state']['TAlvoEsp'];
        print("Valors das Temps: $tgrelha $tsensor1 $tsensor2 $tempAlvo !");
        //setTemp(Tgrelha, Tsensor1, Tsensor2, TempAlvo);
      }
    } else if (topic ==
        '\$aws/things/$_dispName/shadow/name/AlarmShadow/update/delta') {
      if (mapMsg['state']['Enviar'] == "0") {
        var alarmeTimer = mapMsg['state']['TimerAlarm'];
        var alarmeGraus = mapMsg['state']['GrausAlarm'];
        print("\n   $alarmeTimer\n   $alarmeGraus");
        //attPage2([alarmToList(AlarmeGraus), alarmToList(AlarmeTimer)]);
        print("Aqui");
        //print(alarmToList(AlarmeTimer));
      }
    }
  } // End of Function awsListener

  Future<ByteData> certBytePicker(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/AWS/${fileName}');
    print(file.readAsString());
    Uint8List bytes = file.readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }

  Future<String> fileDataPicker() async{
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/AWS/deviceName.key');
    return file.readAsString();
  }

  void closeAWS() {
    _clientAWS.disconnect();
    print('Disconnecting');
  }

  void awsMsg(String topic, String msg) {
    print("fun Send");
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    // Important: AWS IoT Core can only handle QOS of 0 or 1. QOS 2 (exactlyOnce) will fail!
    _clientAWS.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }
} // End of Class AwsController

