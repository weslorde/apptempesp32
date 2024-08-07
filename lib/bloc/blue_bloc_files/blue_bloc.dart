import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

class BlueBloc extends Bloc<BlueEvent, BlueState> {
  final BlueController _blue = BlueController();

  void emitAll({required String stateActual, String msg = ''}) {
    emit(
      BlueState(
        stateActual: stateActual,
        screenMsg: _blue.getScreenMsg,
        blueSuported: _blue.getBlueSup,
        blueIsOn: _blue.getBlueIsOn,
        blueTurningOn: _blue.getBlueTurningOn,
        blueLinked: _blue.getBlueLinked,
        blueConnect: _blue.getblueConnect,
        msg: msg,
      ),
    );
  }

  BlueBloc() //When call or creat the AppBloc start the initial state
      : super(
          const BlueState.empty(),
        ) {
    //Logic of ALL STATES -----------------------------------

    on<InitStateBlue>((event, emit) async {
      _blue.setBlueLinked = false;
      _blue.setBlueIsOn = false;
      _blue.setLocatIsOn = false;
      emitAll(stateActual: 'InitState');
    });

    on<BlueIsSup>((event, emit) async {
      // check adapter availability
      // Note: The platform is initialized on the first call to any FlutterBluePlus method.
      bool test = await FlutterBluePlus.isSupported;
      _blue.setScreenMsg = 'Iniciando';
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
      _blue.setScreenMsg = 'Falha';
      emitAll(stateActual: 'WarningBlueSup', msg: 'Bluetooth não suportado');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitStateBlue());
    });

    on<BlueIsOn>((event, emit) {
      [
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan
      ].request().then((status) {});
      FlutterBluePlus.setLogLevel(LogLevel.verbose);
      // handle bluetooth on & off
      // note: for iOS the initial state is typically BluetoothAdapterState.unknown
      // note: if you have permissions issues you will get stuck at BluetoothAdapterState.unauthorized
      var subscription =
          FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
        // BluetoothAdapterState { unknown, unavailable, unauthorized, turningOn, on, turningOff, off }
        if (state == BluetoothAdapterState.on && !_blue.getBlueIsOn) {
          //Logic to only call one time on a simutaly mult call
          _blue.setBlueIsOn = true;
          emitAll(stateActual: 'BlueIsOn');
          add(const LocationisOn());
        } else if (state == BluetoothAdapterState.off &&
            !_blue.getBlueTurningOn) {
          //Logic to only call one time on a simutaly mult call
          _blue.setBlueIsOn = false;
          _blue.setBlueTurningOn = true;
          emitAll(stateActual: 'BlueIsOn');
          add(const WarningBlueOff());
        }
      });
    });

    on<WarningBlueOff>((event, emit) async {
      _blue.setScreenMsg = 'Bluetooth Desligado';
      emitAll(stateActual: 'WarningBlueOff', msg: 'Bluetooth não está ligado');
      await Future.delayed(const Duration(seconds: 2));

      //////////////////////////////////////////REVER ISSO AQUI PENSAR MELHOR!! Cria o avise de reabrir que as vezes buga
      try {
        await FlutterBluePlus.turnOn();
      } on Exception catch (_) {}
      _blue.setBlueTurningOn = false;
      add(const InitStateBlue());
    });

    on<LocationisOn>((event, emit) async {
      emitAll(stateActual: 'LocationisOn');

      Permission.location.request().then((status) {});

      Location location = Location();

      if (await location.serviceEnabled()) {
        add(const BlueStartScan());
      } else {
        if (await location.requestService()) {
          add(const BlueStartScan());
        } else {
          add(const WarningLocationOff());
        }
      }
    });

    on<WarningLocationOff>((event, emit) async {
      _blue.setScreenMsg = 'GPS Desligado';
      _blue.setBlueIsOn = false; //When try to conect again need to be false
      emitAll(
          stateActual: 'WarningLocationOff',
          msg: 'Localização não está ligado');
      await Future.delayed(const Duration(seconds: 3));
      add(const InitStateBlue());
    });

    on<BlueStartScan>((event, emit) async {
      _blue.setScreenMsg = 'Buscando';
      emitAll(stateActual: 'BlueStartScan');

      // Creating the scanResults Listen
      Set<DeviceIdentifier> seen = {}; //Save all devices founds in ScanResult
      FlutterBluePlus.onScanResults.listen(
        (results) async {
          for (ScanResult r in results) {
            // If device exist in "seen" -> ignore
            if (seen.contains(r.device.remoteId) == false) {
              seen.add(r.device.remoteId); // Add new device to "seen"
              if (r.advertisementData.advName == "ChurrasTech" ||
                  r.advertisementData.advName == "Esp32") {
                _blue.setDevice = r.device; // Save target device to use later
              }
            }
          }
        },
      );

      //Creating the Scanning Listen

      FlutterBluePlus.isScanning.skip(1).listen(
        //Now skip is necessariy to ignore firs false result on start of onScanResults.listen
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
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));
    });

    on<WarningDeviceNotFound>((event, emit) async {
      _blue.setScreenMsg = 'Churrasqueira não encontrada';
      emitAll(
          stateActual: 'WarningDeviceNotFound',
          msg: 'Dispositivo Não encontrado');
      await Future.delayed(const Duration(seconds: 5));
      add(const InitStateBlue());
    });

    on<BlueStartConnect>((event, emit) async {
      _blue.setScreenMsg = 'Conectando';
      emitAll(stateActual: 'BlueStartConnect', msg: 'Iniciando Conexão');
      final device = _blue.getDevice!;
      var subscription = device.connectionState
          .listen((BluetoothConnectionState connectState) {
        //print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA: $connectState");
        if (connectState == BluetoothConnectionState.disconnected &&
            _blue.getBlueLinked) {
          _blue.setBlueLinked = false;
          _blue.setblueConnect = false;
          _blue.setToggleBool = true;
          add(const WarningBlueDisconnect());
        } else if (connectState == BluetoothConnectionState.connected) {
          _blue.setBlueLinked = true;
          add(const BlueStartDiscover());
        }
      });
      device.cancelWhenDisconnected(subscription, delayed: true, next: true);

      device.connect();
    });

    on<WarningBlueDisconnect>((event, emit) async {
      _blue.setScreenMsg = 'Desconectado';
      emitAll(
          stateActual: 'WarningBlueDisconnect',
          msg: 'Dispositivo Desconectado');
      await Future.delayed(const Duration(seconds: 3));
      add(const InitStateBlue());
    });

    on<BlueStartDiscover>((event, emit) async {
      emitAll(stateActual: 'BlueStartDiscover');
      _blue.setfunConectado = () => {add(const BlueConectado())};
      _blue.setfunDataRecived = () => {add(const RecivedData())};
      //Note: You must call discoverServices after every connection!
      _blue.discoveryDevice();
    });

    on<BlueConectado>((event, emit) async {
      _blue.setScreenMsg = 'Conectado';
      if (_blue.getblueConnect) {
        //if has not conneted close ToggleBlue
        _blue.setToggleBool = false;
      }
      _blue.setblueConnect = true;
      emitAll(stateActual: 'BlueConectado');
    });

    on<RecivedData>((event, emit) async {
      emitAll(stateActual: 'RecivedData');
      add(const BlueConectado());
    });

    //
    //espaço
    //
  }
}