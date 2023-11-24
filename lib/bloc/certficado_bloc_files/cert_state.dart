import 'package:flutter/foundation.dart' show immutable;

@immutable
class CertState {
  final String stateActual;
  final String msg;


  const CertState({
    required this.stateActual,
    required this.msg,
  });

  const CertState.empty()
      : stateActual = 'empty',
        msg = 'empty';

  @override
  String toString() => {
        'stateActual' : stateActual,
        'msg': msg,
      }.toString();
}
