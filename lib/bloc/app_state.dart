import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppState {
  final bool isLoading;
  final String data;
  final Object? error;

  const AppState({
    required this.isLoading,
    required this.data,
    required this.error,
  });

  const AppState.empty()
      : isLoading = false,
        data = 'estado Vazio',
        error = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'hasData': data != '',
        'error': error,
      }.toString();
}
