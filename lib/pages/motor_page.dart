import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MotorPage extends StatelessWidget {
  const MotorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AllData _data = AllData();
    final BlueController _blue = BlueController();

    return Scaffold(
      appBar: const TopBar(),
      // ignore: prefer_const_constructors
      bottomNavigationBar: BottomBar(),
      body: BlocBuilder<BlueBloc, BlueState>(
        builder: ((context, state) {
          String texto = '';
          if (state.msg == null) {
            texto = 'error state do BlocBuild == null';
          } else {
            texto = state.msg;
          }
          return (Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(texto),
                const SizedBox(height: 100),
                Listener(
                  onPointerDown: (PointerEvent ignore) {
                    _blue.mandaMensagem("Temp");
                  },
                  onPointerUp: (PointerEvent ignore) {
                    _blue.mandaMensagem("Motor,Up,Release");
                  },
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.upload,
                        size: 150,
                      )),
                ),
                const SizedBox(height: 100),
                Listener(
                  onPointerDown: (PointerEvent ignore) {
                    _blue.mandaMensagem("Motor,Down,Press");
                  },
                  onPointerUp: (PointerEvent ignore) {
                    _blue.mandaMensagem("Motor,Down,Release");
                  },
                  child: IconButton(
                    onPressed: () {},
                    icon: const RotatedBox(
                      quarterTurns: 90,
                      child: Icon(
                        Icons.upload,
                        size: 150,
                      ),
                    )),
                ),
              ],
            ),
          ));
        }),
      ),
    );
  }
}
