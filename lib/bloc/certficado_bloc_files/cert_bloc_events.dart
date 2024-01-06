import 'package:flutter/foundation.dart' show immutable;

@immutable
class CertEvent{
  const CertEvent();
}

class InitState implements CertEvent{
  const InitState();
}

//
// Wifi to Boad Flow
//
class InitWifiToBoard implements CertEvent{
  const InitWifiToBoard();
}

class WifiCheckBlue implements CertEvent{
  const WifiCheckBlue();
}

class WifiWarningBlueConnect implements CertEvent{
  const WifiWarningBlueConnect();
}

class WifiForm implements CertEvent{
  const WifiForm();
}

//
// Alexa link Email and Disp Flow
//
class InitAlexaLink implements CertEvent{
  const InitAlexaLink();
}

class InitAlexaLink2 implements CertEvent{
  const InitAlexaLink2();
}

//
// Cadastro Celular Flow
//
class InitCertFiles implements CertEvent{
  const InitCertFiles();
}

class CertCheckFiles implements CertEvent{
  const CertCheckFiles();
}

class CertWarningFiles implements CertEvent{
  const CertWarningFiles();
}

class CertCheckBlue implements CertEvent{
  const CertCheckBlue();
}

class CertWarningBlueConnect implements CertEvent{
  const CertWarningBlueConnect();
}

class CertStartOne implements CertEvent{
  const CertStartOne();
}

class CertfOne implements CertEvent{
  const CertfOne();
}

class CertStartTwo implements CertEvent{
  const CertStartTwo();
}

class CertfTwo implements CertEvent{
  const CertfTwo();
}

class CertStartThree implements CertEvent{
  const CertStartThree();
}

class CertfThree implements CertEvent{
  const CertfThree();
}

class CertDeviceName implements CertEvent{
  const CertDeviceName();
}

class CertEnd implements CertEvent{
  const CertEnd();
}
//Fim Cadastro Celular Flow