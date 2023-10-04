import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppEvent{
  const AppEvent();
}

@immutable
class LoadNextUrlEvent implements AppEvent{
  const LoadNextUrlEvent();
}

class LoadNextUrlEvent2 implements AppEvent{
  const LoadNextUrlEvent2();
}