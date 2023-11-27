import 'package:flutter/foundation.dart' show immutable;

@immutable
class AwsState {
  final String stateActual;
  final String msg;


  const AwsState({
    required this.stateActual,
    required this.msg,
  });

  const AwsState.empty()
      : stateActual = 'empty',
        msg = 'empty';

  @override
  String toString() => {
        'stateActual' : stateActual,
        'msg': msg,
      }.toString();
}
