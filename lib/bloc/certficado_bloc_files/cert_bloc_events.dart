import 'package:flutter/foundation.dart' show immutable;

@immutable
class CertEvent{
  const CertEvent();
}

class InitState implements CertEvent{
  const InitState();
}

class CheckBlue implements CertEvent{
  const CheckBlue();
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

class EndCertf implements CertEvent{
  const EndCertf();
}