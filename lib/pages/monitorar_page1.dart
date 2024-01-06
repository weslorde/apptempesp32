import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/dialogs/close_alert.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MonitorarPag extends StatelessWidget {
  const MonitorarPag({super.key});

  @override
  Widget build(BuildContext context) {
    final BlueController _blue = BlueController();
    final AllData _data = AllData();

    void changeBlocState(BlueEvent nextState) {
      context.read<BlueBloc>().add(nextState);
    }

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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<BlueBloc, BlueState>(
                builder: ((context, state) {
                  return Column(
                    children: [
                      const SizedBox(),
                      IconButton(
                          onPressed: () {
                            if (state.stateActual == "InitState" ||
                                state.stateActual == "empty") {
                              changeBlocState(const BlueIsOn());
                            }
                          },
                          icon: const Icon(Icons.bluetooth)),
                      const SizedBox(),
                      Text(state.stateActual),
                      const SizedBox(height: 60,),
                      Text(_data.tGrelha.toString()),
                      const SizedBox(height: 10,),
                      Text(_data.tAlvo.toString()),
                      const SizedBox(height: 80,),
                      Text(_data.tSensor1.toString()),
                      const SizedBox(height: 50,),
                      Text(_data.tSensor2.toString()),

                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
