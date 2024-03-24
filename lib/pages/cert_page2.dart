import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc_events.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_state.dart';
import 'package:apptempesp32/dialogs/close_alert.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';

class PagCert extends StatelessWidget {
  const PagCert({super.key});

  @override
  Widget build(BuildContext context) {
    final BlueController blue = BlueController();
    final AwsController aws = AwsController();
    final AllData _data = AllData();
    final PageIndex _pageController = PageIndex();

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => {_pageController.setIndex = 0},
      child: Scaffold(
        backgroundColor:
            _data.darkMode ? Colors.white : HexColor.fromHex('#101010'),
        appBar: TopBar(),
        //
        bottomNavigationBar: BottomBar(),
        //
        body: MultiBlocProvider(
          providers: [
            BlocProvider<CertBloc>(
              create: (BuildContext context) => CertBloc(),
            )
          ],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Builder(
                  builder: (context) {
                    final certState = context.watch<CertBloc>().state;
                    final awsState = context.watch<AwsBloc>().state;
                    final blueState = context.watch<BlueBloc>().state;

                    return Column(
                      children: [
                        const SizedBox(width: 200),
                        // Inicial State
                        if (certState.stateActual == "InitState" ||
                            certState.stateActual == "empty")
                          ...widgetIniState(context.read<CertBloc>())
                        // State Wifi to Board
                        else if (certState.stateActual == "WifiForm")
                          ...widgetWifiForm(
                              context.read<CertBloc>(), blue, _data)
                        else if (certState.stateActual == "WarningFiles") ...[
                          Text(blueState.stateActual),
                          const Text(
                              "Sincronizar aplicativo com o dispositivo"),
                          const Text(
                              "Mantenha o celular proximo para manter o bluetooth até o final do processo, pode demorar entre 1 e 2 minutos"),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<CertBloc>()
                                  .add(const CertCheckFiles());
                            },
                            child: const Text('Iniciar'),
                          )
                        ]
                        // State
                        else if (certState.stateActual == "WarningFiles") ...[
                          Text(blueState.stateActual),
                          const Text("Celular já sincronizado"),
                          const Text(
                              "Gostaria de realizar a sincronização novamente e sobrepor os arquivos?"),
                          TextButton(
                            onPressed: () {
                              context
                                  .read<CertBloc>()
                                  .add(const CertCheckBlue());
                            },
                            child: const Text('Iniciar'),
                          )
                        ]
                        // State
                        else if (certState.stateActual == "SendAws") ...[
                          Text(certState.stateActual),
                          const SizedBox(
                            height: 50,
                          ),
                          TextButton(
                            onPressed: () {
                              const topic =
                                  '\$aws/things/ChurrasTech2406/shadow/name/TemperaturesShadow/update';
                              const msg =
                                  '{"state": {"desired": {"TAlvoFlutter": "166"}}}';
                              aws.awsMsg(topic, msg);
                            },
                            child: const Text('MandarAWS'),
                          )
                        ]
                        // Else State
                        else ...[
                          Text(
                            certState.stateActual,
                            style: TextStyle(
                              color:
                                  _data.darkMode ? Colors.black : Colors.white,
                            ),
                          )
                        ]
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Widget> widgetIniState(contextBloc) {
  return [
    ElevatedButton(
      child: const Text("Wifi Churrasqueira"),
      onPressed: () {
        contextBloc.add(const InitWifiToBoard());
      },
    ),
    ElevatedButton(
      child: const Text("Cert Celular"),
      onPressed: () {
        contextBloc.add(const InitCertFiles());
      },
    ),
    ElevatedButton(
      child: const Text("Alexa Linking"),
      onPressed: () {
        contextBloc.add(const InitAlexaLink());
      },
    ),
  ];
}

List<Widget> widgetWifiForm(contextBloc, BlueController blue, AllData data) {
  final loginWifiController = TextEditingController();
  final passwordWifiController = TextEditingController();

  return [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          TextField(
            controller: loginWifiController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Rede Wifi',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: passwordWifiController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Senha Wifi',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                print(
                    "${loginWifiController.text} - ${passwordWifiController.text}");
                data.setWifiLogin = loginWifiController.text;
                data.setWifiPassword = passwordWifiController.text;
                blue.mandaMensagem("Wifi");
              },
              child: Text('Enviar'))
        ],
      ),
    )
  ];
}
