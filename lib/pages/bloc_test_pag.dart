import 'package:apptempesp32/bloc/app_bloc.dart';
import 'package:apptempesp32/bloc/app_state.dart';
import 'package:apptempesp32/bloc/bloc_events.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocPage extends StatelessWidget {
  const BlocPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopBar(),
      // ignore: prefer_const_constructors
      bottomNavigationBar: BottomBar(),
      body: BlocBuilder<AppBloc, AppState>(
          builder: ((context, state) {
            String texto = '';
            if (state.error != null) {
              texto = 'error state do BlocBuild == null';
            } else {
              texto = state.data;
            }
            return (Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(texto),
                  TextButton(
                      onPressed: () {
                        context.read<AppBloc>().add(const LoadNextUrlEvent());
                      },
                      child: const Text('prox state'))
                ],
              ),
            ));
          }),
        ),
    );
  }
}
