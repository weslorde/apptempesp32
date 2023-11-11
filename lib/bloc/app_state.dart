import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final String stateActual;
  final bool blueSuported;
  final bool blueIsOn;
  final String msg;


  const AppState({
    required this.stateActual,
    required this.blueSuported,
    required this.blueIsOn,
    required this.msg,
  });

  const AppState.empty()
      : stateActual = 'empty',
        blueSuported = false,
        blueIsOn = false,
        msg = 'empty';

  @override
  String toString() => {
        'stateActual' : stateActual,
        'blueSuported': blueSuported,
        'blueIsOn': blueIsOn,
        'msg': msg,
      }.toString();
}
