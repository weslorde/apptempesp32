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
      const EndCertf()
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
    });

    on<CheckBlue>((event, emit) async {
      emitAll(stateActual: 'CheckBlue');
      if (_blue.getblueConnect) {
        add(const StartOne());
      } else {
        add(const WarningBlueConnect());
      }
    });

    on<WarningBlueConnect>((event, emit) async {
      emitAll(stateActual: 'WarningBlueConnect not connect');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitState());
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

    on<EndCertf>((event, emit) async {
      emitAll(stateActual: 'EndCertf');
    });

    //
    //espaço
    //
  }
}
