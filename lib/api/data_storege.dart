import 'dart:ffi';

import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/notificationAlarm.dart';
import 'dart:math' as math;

import 'package:shared_preferences/shared_preferences.dart';

class AllData {
  static final AllData _shared = AllData._sharedInstance();
  AllData._sharedInstance();
  factory AllData({Function(int)? attPageState}) => _shared;

  final BlueController _blue = BlueController();

  bool _darkMode = false;

  Set<String> _favoriteIdSet = {};

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

  String _searchText = "";

  bool _awsIotBoardConnect = false;

  bool _dynamoUserAlexaLink = false;

  bool _firstClientHasDisp = true;

  Function _favoritesUpdate = () {};

  Function _restartAppTree = () {};

  bool _alexaLinkPopLoad = false;

  int _fileIdDispActual = 1;

  List<String> _listDispNamesID = ["6666"];
  List<String> _listDispNames = ["Minha casa"];

  get darkMode => _darkMode;

  get getFavoriteIdList => _favoriteIdSet;

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

  get getSearchText => _searchText;

  get getAwsIotBoardConnect => _awsIotBoardConnect;

  get getDynamoUserAlexaLink => _dynamoUserAlexaLink;

  get getAlexaLinkPopLoad => _alexaLinkPopLoad;

  get getFirstClientHasDisp => _firstClientHasDisp;

  get getFileIdDispActual => _fileIdDispActual;

  String getMyDispNames(String myID) {
    int indice = _listDispNamesID.indexOf(myID);
    if (indice == -1) {
      return "0";
    }
    return _listDispNames[indice];
  }

  ///////////////////////// Set /////////////////////////////////////

  setDarkMode() {
    _darkMode = !_darkMode;
    _saveDarkMode();
  }

  setFavoriteIdSet(String id) {
    _favoriteIdSet.add(id);
    _saveFavoriteIdSet();
    print(_favoriteIdSet);
  }

  removeFavoriteIdSet(String id) {
    _favoriteIdSet.remove(id);
    _saveFavoriteIdSet();
    print(_favoriteIdSet);
  }

  setFavoritesUpdate(fun) => _favoritesUpdate = fun;
  get getFavoritesUpdate => _favoritesUpdate;

  setRestartAppTree(fun) => _restartAppTree = fun;
  get getRestartAppTree => _restartAppTree;

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

  set setSearchText(text) => _searchText = text;

  set setAwsIotBoardConnect(logic) => _awsIotBoardConnect = logic;

  set setDynamoUserAlexaLink(logic) => _dynamoUserAlexaLink = logic;

  set setAlexaLinkPopLoad(logic) => _alexaLinkPopLoad = logic;

  set setFirstClientHasDisp(logic) => _firstClientHasDisp = logic;

  set setFileIdDispActual(int num) =>
      {_fileIdDispActual = num, _saveActualDisp()};

  setListDispNames(String myID, String newName) {
    int indice = _listDispNamesID.indexOf(myID);
    if (indice == -1) {
      _listDispNamesID.add(myID);
      _listDispNames.add(newName);
    } else {
      _listDispNames[indice] = newName;
    }
    _saveDispNames();
  }

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
    //print("LOAD: ${prefs.getBool('darkMode')}");
    _darkMode = prefs.getBool('darkMode') ?? false;
  }

  Future<void> _saveDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', _darkMode);
  }

  Future<void> loadActualDisp() async {
    print("Loading actualDisp");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("LOAD: ${prefs.getBool('darkMode')}");
    _fileIdDispActual = prefs.getInt('actualDisp') ?? 0;
    print("Actual Disp ID: $_fileIdDispActual");
  }

  Future<void> _saveActualDisp() async {
    print("Save actualDisp");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('actualDisp', _fileIdDispActual);
  }

  Future<void> _saveDispNames() async {
    print("Save DispNames");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('listDispNames', _listDispNames);
    await prefs.setStringList('listDispNamesID', _listDispNamesID);
  }

  Future<void> loadDispNames() async {
    print("Loading DispNames");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("LOAD: ${prefs.getBool('darkMode')}");
    _listDispNames = prefs.getStringList('listDispNames') ?? ["Minha casa"];
    _listDispNamesID = prefs.getStringList('listDispNamesID') ?? ["6666"];
  }

  Future<void> loadFavoriteIdList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print("LOAD: ${prefs.getStringList('FavIdList')}");
    var idList = prefs.getStringList('FavIdList') ?? [];
    _favoriteIdSet = idList.toSet();
  }

  Future<void> _saveFavoriteIdSet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('FavIdList', _favoriteIdSet.toList());
  }

  startNotificationAlarm(String tipoAlarm, val1, val2) {
    if (tipoAlarm == "Timer") {
      if (val1 == "0") {
        NotificationService().showNotification(CustomNotification(
            id: 1,
            title: 'Alarme',
            body: 'Alarme de ${val2} minutos concluído',
            payload: 'GoAlarmes'));
      } else if (val1 == "1") {
        NotificationService().showNotification(CustomNotification(
            id: 1,
            title: 'Alarme',
            body: 'Alarme de ${val1} hora e ${val2} minutos concluído',
            payload: 'GoAlarmes'));
      } else {
        NotificationService().showNotification(CustomNotification(
            id: 1,
            title: 'Alarme',
            body: 'Alarme de ${val1} horas e ${val2} minutos concluído',
            payload: 'GoAlarmes'));
      }
    } else if (tipoAlarm == "Graus") {
      if (val1 == "Grelha") {
        NotificationService().showNotification(CustomNotification(
            id: 1,
            title: 'Temperatura da ${val1}',
            body: 'Temperatura da ${val1} alcançou ${val2} graus',
            payload: 'GoAlarmes'));
      } else if (val1 == "Sensor1") {
        NotificationService().showNotification(CustomNotification(
            id: 1,
            title: 'Temperatura do Sensor 1',
            body: 'Temperatura do Sensor 1 alcançou ${val2} graus',
            payload: 'GoAlarmes'));
      } else if (val1 == "Sensor2") {
        NotificationService().showNotification(CustomNotification(
            id: 1,
            title: 'Temperatura do Sensor 2',
            body: 'Temperatura do Sensor 2 alcançou ${val2} graus',
            payload: 'GoAlarmes'));
      }
    }
  }
}
