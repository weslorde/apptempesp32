import 'package:flutter/foundation.dart' show immutable;

@immutable
class DynamoEvent{
  const DynamoEvent();
}

class InitState implements DynamoEvent{
  const InitState();
}

class CheckData implements DynamoEvent{
  const CheckData();
}

class DataOk implements DynamoEvent{
  const DataOk();
}

class ErrorData implements DynamoEvent{
  const ErrorData();
}
