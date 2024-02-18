import 'package:flutter/foundation.dart' show immutable;

@immutable
class DynamoState {
  final String stateActual;
  final String msg;
  final dynamic recipesAll;


  const DynamoState({
    required this.stateActual,
    required this.msg,
    required this.recipesAll,
  });

  const DynamoState.empty()
      : stateActual = 'empty',
        msg = 'empty',
        recipesAll = '';

}
