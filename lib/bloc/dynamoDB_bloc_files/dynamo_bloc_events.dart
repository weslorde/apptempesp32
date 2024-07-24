import 'package:flutter/foundation.dart' show immutable;

@immutable
class DynamoEvent{
  const DynamoEvent();
}

class InitStateDynamo implements DynamoEvent{
  const InitStateDynamo();
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
