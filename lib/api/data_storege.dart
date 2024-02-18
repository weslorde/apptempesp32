import 'package:apptempesp32/api/blue_api.dart';
import 'dart:math' as math;

class AllData {
  static final AllData _shared = AllData._sharedInstance();
  AllData._sharedInstance();
  factory AllData({Function(int)? attPageState}) => _shared;

  final BlueController _blue = BlueController();

  String _tGrelha = '000';
  String _tSensor1 = '000';
  String _tSensor2 = '000';
  String _tAlvo = '000';

  String _cert = "";

  String _wifiLogin = "";
  String _wifiPassword = "";

  String _selectedRecipe = "0";

  get tGrelha => int.parse(_tGrelha);
  get tSensor1 => int.parse(_tSensor1);
  get tSensor2 => int.parse(_tSensor2);
  get tAlvo => int.parse(_tAlvo);
  
  get getListTemp => [_tGrelha, _tSensor1, _tSensor2, _tAlvo];

  get getCert => _cert;

  get getWifiLogin => _wifiLogin;
  get getWifiPassword => _wifiPassword;

  get getSelectedRecipe => _selectedRecipe;

  ///////////////////////// Set /////////////////////////////////////

  set setListTemp(List<String> list) {
    _tGrelha = list[0];
    _tSensor1 = list[1];
    _tSensor2 = list[2];
    _tAlvo = list[3];
  }

  set setCert(String part) {
    _cert = _cert + part;
  }

  set setWifiLogin(wifiLogin) => _wifiLogin = wifiLogin;
  set setWifiPassword(wifiPassword) => _wifiPassword = wifiPassword;

  set setSelectedRecipe(idRecipe) => _selectedRecipe = idRecipe;

  setCertBlank() {
    _cert = "";
  }

  List _alarmeGraus = [];
  List _alarmeTimer = [];

  zeraAlarms() {
    _alarmeGraus = [];
    _alarmeTimer = [];
  }

  set setAlarmGraus(alarm) => _alarmeGraus.add(alarm);
  set setAlarmeTimer(alarm) => _alarmeTimer.add(alarm);

  get getAlarmGraus => _alarmeGraus;
  get getAlarmeTimer => _alarmeTimer;

  testPrint() async {
    print(_alarmeGraus);
    print(_alarmeTimer);
  }

  List<List> getAlarm() {
    return [_alarmeGraus, _alarmeTimer];
  }

  void apagaAlarm(String name, int indice) {
    if (name == "timer") {
      _alarmeTimer = [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
      ]; //Reinicia lista para receber os valores que ficaram
    } else {
      _alarmeGraus = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    }

    print(_alarmeTimer);
    _blue.mandaMensagem("DelAlarme,$name,$indice");
    //attPage2([alarmeGraus,alarmeTimer]);
    _blue.mandaMensagem("Alarme"); // Solicita os valores
  }
}
