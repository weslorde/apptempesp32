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

    on<InitStateAws>((event, emit) async {
      emitAll(stateActual: 'InitState');
    });

    on<CheckConnect>((event, emit) async {
      emitAll(stateActual: 'CheckConnect');
      _aws.setfunWifiStatusOn = () => {add(const CheckFiles())};
      _aws.setfunWifiStatusOff = () => {}; //{add(const WarningInternet())};
      if (await _aws.hasInternet()) {
        add(const CheckFiles());
      } else {
        //add(const WarningInternet());
      }
    });

    on<WarningInternet>((event, emit) async {
      emitAll(stateActual: 'WarningInternet');
      _aws.setMQTTConnect = false;
      await Future.delayed(const Duration(seconds: 5));
      add(const InitStateAws());
    });

    on<CheckFiles>((event, emit) async {
      emitAll(stateActual: 'CheckFiles');
      if (await _aws.hasCertFiles()) {
        add(const CheckAwsConnect());
      } else {
        add(const WarningFiles());
      }
    });

    on<WarningFiles>((event, emit) async {
      emitAll(stateActual: 'WarningFiles');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitStateAws());
    });

    on<CheckAwsConnect>((event, emit) async {
      emitAll(stateActual: 'CheckConnect');
      if (_aws.getAwsHasNet) {
        try {
          await _aws.creatClient();
          add(const StartAws());
        } catch (e) {
          add(const WarningAwsConnect());
        }
      }
    });

    on<WarningAwsConnect>((event, emit) async {
      emitAll(stateActual: 'WarningAwsConnect');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitStateAws());
    });

    on<StartAws>((event, emit) async {
      _aws.setfunDataRecived = () => {add(const RecivedData())};
      emitAll(stateActual: 'StartAws');
      await _aws.connectAWS();
      add(const ConnectAws());
    });

    on<ConnectAws>((event, emit) async {
      emitAll(stateActual: 'ConnectAws');
      if (await _aws.arrumar()) {
        add(const SendAws());
      } else {
        print("ERRRRROOOO AO CONECTAR State ConnectAws");
      }
    });

    on<SendAws>((event, emit) async {
      emitAll(stateActual: 'SendAws');
      const topic = 'TemperaturesShadow/update';
      const msg =
          '{"state": {"desired": {"Flutter": "1", "Enviar": "1", "NotificaAlarm": "0", "CriaAlarm": "0", "DelAlarm": "0"}}}';
      _aws.awsMsg(topic, msg);
    });

    on<AwsConnected>((event, emit) async {
      emitAll(stateActual: 'AwsConnected');
    });

    on<RecivedData>((event, emit) async {
      emitAll(stateActual: 'RecivedData');
      add(const AwsConnected());
    });

//'\$aws/things/ChurrasTech2406/shadow/name/MotorShadow/update', '{"state": {"desired": {"Sentido": "${comandos[1]}","Nivel": "${comandos[2]}"}}}'

    //
    //espaço
    //
  }
}
