import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/bloc/app_bloc.dart';
import 'package:apptempesp32/bloc/app_state.dart';
import 'package:apptempesp32/bloc/bloc_events.dart';
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

    void changeBlocState(AppEvent nextState) {
      context.read<AppBloc>().add(nextState);
    }

    return WillPopScope(
      onWillPop: () => onBackPressed(context),
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
              BlocBuilder<AppBloc, AppState>(
                builder: ((context, state) {
                  return Column(
                    children: [
                      const SizedBox(),
                      IconButton(
                          onPressed: () {
                            changeBlocState(const BlueIsOn());
                          },
                          icon: const Icon(Icons.bluetooth)),
                      const SizedBox(),
                      Text(state.stateActual)
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
