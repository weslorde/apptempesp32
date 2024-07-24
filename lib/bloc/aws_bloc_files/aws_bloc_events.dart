import 'package:flutter/foundation.dart' show immutable;

@immutable
class AwsEvent{
  const AwsEvent();
}

class InitStateAws implements AwsEvent{
  const InitStateAws();
}

class CheckFiles implements AwsEvent{
  const CheckFiles();
}

class WarningFiles implements AwsEvent{
  const WarningFiles();
}

class CheckConnect implements AwsEvent{
  const CheckConnect();
}

class WarningInternet implements AwsEvent{
  const WarningInternet();
}

class CheckAwsConnect implements AwsEvent{
  const CheckAwsConnect();
}
class WarningAwsConnect implements AwsEvent{
  const WarningAwsConnect();
}

class StartAws implements AwsEvent{
  const StartAws();
}

class ConnectAws implements AwsEvent{
  const ConnectAws();
}

class SendAws implements AwsEvent{
  const SendAws();
}

class RecivedData implements AwsEvent{
  const RecivedData();
}

class AwsConnected implements AwsEvent{
  const AwsConnected();
}

