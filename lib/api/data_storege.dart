import 'dart:ffi';

import 'package:apptempesp32/api/blue_api.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class AllData {
  static final AllData _shared = AllData._sharedInstance();
  AllData._sharedInstance();
  factory AllData({Function(int)? attPageState}) => _shared;

  final BlueController _blue = BlueController();

  bool _darkMode = false;

  String _tGrelha = '000';
  String _tSensor1 = '000';
  String _tSensor2 = '000';
  String _tAlvo = '000';
  String _S1Alvo = '000';
  String _S2Alvo = '000';

  String _motorPos = "2";

  String _cert = "";

  String _wifiLogin = "";
  String _wifiPassword = "";

  String _selectedRecipe = "0";

  get darkMode => _darkMode;

  get tGrelha => int.parse(_tGrelha);
  get tSensor1 => int.parse(_tSensor1);
  get tSensor2 => int.parse(_tSensor2);
  get tAlvo => int.parse(_tAlvo);

  get getTargetTemp => [_S1Alvo, _S2Alvo];

  get getListTemp => [_tGrelha, _tSensor1, _tSensor2, _tAlvo];

  get getCert => _cert;

  get getWifiLogin => _wifiLogin;
  get getWifiPassword => _wifiPassword;

  get getSelectedRecipe => _selectedRecipe;

  get getMotorPos => int.parse(_motorPos);

  ///////////////////////// Set /////////////////////////////////////

  setDarkMode() {
    _darkMode = !_darkMode;
    _saveDarkMode();
  }

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

  set setMotorPos(pos) => _motorPos = pos;

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
  

  Future<void> loadDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("LOAD: ${prefs.getBool('darkMode')}");
    _darkMode = prefs.getBool('darkMode') ?? false;

  }

  Future<void> _saveDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _darkMode);
  }
}
