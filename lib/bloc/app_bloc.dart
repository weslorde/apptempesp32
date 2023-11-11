import 'dart:convert';

import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/bloc/app_state.dart';
import 'package:apptempesp32/bloc/bloc_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final BlueController _blue = BlueController();

  void emitAll({required String stateActual, String msg = ''}) {
    emit(
      AppState(
        stateActual: stateActual,
        blueSuported: _blue.getBlueSup,
        blueIsOn: _blue.getBlueIsOn,
        msg: msg,
      ),
    );
  }

  AppBloc() //When call or creat the AppBloc start the initial state
      : super(
          const AppState.empty(),
        ) {
    //Logic of ALL STATES -----------------------------------
    on<InitState>((event, emit) async {
      emitAll(stateActual: 'InitState');
    });

    on<BlueIsSup>((event, emit) async {
      // check adapter availability
      // Note: The platform is initialized on the first call to any FlutterBluePlus method.
      bool test = await FlutterBluePlus.isAvailable;
      if (test == false) {
        _blue.setblueSup = false;
        emitAll(stateActual: 'BlueIsSup');
        add(const WarningBlueSup());
      } else {
        _blue.setblueSup = true;
        emitAll(stateActual: 'BlueIsSup');
        add(const BlueIsOn());
        
      }
    });

    on<WarningBlueSup>((event, emit) async {
      emitAll(stateActual: 'WarningBlueSup', msg: 'Bluetooth não suportado');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitState());
    });

    on<BlueIsOn>((event, emit) {
      [
        Permission.location,
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan
      ].request().then((status) {
        //print('$status');
        //print(status[Permission.location]);
        //print(status[Permission.bluetooth]);
        
      });

      FlutterBluePlus.setLogLevel(LogLevel.verbose);
      // handle bluetooth on & off
      // note: for iOS the initial state is typically BluetoothAdapterState.unknown
      // note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
      FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
        // BluetoothAdapterState { unknown, unavailable, unauthorized, turningOn, on, turningOff, off }
        if (state == BluetoothAdapterState.on) {
          _blue.setBlueIsOn = true;
          emitAll(stateActual: 'BlueIsOn');
          add(const BlueStartScan());
        } else if (state == BluetoothAdapterState.off) {
          _blue.setBlueIsOn = false;
          emitAll(stateActual: 'BlueIsOn');
          add(const WarningBlueOff());
        }
      });
    });

    on<WarningBlueOff>((event, emit) async {
      emitAll(stateActual: 'WarningBlueOff', msg: 'Bluetooth não está ligado');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitState());
    });

    on<BlueStartScan>((event, emit) async {
      emitAll(stateActual: 'BlueStartScan');

      // Creating the scanResults Listen
      Set<DeviceIdentifier> seen = {}; //Save all devices founds in ScanResult
      FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult r in results) {
          // If device exist in "seen" -> ignore
          if (seen.contains(r.device.remoteId) == false) {
            seen.add(r.device.remoteId); // Add new device to "seen"
            if (r.advertisementData.localName == "ChurrasTech") {
              _blue.setDevice = r.device; // Save target device to use later
            }
          }
        }
      });

      //Creating the Scanning Listen
      FlutterBluePlus.isScanning.listen(
        (isScan) {
          if (!isScan) {
            // If Scan is finished
            final device = _blue.getDevice;
            if (device == null) {
              // Check if target device was found
              add(const WarningDeviceNotFound());
            } else {
              add(const BlueStartConnect());
            }
          }
        },
      );

      _blue.setDevice = null;
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    });

    on<WarningDeviceNotFound>((event, emit) async {
      emitAll(
          stateActual: 'WarningDeviceNotFound',
          msg: 'Dispositivo Não encontrado');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitState());
    });

    on<BlueStartConnect>((event, emit) async {
      emitAll(stateActual: 'BlueStartConnect', msg: 'Iniciando Conexão');
      final device = _blue.getDevice!;
      device.connectionState.listen((BluetoothConnectionState connectState) {
        if (connectState == BluetoothConnectionState.disconnected) {
          add(const WarningBlueDisconnect());
          // 1. typically, start a periodic timer that tries to
          //    periodically reconnect, or just call connect() again right now
          // 2. you must always re-discover services after disconnection!
          // 3. you should cancel subscriptions to all characteristics you listened to
        } else if (connectState == BluetoothConnectionState.connected) {
          add(const BlueStartDiscover());
        }
      });
      device.connect();
    });

    on<WarningBlueDisconnect>((event, emit) async {
      emitAll(
          stateActual: 'WarningBlueDisconnect',
          msg: 'Dispositivo Desconectado');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitState());
    });

    on<BlueStartDiscover>((event, emit) async {
      emitAll(stateActual: 'BlueStartDiscover');

      // Note: You must call discoverServices after every connection!
      _blue.discoveryDevice();

      add(const InitState());
    });

    //
    //espaço
    //
  }
}
