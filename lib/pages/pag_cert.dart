import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc_events.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_state.dart';
import 'package:apptempesp32/dialogs/close_alert.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PagCert extends StatelessWidget {
  const PagCert({super.key});

  @override
  Widget build(BuildContext context) {
    final BlueController blue = BlueController();
    final AwsController aws = AwsController();

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => onBackPressed(context),
      child: Scaffold(
        //Top Menu
        appBar: const TopBar(),

        //Bottom Menu
        // ignore: prefer_const_constructors
        bottomNavigationBar: BottomBar(),

        //Body (all pags)
        body: BlocProvider<CertBloc>(
          //BlocProvider above MaterialApp for all pages using the same bloc instance
          create: (BuildContext context) =>
              CertBloc(), // Call CertBloc() to pick inicial state
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<CertBloc, CertState>(
                  builder: ((context, state) {
                    return Column(
                      children: [
                        const SizedBox(width: 200),
                        if (state.stateActual == "InitState" ||
                            state.stateActual == "empty" ||
                            state.stateActual == 'WarningBlueConnect') ...[
                          const Text(
                              "Sincronizar aplicativo com o dispositivo"),
                          const Text(
                              "Mantenha o celular proximo para manter o bluetooth até o final do processo, pode demorar entre 1 e 2 minutos"),
                          TextButton(
                            onPressed: () {
                              context.read<CertBloc>().add(const InitState());
                            },
                            child: const Text('Iniciar'),
                          )
                        ] else if (state.stateActual == "SendAws") ...[
                          Text(state.stateActual),
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
                        ] else ...[
                          Text(state.stateActual)
                        ]
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
