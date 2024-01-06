import 'package:flutter/foundation.dart' show immutable;

@immutable
class AwsEvent{
  const AwsEvent();
}

class InitState implements AwsEvent{
  const InitState();
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

class StartAws implements AwsEvent{
  const StartAws();
}

class ConnectAws implements AwsEvent{
  const ConnectAws();
}

class SendAws implements AwsEvent{
  const SendAws();
}
