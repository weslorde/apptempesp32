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
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/notificationAlarm.dart';
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

  final AllData _data = AllData();

  late MqttServerClient _clientAWS;

  String _dispName = "";

  List<List<String>> _listDispsPath = [[]];

  final AllData data = AllData();

  Function _funDataRecived = () => {};
  set setfunDataRecived(Function fun) => _funDataRecived = fun;

  Function _funWifiStatusOff = () => {};
  set setfunWifiStatusOff(Function fun) => _funWifiStatusOff = fun;
  Function _funWifiStatusOn = () => {};
  set setfunWifiStatusOn(Function fun) => _funWifiStatusOn = fun;

  Function _funAlexaLink = () => {};
  set setfunAlexaLink(Function fun) => _funAlexaLink = fun;
  String _alexaLinkResponse = "";
  String get getAlexaLinkResponse => _alexaLinkResponse;

  bool _awsHasCert = false;
  bool _awsHasNet = false;
  bool _awsMQTTConnect = false;

  String get getDispName => _dispName;

  bool get getAwsHasCert => _awsHasCert;
  bool get getAwsHasNet => _awsHasNet;
  bool get getMQTTConnect => _awsMQTTConnect;

  List<List<String>> get getListDispsPath => _listDispsPath;

  set setMQTTConnect(logic) => _awsMQTTConnect = logic;

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
      final file = File(
          '${directory.path}/AWS/${_data.getFileIdDispActual}/${fileName}'); //TODO pastas
      if (!file.existsSync()) {
        return false;
      }
    }
    _awsHasCert = true;
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
        //Se bugar tem que melhorar a logica para nao chamar o Estado de erro 2 vezes
        if (isDeviceConnected == false && _awsHasNet == true) {
          _funWifiStatusOff();
        } else {
          _funWifiStatusOn();
        }
        _awsHasNet = isDeviceConnected;
      } else {
        _awsHasNet = false;
        _funWifiStatusOff();
      }
    });
    _awsHasNet = isDeviceConnected;
    return isDeviceConnected;
  }

  Future creatClient() async {
    _dispName = await fileDataPicker();
    //_dispName = "ChurrasTech2406";
    // Your AWS IoT Core endpoint url
    const url = "aymk3jv3m3bvi-ats.iot.sa-east-1.amazonaws.com";
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
      print("CONECTADO?");
    } on Exception catch (e) {
      print('MQTT client exception - $e');
      _clientAWS.disconnect();
      //exit(-1);
    }
  }

  Future<bool> arrumar() async {
    print("TESTE ${_clientAWS.connectionStatus!.state}");
    if (_clientAWS.connectionStatus!.state == MqttConnectionState.connected) {
      print('MQTT client connected to AWS IoT');

      // Publish to a topic of your choice after a slight delay, AWS seems to need this
      await MqttUtilities.asyncSleep(1);
      const topic = '/test/topic';
      final builder = MqttClientPayloadBuilder();
      builder.addString('Hello World');
      // Important: AWS IoT Core can only handle QOS of 0 or 1. QOS 2 (exactlyOnce) will fail!
      _clientAWS.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);

      _awsMQTTConnect = true;

      // Subscribe to the same topic
      _clientAWS.subscribe(
          '\$aws/things/$_dispName/shadow/name/TemperaturesShadow/update/delta',
          MqttQos.atLeastOnce);
      _clientAWS.subscribe(
          '\$aws/things/$_dispName/shadow/name/AlarmShadow/update/delta',
          MqttQos.atLeastOnce);
      _clientAWS.subscribe(
          '\$aws/things/$_dispName/shadow/name/DynamoSendShadow/update/delta',
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

      return true;
    } else {
      print(
          'ERROR MQTT client connection failed - disconnecting, state is ${_clientAWS.connectionStatus!.state}');
      _clientAWS.disconnect();

      return false;
    }
  }

  void _awsListener(String topic, Map<String, dynamic> mapMsg) {
    if (mapMsg['state']['MsgError'] != "") {
      print("AWSiot CHEGOU!");
      print(mapMsg['state']);
      if (topic ==
          '\$aws/things/$_dispName/shadow/name/DynamoSendShadow/update/delta') {
        if (mapMsg['state']['Error'] == "1") {
          _alexaLinkResponse = mapMsg['state']['MsgError'];
          _funAlexaLink(1);
        }
        if (mapMsg['state']['Error'] == "0") {
          _alexaLinkResponse = mapMsg['state']['MsgError'];
          _funAlexaLink(0);
        }
      }
    }

    if (mapMsg['state']['Flutter'] == "0") {
      data.setAwsIotBoardConnect = true;
      if (topic ==
          '\$aws/things/$_dispName/shadow/name/TemperaturesShadow/update/delta') {
        if (mapMsg['state']['Enviar'] == "0") {
          var tgrelha = mapMsg['state']['Grelha'];
          var tsensor1 = mapMsg['state']['Temp1'];
          var tsensor2 = mapMsg['state']['Temp2'];
          var tempAlvo = mapMsg['state']['TAlvoEsp'];
          print("Valors das Temps: $tgrelha $tsensor1 $tsensor2 $tempAlvo !");
          data.setListTemp = [tgrelha, tsensor1, tsensor2, tempAlvo];
          _funDataRecived();
          //setTemp(Tgrelha, Tsensor1, Tsensor2, TempAlvo);
        }
      } // END TemperaturesShadow

      else if (topic ==
          '\$aws/things/$_dispName/shadow/name/AlarmShadow/update/delta') {
        if (mapMsg['state']['Enviar'] == "0") {
          data.zeraAlarms();
          var alarmeTimer = mapMsg['state']['TimerAlarm']; //'01','10','02''20'
          var alarmeGraus =
              mapMsg['state']['GrausAlarm']; // [['Grelha', 110], ['Grelha', 5]]
          //TODO ARRUMAR ta aqui faz tempo kk
          print("Alarme CHEGOU: $alarmeTimer");
          if (alarmeTimer != "") {
            alarmeTimer = alarmeTimer
                .substring(0, alarmeTimer.length - 1)
                .split(','); // ['01''10''02''20']
            for (int x = 0; x < alarmeTimer.length; x += 3) {
              String hora = alarmeTimer[x];
              String min = alarmeTimer[x + 1];
              data.setAlarmeTimer = [hora, min];
            }
          }

          if (alarmeGraus != "[]") {
            alarmeGraus = alarmeGraus
                .substring(1, alarmeGraus.length - 1)
                .split(', '); // ['Grelha' -- 110] -- ['Grelha' -- 5]
            int x = 0;
            String sensor = "";
            for (var item in alarmeGraus) {
              if (x % 2 == 0) // Par
                sensor = item.substring(2, item.length - 1);
              else {
                // Impar
                String temp = item.substring(0, item.length - 1);
                data.setAlarmGraus = [sensor, temp];
              }
              x += 1;
            }
          }
          //
          if (mapMsg['state']['NotificaAlarm'] == "1") {
            List<String> NotiAlarm = mapMsg['state']['NAlarm'].split(',');
            data.startNotificationAlarm(
                NotiAlarm[0], NotiAlarm[1], NotiAlarm[2]);
            const topic = 'AlarmShadow/update';
            const msg =
                '{"state": {"desired": {"Flutter": "1", "NotificaAlarm": "0", "Enviar": "1"}}}';
            awsMsg(topic, msg);
          }

          //
          print("\n   $alarmeTimer\n   $alarmeGraus");
          _funDataRecived();
        }
      } //END AlarmShadow
    } // END IF FLUTTER == 0
  } // End of Function awsListener

  Future<ByteData> certBytePicker(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
        '${directory.path}/AWS/${_data.getFileIdDispActual}/${fileName}'); //TODO pastas
    print(file.readAsString());
    Uint8List bytes = file.readAsBytesSync();
    return ByteData.view(bytes.buffer);
  }

  Future<String> fileDataPicker() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(
        '${directory.path}/AWS/${_data.getFileIdDispActual}/deviceName.key'); //TODO pastas
    return file.readAsString();
  }

  dispsRegistered(attState) async {
    final directory = await getApplicationDocumentsDirectory();
    //
    //print(directory);
    var folders = await Directory('${directory.path}/AWS/')
        .listSync()
        .where((entity) => entity is Directory)
        .toList();

    List<List<String>> dispFiles = [];
    for (int x = 0; x < folders.length; x++) {
      //print(folders[x].path.replaceAll('${directory.path}/AWS/', ""));
      var name =
          await File('${directory.path}/AWS/$x/deviceName.key').readAsString();
      dispFiles.add([
        folders[x].path.replaceAll('${directory.path}/AWS/', ""),
        name.replaceAll("ChurrasTech", "")
      ]);
    }
    //
    _listDispsPath = dispFiles; // TODO return
    attState();
  }

  void closeAWS() {
    _awsMQTTConnect = false;
    _clientAWS.disconnect();
    print('Disconnecting');
  }

  void awsMsg(String topic, String msg) {
    print("\nSend: $topic \n$msg \n");
    var topicFull = '\$aws/things/$_dispName/shadow/name/$topic';
    final builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    // Important: AWS IoT Core can only handle QOS of 0 or 1. QOS 2 (exactlyOnce) will fail!
    _clientAWS.publishMessage(topicFull, MqttQos.atLeastOnce, builder.payload!);
  }
} // End of Class AwsController
