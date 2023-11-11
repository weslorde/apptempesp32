import 'package:flutter/foundation.dart' show immutable;

@immutable
class AppEvent{
  const AppEvent();
}

class InitState implements AppEvent{
  const InitState();
}

@immutable
class BlueIsSup implements AppEvent{
  const BlueIsSup();
}

class BlueIsOn implements AppEvent{
  const BlueIsOn();
}

class BlueStartScan implements AppEvent{
  const BlueStartScan();
}

class BlueStartConnect implements AppEvent{
  const BlueStartConnect();
}


class BlueStartDiscover implements AppEvent{
  const BlueStartDiscover();
}

/*
class BlueServices implements AppEvent{
  const BlueServices();
}

class BlueOk implements AppEvent{
  const BlueOk();
}
*/
class WarningBlueSup implements AppEvent{
  const WarningBlueSup();
}

class WarningBlueOff implements AppEvent{
  const WarningBlueOff();
}

class WarningDeviceNotFound implements AppEvent{
  const WarningDeviceNotFound();
}

class WarningBlueDisconnect implements AppEvent{
  const WarningBlueDisconnect();
}