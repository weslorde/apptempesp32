import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc_events.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AwsBloc extends Bloc<AwsEvent, AwsState> {
  final AwsController _aws = AwsController();

  void emitAll({required String stateActual, String msg = ''}) {
    emit(
      AwsState(
        stateActual: stateActual,
        msg: msg,
      ),
    );
  }

  AwsBloc() //When call or creat the AppBloc start the initial state
      : super(
          const AwsState.empty(),
        ) {
    //Logic of ALL STATES -----------------------------------

    on<InitState>((event, emit) async {
      emitAll(stateActual: 'InitState');
    });

    on<CheckFiles>((event, emit) async {
      emitAll(stateActual: 'CheckFiles');
      if (await _aws.hasCertFiles()) {
        add(const CheckConnect());
      } else {
        add(const WarningFiles());
      }
    });

    on<WarningFiles>((event, emit) async {
      emitAll(stateActual: 'WarningFiles');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitState());
    });

    on<CheckConnect>((event, emit) async {
      emitAll(stateActual: 'CheckConnect');
      if (await _aws.hasInternet()) {
        await _aws.creatClient();
        add(const StartAws());
      } else {
        add(const WarningInternet());
      }
    });

    on<WarningInternet>((event, emit) async {
      emitAll(stateActual: 'WarningInternet');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitState());
    });

    on<StartAws>((event, emit) async {
      emitAll(stateActual: 'StartAws');
      await _aws.connectAWS();
      add(const ConnectAws());
    });

    on<ConnectAws>((event, emit) async {
      emitAll(stateActual: 'ConnectAws');
      await _aws.arrumar();
      add(const SendAws());
    });

    on<SendAws>((event, emit) async {
      emitAll(stateActual: 'SendAws');
      const topic =
          '\$aws/things/ChurrasTech2406/shadow/name/TemperaturesShadow/update';
      const msg = '{"state": {"desired": {"TAlvoFlutter": "166"}}}';
      _aws.awsMsg(topic, msg);
    });
    

//'\$aws/things/ChurrasTech2406/shadow/name/MotorShadow/update', '{"state": {"desired": {"Sentido": "${comandos[1]}","Nivel": "${comandos[2]}"}}}'

    //
    //espaço
    //
  }
}
