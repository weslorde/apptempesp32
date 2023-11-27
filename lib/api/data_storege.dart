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
  
  get tGrelha => int.parse(_tGrelha);
  get tSensor1 => int.parse(_tSensor1);
  get tSensor2 => int.parse(_tSensor2);
  get tAlvo => int.parse(_tAlvo);

  get getListTemp => [_tGrelha, _tSensor1, _tSensor2, _tAlvo];

  get getCert => _cert;

  //////////////////////////////////////////////////////////////
  
  set setListTemp(List<String> list) {
    _tGrelha = list[0];
    _tSensor1 = list[1];
    _tSensor2 = list[2];
    _tAlvo = list[3];
    attCalculaValores();
  }

  set setCert(String part){_cert = _cert + part;}
  setCertBlank(){_cert = "";}


  List alarmeGraus = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]; //[0,0,0,0,0,0,0,0];
  List alarmeTimer = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

  testPrint() async {
    print(alarmeGraus);
    //print(alarmeTimer);
  }

  List<List> getAlarm() {
    return [alarmeGraus, alarmeTimer];
  }

  void apagaAlarm(String name, int indice) {
    if (name == "timer") {
      alarmeTimer = [
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
      alarmeGraus = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    }
    print(alarmeTimer);
    _blue.mandaMensagem("DelAlarme,$name,$indice");
    //attPage2([alarmeGraus,alarmeTimer]);
    _blue.mandaMensagem("Alarme"); // Solicita os valores
  }

  final _totalSteps = 50;
  double _stepsToPi = 0.0;
  int _currentStep = 0;
  int _targetStep = 0;

  void attCalculaValores() {
    _stepsToPi = (2 * math.pi - 2 * math.pi / 6) /
        _totalSteps; // (Total size - unused size) / number of Steps = Size of each steps
    _currentStep = ((int.parse(_tGrelha) - 0) * (_totalSteps - 0) / (300 - 0) +
            (0))
        .toInt(); // ValNovaEscala = ((ValEscalaVelha - MinVelho) * (MaxNovo - (MinNovo)) / (MaxVelho - MinVelho) + (MinNovo))
    _targetStep =
        ((int.parse(_tAlvo) - 0) * (_totalSteps - 0) / (300 - 0) + (0)).toInt();
  }

  

  get totalSteps => _totalSteps;
  get stepsToPi => _stepsToPi;
  get currentStep => _currentStep;
  get targetStep => _targetStep;
}
