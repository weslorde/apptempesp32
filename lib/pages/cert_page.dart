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
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PagCert extends StatelessWidget {
  const PagCert({super.key});

  @override
  Widget build(BuildContext context) {
    final BlueController blue = BlueController();
    final AwsController aws = AwsController();
    final AllData _data = AllData();
    
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => {onBackPressed(context)},
      child: Scaffold(
        //Top Menu
        appBar: const TopBar(),

        //Bottom Menu
        // ignore: prefer_const_constructors
        //bottomNavigationBar: BottomBar(),

        //Body (all pags)
        body: MultiBlocProvider(
          providers: [
            BlocProvider<CertBloc>(
              create: (BuildContext context) => CertBloc(),
            ),
            BlocProvider<AwsBloc>(
              create: (BuildContext context) => AwsBloc(),
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
                        if (certState.stateActual == "InitState" ||
                            certState.stateActual == "empty") ...[
                          Text(blueState.stateActual),
                          const Text(
                              "Sincronizar aplicativo com o dispositivo"),
                          const Text(
                              "Mantenha o celular proximo para manter o bluetooth até o final do processo, pode demorar entre 1 e 2 minutos"),
                          TextButton(
                            onPressed: () {
                              context.read<CertBloc>().add(const CheckBlue());
                            },
                            child: const Text('Iniciar'),
                          )
                        ] else if (certState.stateActual == "SendAws") ...[
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
                        ] else ...[
                          Text(certState.stateActual)
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
