import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc_events.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlarmPageOld extends StatelessWidget {
  const AlarmPageOld({super.key});

  @override
  Widget build(BuildContext context) {
    final AllData _data = AllData();
    final BlueController _blue = BlueController();

    _blue.mandaMensagem("Alarme");

    return Scaffold(
      appBar: const TopBar(),
      // ignore: prefer_const_constructors
      bottomNavigationBar: BottomBar(),
      body: Builder(builder: (context) {
        final awsState = context.watch<AwsBloc>().state;
        final blueState = context.watch<BlueBloc>().state;
        return (Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Text("Blue State: ${blueState.stateActual}"),
              TextButton(
                  onPressed: () {
                    context.read<BlueBloc>().add(const BlueIsSup());
                  },
                  child: const Text("Iniciar")),
              const SizedBox(
                height: 20,
              ),
              Text("AWS State: ${awsState.stateActual}"),
              TextButton(
                  onPressed: () {
                    context.read<AwsBloc>().add(const CheckFiles());
                  },
                  child: const Text("Iniciar")),
              const SizedBox(
                height: 30,
              ),

              if (blueState.stateActual == "BlueConectado") ...[
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Column(
                          children: [
                            for (var x = 0; x < _data.getAlarmeTimer.length; x++)
                              _data.getAlarmeTimer[x] != 0
                                  ? ListAlarm(
                                      name: _data.getAlarmeTimer[x],
                                      tipo: "timer",
                                      indice: x,
                                      apagaAlarm: (tipo, index){_blue.mandaMensagem("DelAlarme,$tipo,$index"); _blue.mandaMensagem("Alarme");})
                                  : const SizedBox(),
                            for (var x = 0; x < _data.getAlarmGraus.length; x++)
                              _data.getAlarmGraus[x] != 0
                                  ? ListAlarm(
                                      name: _data.getAlarmGraus[x],
                                      tipo: "graus",
                                      indice: x,
                                      apagaAlarm: (tipo, index){_blue.mandaMensagem("DelAlarme,$tipo,$index"); _blue.mandaMensagem("Alarme");})
                                  : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ] else if ((blueState.stateActual == "RecivedData")) ...[
                Text("Carregando")
              ] else ...[
                Text("Sem conexao")
              ]

              //asfd
            ],
          ),
        ));
      }),
    );
  }
}

class ListAlarm extends StatefulWidget {
  //const ListAlarm({super.key, this.temp = 0, required this.name});
  const ListAlarm(
      {super.key,
      required this.name,
      required this.tipo,
      required this.indice,
      required this.apagaAlarm});

  //final int temp;
  final name;
  final String tipo;
  final int indice;
  final void Function(String, int) apagaAlarm;

  @override
  State<ListAlarm> createState() => _ListAlarmState();
}

class _ListAlarmState extends State<ListAlarm> {
  int totalSteps = 310;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Card(
        child: Container(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(widget.tipo == "timer"
                      ? Icons.timer_sharp
                      : Icons.fireplace_outlined),
                  title: widget.tipo == "timer"
                      ? Text("Timer em ${widget.name[0]}h ${widget.name[1]}m")
                      : Text("${widget.name[0]} em ${widget.name[1]}º"),
                  /*: widget.name[0] == "Grelha" ? Text("Temperatura da ${widget.name[0]} em ${widget.name[1]}º")
                            : Text("Temperatura do ${widget.name[0]} em ${widget.name[1]}º"),*/
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.apagaAlarm(widget.tipo, widget.indice);
                },
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.red.shade900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
