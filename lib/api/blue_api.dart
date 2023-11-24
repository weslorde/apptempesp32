import 'dart:convert';

import 'package:apptempesp32/api/data_storege.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class BlueController {
  BluetoothDevice? _blueDevice;

  BluetoothCharacteristic? _blueCharacteristicToRecive;
  BluetoothCharacteristic? _blueCharacteristicToSend;
  final String _serviceUuid = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  final String _characterMandarUuid = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  final String _characterReceberUuid = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";

  bool _blueSuported = false;
  bool _blueIsOn = false;
  bool _blueTurningOn = false;
  bool _locationIsOn = false;
  bool _blueIsScan = false;
  bool _blueLinked = false;
  bool _blueConnect = false;

  Function _funConectado = () => {};
  late Function(int) _funCertState;

  // Creat Singleton
  static final BlueController _shared = BlueController._sharedInstance();
  BlueController._sharedInstance();
  factory BlueController({Function(int)? attPageState}) => _shared;

  set setblueSup(bool logic) => _blueSuported = logic;
  set setBlueIsOn(bool logic) => _blueIsOn = logic;
  set setBlueTurningOn(bool logic) => _blueTurningOn = logic;
  set setLocatIsOn(bool logic) => _locationIsOn = logic;
  set setBlueIsScan(bool logic) => _blueIsScan = logic;
  set setBlueLinked(bool logic) => _blueLinked = logic;
  set setblueConnect(bool logic) => _blueConnect = logic;
  
  set setfunConectado(Function fun) => _funConectado = fun;
  set setfunCertState(Function(int) fun) => _funCertState = fun;

  bool get getBlueSup => _blueSuported;
  bool get getBlueIsOn => _blueIsOn;
  bool get getBlueTurningOn => _blueTurningOn;
  bool get getLocatIsOn => _locationIsOn;
  bool get getBlueIsScan => _blueIsScan;
  bool get getBlueLinked => _blueLinked;
  bool get getblueConnect => _blueConnect;

  BluetoothDevice? get getDevice => _blueDevice;

  set setDevice(BluetoothDevice? device) => _blueDevice = device;

  void discoveryDevice() async {
    // Note: You must call discoverServices after every connection!
    List<BluetoothService> services = await _blueDevice!.discoverServices();
    services.forEach((service) {
      if (service.uuid.toString().toLowerCase() == _serviceUuid.toLowerCase()) {
        final lsOfChar = service.characteristics;
        for (var y = 0; y < lsOfChar.length; y++) {
          if (lsOfChar[y].uuid.toString().toLowerCase() ==
              _characterReceberUuid.toLowerCase()) {
            //print('Achouu ${lsOfChar[y].uuid.toString().toLowerCase()}');
            _blueCharacteristicToRecive = lsOfChar[y];
            criaLeitor();
          }
          if (lsOfChar[y].uuid.toString().toLowerCase() ==
              _characterMandarUuid.toLowerCase()) {
            //print('Achouuu ${lsOfChar[y].uuid.toString().toLowerCase()}');
            _blueCharacteristicToSend = lsOfChar[y];
            Future.delayed(const Duration(seconds: 3))
                .then((_) => mandaMensagem("Ping"));
          }
        }
      }
    });
  }

  void criaLeitor() async {
    if (_blueCharacteristicToRecive == null) {
      print("EEEEEEEEEEERRRRRRRRRRRRRRRRRRROOOOOOOOOOOORRRRRRRRRRRRRRR");
    } else {
      _blueCharacteristicToRecive?.onValueReceived.listen((value) =>
          blueNotify(value)); //Creat listen using function blueNotify
      await _blueCharacteristicToRecive?.setNotifyValue(true);
    }
  }

  //Fun to recive All Blue DATA
  void blueNotify(List<int> msgRecebida) {
    final AllData data = AllData();
    var recived = utf8.decode(msgRecebida);
    List<String> listRecived = recived.split(',');
    String comando = listRecived[0];

    print("Comando recebido: ${comando}");

    if (comando.substring(0, 1) == "+") {
      if (comando.length < 5) { //Small comand dont need any IF check
        data.setCert = comando.substring(1);
        mandaMensagem("Cert");
      } else {
        if (comando.substring(0, 5) == "+!Ini") {
          // If comando.length >= 5 check possible comands
          data.setCertBlank();
          mandaMensagem("Cert");
        } else if (comando.substring(0, 5) == "+!End") {
          int numCert = int.parse(listRecived[1]);
          _creatCertFile(numCert, data.getCert);
          _funCertState(numCert+1);
          
          //print(data.getCert1);
        } else {
          data.setCert = comando.substring(1);
          mandaMensagem("Cert");
        }
      }
    }

    if (comando == "Pong") {
      _funConectado();
    } else if (comando == "Temp") {
      data.setListTemp = [
        listRecived[1],
        listRecived[2],
        listRecived[3],
        listRecived[4]
      ];
    } else if (comando == "AlarmG") {
      int x = int.parse(listRecived[1]);
      data.alarmeGraus[x] = [listRecived[2], listRecived[3]];
      //attPage2([AlarmeGraus,AlarmeTimer]);
    } else if (comando == "AlarmT") {
      int x = int.parse(listRecived[1]);
      data.alarmeTimer[x] = [listRecived[2], listRecived[3]];
      //attPage2([AlarmeGraus,AlarmeTimer]);
    } else if (comando == "NotT") {
      if (listRecived[1] == "0") {
        //NotificationService().showNotification(CustomNotification(id: 1, title: 'Alarme', body: 'Alarme de ${listRecived[2]} minutos concluído', payload: 'GoAlarmes'));
      } else if (listRecived[1] == "1") {
        //NotificationService().showNotification(CustomNotification(id: 1, title: 'Alarme', body: 'Alarme de ${listRecived[1]} hora e ${listRecived[2]} minutos concluído', payload: 'GoAlarmes'));
      } else {
        //NotificationService().showNotification(CustomNotification(id: 1, title: 'Alarme', body: 'Alarme de ${listRecived[1]} horas e ${listRecived[2]} minutos concluído', payload: 'GoAlarmes'));
      }
    } else if (comando == "NotG") {
      if (listRecived[1] == "Grelha") {
        //NotificationService().showNotification(CustomNotification(id: 1, title: 'Temperatura da ${listRecived[1]}', body: 'Temperatura da ${listRecived[1]} alcançou ${listRecived[2]} graus', payload: 'GoAlarmes'));
      } else if (listRecived[1] == "Sensor1") {
        //NotificationService().showNotification(CustomNotification(id: 1, title: 'Temperatura do Sensor 1', body: 'Temperatura do Sensor 1 alcançou ${listRecived[2]} graus', payload: 'GoAlarmes'));
      } else if (listRecived[1] == "Sensor2") {
        //NotificationService().showNotification(CustomNotification(id: 1, title: 'Temperatura do Sensor 2', body: 'Temperatura do Sensor 2 alcançou ${listRecived[2]} graus', payload: 'GoAlarmes'));
      }
    }
  }

  void mandaMensagem(String msg) async {
    if (_blueCharacteristicToSend == null) {
      print("EEEEEEEEEEERRRRRRRRRRRRRRRRRRROOOOOOOOOOOORRRRRRRRRRRRRRR");
    } else {
      _blueCharacteristicToSend!.write(utf8.encode(msg)); //Só para mandar
    }
  }

  void _creatCertFile(int numCert, String _data) {
    final _fileNames = ["device.pem.crt","private.pem.key","rootCA.pem"];
    File file;
    getApplicationDocumentsDirectory().then((directory) => {
          file = File('${directory.path}/AWS/${_fileNames[numCert]}'),
          file.create(recursive: true).then((_) => {
                file.writeAsString(_data),
                file.readAsString().then((contents) => print(contents))
              }),
        });
  }

  //End blue Class
}