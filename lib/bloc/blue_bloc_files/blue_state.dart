import 'package:flutter/foundation.dart' show immutable;

@immutable
class BlueState {
  final String stateActual;
  final String screenMsg;
  final bool blueSuported;
  final bool blueIsOn;
  final bool blueTurningOn;
  final bool blueLinked;
  final bool blueConnect;
  final String msg;


  const BlueState({
    required this.stateActual,
    required this.screenMsg,
    required this.blueSuported,
    required this.blueIsOn,
    required this.blueTurningOn,
    required this.blueLinked,
    required this.msg,
    required this.blueConnect,
  });

  const BlueState.empty()
      : stateActual = 'empty',
        screenMsg = 'vazio',
        blueSuported = false,
        blueIsOn = false,
        blueTurningOn = false,
        blueLinked = false,
        blueConnect = false,
        msg = 'empty';

  @override
  String toString() => {
        'stateActual' : stateActual,
        'blueSuported': blueSuported,
        'blueIsOn': blueIsOn,
        'blueTurningOn': blueTurningOn,
        'blueLinked': blueLinked,
        'blueConnect': blueConnect,
        'msg': msg,
      }.toString();
}
