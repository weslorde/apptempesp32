import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/pages/home_page.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/widget/widget_alarm_creat.dart';
import 'package:apptempesp32/widget/widget_blue_toggle.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final BlueController _blue = BlueController();
  final AllData _data = AllData();

  @override
  void initState() {
    _blue.mandaMensagem("Alarme");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int nowStep = 30;
    int nowStep2 = 300;
    return Scaffold(
      appBar: const TopBar(),
      //
      bottomNavigationBar: const BottomBar(),
      //
      body: BlocBuilder<BlueBloc, BlueState>(
        builder: ((context, state) {
          return BodyStart(
            children: [
              //
              SizedBox(
                height: 30,
              ),
              //Title
              Stack(children: [
                Container(
                  margin: EdgeInsets.only(left: 30),
                  alignment: Alignment.centerLeft,
                  child: TextFont(
                      data: "Meus Alarmes",
                      weight: FontWeight.w700,
                      hexColor: _data.darkMode ? "#130F26" : "FFFFFF",
                      size: 35,
                      gFont: GoogleFonts.yanoneKaffeesatz),
                ),
                blueToggle(status: state.stateActual),
              ]),
              //
              SizedBox(height: 20),
              //

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int item = 0;
                          item < _data.getAlarmeTimer.length;
                          item++)
                        alarmCard(0, item, _data.getAlarmeTimer[item], _blue, _data),
                      for (int item = 0;
                          item < _data.getAlarmGraus.length;
                          item++)
                        alarmCard(1, item, _data.getAlarmGraus[item], _blue, _data),
                    ],
                  ),
                ),
              ),

              //alarmCard(0, _data.getAlarmeTimer[0]),
              //alarmCard(0, _data.getAlarmeTimer[1]),
              //alarmCard(0, _data.getAlarmeTimer[2]),

              //alarmCard(0, _data.getAlarmeTimer[1][0], _data.getAlarmeTimer[1][1]),
              //alarmCard(0, _data.getAlarmeTimer[2][0], _data.getAlarmeTimer[2][1]),
              //
              SizedBox(height: 40),
              // Buttom new alarm
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return alarmChoiceModal();
                    },
                  );
                },
                child: Container(
                  height: 62,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: _data.darkMode ? Colors.white : HexColor.fromHex('#FF5427'),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: _data.darkMode
                        ? HexColor.fromHex("#0B2235")
                        : Colors.transparent),
                  margin: EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer,
                        color: Colors.white,
                        size: 23,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextFont(
                          data: "CRIAR ALARME",
                          weight: FontWeight.w700,
                          hexColor: "#FFFFFF",
                          size: 16,
                          height: 19.36 / 16,
                          letter: 12,
                          gFont: GoogleFonts.inter),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}

Widget alarmCard(int type, int num, dynamic data, BlueController blue, _data) {
  return Container(
    height: 66,
    margin: EdgeInsets.only(left: 24, right: 24, bottom: 30),
    child: Container(
      padding: EdgeInsets.only(left: 18),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: _data.darkMode ? HexColor.fromHex("E6ECF2") : Colors.black,
              blurRadius: 16,
              offset: Offset(8, 8), // changes position of shadow
            ),
            BoxShadow(
              color: _data.darkMode ? HexColor.fromHex("#80FFFFFF") : Colors.black,
              blurRadius: 16,
              offset: Offset(-8, -8), // changes position of shadow
            ),
          ],
          color: _data.darkMode ? HexColor.fromHex("#F3F6F8") : HexColor.fromHex('#131313'),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                type == 0 ? Icons.timelapse_rounded : Icons.fireplace,
                size: 30,
                color: HexColor.fromHex("#FF5427"),
              ),
              SizedBox(
                width: 10,
              ),
              TextFont(
                  data: type == 0
                      ? "Timer em ${data[0]}h ${data[1]}m"
                      : "${data[0]} em ${data[1]} graus",
                  weight: FontWeight.w700,
                  hexColor: _data.darkMode ? "#000000" : "FFFFFF",
                  size: 16,
                  height: 19.36 / 16,
                  gFont: GoogleFonts.inter),
            ],
          ),
          GestureDetector(
            onTap: () {
              List listType = ["timer", "graus"];
              blue.mandaMensagem("DelAlarme,${listType[type]},${num}");
            },
            child: Container(
              height: 66,
              width: 57,
              decoration: BoxDecoration(
                  color: HexColor.fromHex("#FA3E3E"),
                  borderRadius:
                      BorderRadius.horizontal(right: Radius.circular(10))),
              child: Icon(
                Icons.delete_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
