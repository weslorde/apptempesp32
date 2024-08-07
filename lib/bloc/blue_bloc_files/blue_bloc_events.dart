import 'package:flutter/foundation.dart' show immutable;

@immutable
class BlueEvent{
  const BlueEvent();
}

class InitStateBlue implements BlueEvent{
  const InitStateBlue();
}

@immutable
class BlueIsSup implements BlueEvent{
  const BlueIsSup();
}

class BlueIsOn implements BlueEvent{
  const BlueIsOn();
}

class LocationisOn implements BlueEvent{
  const LocationisOn();
}

class BlueStartScan implements BlueEvent{
  const BlueStartScan();
}

class BlueStartConnect implements BlueEvent{
  const BlueStartConnect();
}


class BlueStartDiscover implements BlueEvent{
  const BlueStartDiscover();
}

class BlueConectado implements BlueEvent{
  const BlueConectado();
}

class RecivedData implements BlueEvent{
  const RecivedData();
}

/*
class BlueServices implements AppEvent{
  const BlueServices();
}

class BlueOk implements AppEvent{
  const BlueOk();
}
*/
class WarningBlueSup implements BlueEvent{
  const WarningBlueSup();
}

class WarningBlueOff implements BlueEvent{
  const WarningBlueOff();
}

class WarningLocationOff implements BlueEvent{
  const WarningLocationOff();
}

class WarningDeviceNotFound implements BlueEvent{
  const WarningDeviceNotFound();
}

class WarningBlueDisconnect implements BlueEvent{
  const WarningBlueDisconnect();
}