import 'package:apptempesp32/bloc/app_bloc.dart';
import 'package:apptempesp32/bloc/app_state.dart';
import 'package:apptempesp32/bloc/bloc_events.dart';
import 'package:apptempesp32/dialogs/close_alert.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PagGeneric extends StatelessWidget {
  final String pagText;

  const PagGeneric({super.key, required this.pagText});

  @override
  Widget build(BuildContext context) {
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
                      Text(state.data),
                      TextButton(
                      onPressed: () {
                        context.read<AppBloc>().add(const LoadNextUrlEvent());
                      },
                      child: const Text('prox state'))
                    ],
                  );
                }),
              ),
              Text(pagText),
            ],
          ),
        ),
      ),
    );
  }
}
