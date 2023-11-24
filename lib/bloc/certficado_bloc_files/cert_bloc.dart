import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc_events.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertBloc extends Bloc<CertEvent, CertState> {
  final BlueController _blue = BlueController();
  final AwsController _aws = AwsController();

  void emitAll({required String stateActual, String msg = ''}) {
    emit(
      CertState(
        stateActual: stateActual,
        msg: msg,
      ),
    );
  }

  void funCertState(int state) {
    final listState = [
      const StartOne(),
      const StartTwo(),
      const StartThree(),
      const CheckConnect()
    ];
    add(listState[state]);
  }

  CertBloc() //When call or creat the AppBloc start the initial state
      : super(
          const CertState.empty(),
        ) {
    //Logic of ALL STATES -----------------------------------

    on<InitState>((event, emit) async {
      emitAll(stateActual: 'InitState');
      //print(await _aws.hasCertFiles());
      add(const CheckConnect());
      /*
      if (_blue.getblueConnect) {
        add(const StartOne());
      } else {
        add(const WarningBlueConnect());
      }*/
    });

    on<WarningBlueConnect>((event, emit) async {
      emitAll(stateActual: 'WarningBlueConnect');
    });

    on<StartOne>((event, emit) async {
      emitAll(stateActual: 'StartOne');
      _blue.setfunCertState = funCertState;
      _blue.mandaMensagem("CertIni,0");
      add(const CertfOne());
    });

    on<CertfOne>((event, emit) async {
      emitAll(stateActual: 'CertfOne');
    });

    on<StartTwo>((event, emit) async {
      emitAll(stateActual: 'StartTwo');
      _blue.mandaMensagem("CertIni,1");
      add(const CertfTwo());
    });

    on<CertfTwo>((event, emit) async {
      emitAll(stateActual: 'CertfTwo');
    });

    on<StartThree>((event, emit) async {
      emitAll(stateActual: 'StartThree');
      _blue.mandaMensagem("CertIni,2");
      add(const CertfThree());
    });

    on<CertfThree>((event, emit) async {
      emitAll(stateActual: 'CertfThree');
    });

    on<CheckConnect>((event, emit) async {
      emitAll(stateActual: 'CheckConnect');
      if (await _aws.hasInternet()) {
        await _aws.creatClient();
        add(const StartAws());
      } else {
        add(const WarningBlueConnect());
      }
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
      print('send');
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
