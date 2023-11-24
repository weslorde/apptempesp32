import 'package:flutter/foundation.dart' show immutable;

@immutable
class CertEvent{
  const CertEvent();
}

class InitState implements CertEvent{
  const InitState();
}

class WarningBlueConnect implements CertEvent{
  const WarningBlueConnect();
}

class StartOne implements CertEvent{
  const StartOne();
}

class CertfOne implements CertEvent{
  const CertfOne();
}

class StartTwo implements CertEvent{
  const StartTwo();
}

class CertfTwo implements CertEvent{
  const CertfTwo();
}

class StartThree implements CertEvent{
  const StartThree();
}

class CertfThree implements CertEvent{
  const CertfThree();
}

class CheckConnect implements CertEvent{
  const CheckConnect();
}





class StartAws implements CertEvent{
  const StartAws();
}

class ConnectAws implements CertEvent{
  const ConnectAws();
}

class SendAws implements CertEvent{
  const SendAws();
}
