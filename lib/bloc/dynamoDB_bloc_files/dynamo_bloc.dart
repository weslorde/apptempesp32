import 'package:apptempesp32/api/aws_dynamodb_api.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc_events.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DynamoBloc extends Bloc<DynamoEvent, DynamoState> {
  final AwsDynamoDB _dynamo = AwsDynamoDB();

  void emitAll(
      {required String stateActual, String msg = '', dynamic recipesAll = ''}) {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(
      DynamoState(
        stateActual: stateActual,
        msg: msg,
        recipesAll: recipesAll,
      ),
    );
  }
  //_dynamo.getRecipeData

  DynamoBloc() //When call or creat the AppBloc start the initial state
      : super(
          const DynamoState.empty(),
        ) {
    //Logic of ALL STATES -----------------------------------
    _dynamo.goDataOk(() => add(const DataOk()));

    on<InitState>((event, emit) async {
      emitAll(stateActual: 'InitState');
    });

    on<CheckData>((event, emit) async {
      emitAll(stateActual: 'CheckData');
      _dynamo.loadRecipeData();
    });

    on<DataOk>((event, emit) async {
      emitAll(stateActual: 'DataOk', recipesAll: _dynamo.getRecipeData);
      _dynamo.newRecipeData();
    });

    on<ErrorData>((event, emit) async {
      emitAll(stateActual: 'ErrorData');
    });
    //
    //espaço
    //
  }
}
