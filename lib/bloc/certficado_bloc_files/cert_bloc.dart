import 'dart:io';

import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc_events.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_state.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CertBloc extends Bloc<CertEvent, CertState> {
  final BlueController _blue = BlueController();
  final AwsController _aws = AwsController();
  final PageIndex _pageController = PageIndex();

  void emitAll({required String stateActual, String msg = ''}) {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(
      CertState(
        stateActual: stateActual,
        msg: msg,
      ),
    );
  }

  void funCertState(int state) {
    final listState = [
      const CertStartOne(),
      const CertStartTwo(),
      const CertStartThree(),
      const CertDeviceName(),
      const CertEnd()
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

    //
    // Wifi to Boad Flow
    //
    on<InitWifiToBoard>((event, emit) async {
      emitAll(stateActual: 'InitWifiToBoard');
      add(const WifiCheckBlue());
    });

    on<WifiCheckBlue>((event, emit) async {
      emitAll(stateActual: 'WifiCheckBlue');
      if (_blue.getblueConnect) {
        add(const WifiForm());
      } else {
        add(const WifiWarningBlueConnect());
      }
    });

    on<WifiWarningBlueConnect>((event, emit) async {
      emitAll(stateActual: 'WifiWarningBlueConnect');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitWifiToBoard());
    });

    on<WifiForm>((event, emit) async {
      emitAll(stateActual: 'WifiForm');
    });

    //
    // Alexa link Email and Disp Flow
    //
    on<InitAlexaLink>((event, emit) async {
      emitAll(stateActual: 'InitAlexaLink');
      print("InitAlexaLink");
    });

    //
    // Cadastro Celular Flow
    //
    on<InitCertFiles>((event, emit) async {
      emitAll(stateActual: 'InitCertFiles');
      add(const CertCheckFiles());
    });

    on<CertCheckFiles>((event, emit) async {
      emitAll(stateActual: 'CertCheckFiles');
      if (await _aws.hasCertFiles()) {
        add(const CertWarningFiles());
      } else {
        add(const CertCheckBlue());
      }
    });

    on<CertWarningFiles>((event, emit) async {
      emitAll(stateActual: 'CertWarningFiles');
      print("JAAA TEM CERTIFICADO!!!!!!!!!!!");
      add(const CertCheckBlue());
    });

    on<CertCheckBlue>((event, emit) async {
      emitAll(stateActual: 'CertCheckBlue');
      if (_blue.getblueConnect) {
        add(const CertStartOne());
      } else {
        add(const CertWarningBlueConnect());
      }
    });

    on<CertWarningBlueConnect>((event, emit) async {
      emitAll(stateActual: 'CertWarningBlueConnect');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitState());
    });

    on<CertStartOne>((event, emit) async {
      emitAll(stateActual: 'CertStartOne');
      _blue.setfunCertState = funCertState;
      _blue.mandaMensagem("CertIni,0");
      add(const CertfOne());
    });

    on<CertfOne>((event, emit) async {
      emitAll(stateActual: 'CertfOne');
    });

    on<CertStartTwo>((event, emit) async {
      emitAll(stateActual: 'CertStartTwo');
      _blue.mandaMensagem("CertIni,1");
      add(const CertfTwo());
    });

    on<CertfTwo>((event, emit) async {
      emitAll(stateActual: 'CertfTwo');
    });

    on<CertStartThree>((event, emit) async {
      emitAll(stateActual: 'CertStartThree');
      _blue.mandaMensagem("CertIni,2");
      add(const CertfThree());
    });

    on<CertfThree>((event, emit) async {
      emitAll(stateActual: 'CertfThree');
    });

    on<CertDeviceName>((event, emit) async {
      emitAll(stateActual: 'CertDeviceName');
      _blue.mandaMensagem("DispCode");
    });

    on<CertEnd>((event, emit) async {
      emitAll(stateActual: 'CertEnd');
      await _aws.hasCertFiles();
      sleep(Duration(seconds: 3));
      add(const ALinkLoading());
    });

    // TestMQTT

    on<AWStest>((event, emit) async {
      emitAll(stateActual: 'AWStest');
    });

    // AlexaLink

    on<ALinkIni>((event, emit) async {
      emitAll(stateActual: 'ALinkIni');
    });

    on<ALinkTutorial1>((event, emit) async {
      emitAll(stateActual: 'ALinkTutorial1');
    });

    on<ALinkTutorial2>((event, emit) async {
      emitAll(stateActual: 'ALinkTutorial2');
    });

    on<ALinkTutorial3>((event, emit) async {
      emitAll(stateActual: 'ALinkTutorial3');
    });

    on<ALinkTutorial4>((event, emit) async {
      emitAll(stateActual: 'ALinkTutorial4');
    });

    on<ALinkTutorial5>((event, emit) async {
      emitAll(stateActual: 'ALinkTutorial5');
    });

    on<ALinkWaiting>((event, emit) async {
      emitAll(stateActual: 'ALinkWaiting');
    });

    on<ALinkDataRecived>((event, emit) async {
      emitAll(stateActual: 'ALinkDataRecived');
      add(const ALinkWaiting());
    });

    on<ALinkLoading>((event, emit) async {
      emitAll(stateActual: 'ALinkLoading');
    });

    on<ALinkWarning>((event, emit) async {
      emitAll(stateActual: 'ALinkWarning');
    });

    on<ALinkOk>((event, emit) async {
      emitAll(stateActual: 'ALinkOk');
    });

    //
    //espaço
    //
  }
}
