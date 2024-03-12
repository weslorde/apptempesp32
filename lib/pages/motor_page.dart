import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/dialogs/close_alert.dart';
import 'package:apptempesp32/pages/home_page.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/widget/widget_blue_toggle.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'dart:math';

class MotorPage extends StatefulWidget {
  const MotorPage({super.key});

  @override
  State<MotorPage> createState() => _MotorPageState();
}

class _MotorPageState extends State<MotorPage> {
  final AllData _data = AllData();
  final BlueController _blue = BlueController();

  late Timer _timer;
  @override
  void initState() {
    if (_blue.getblueConnect) {
      _blue.mandaMensagem("Mpos");
    }
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_blue.getblueConnect) {
        _blue.mandaMensagem("Mpos");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _blue.mandaMensagem("Motor,Up,Release");
    sleep(Durations.medium1);
    _blue.mandaMensagem("Motor,Down,Release");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => {onBackPressed(context)},
      child: Scaffold(
        backgroundColor:
            _data.darkMode ? Colors.white : HexColor.fromHex('#101010'),
        appBar: const TopBar(),
        //
        bottomNavigationBar: BottomBar(),
        //
        body: BlocBuilder<BlueBloc, BlueState>(
          builder: ((context, state) {
            //
            int targetSteps = int.parse(_data.getListTemp[3]);
            int grelhaSteps = int.parse(_data.getListTemp[0]);
            int s1Steps = int.parse(_data.getListTemp[1]);
            int s2Steps = int.parse(_data.getListTemp[2]);
            //
            if (state.stateActual == "empty") {
              _blue.setToggleBool = true;
              context.read<BlueBloc>().add(const BlueIsSup());
            }
            //
            return BodyStart(
              children: [
                //
                SizedBox(height: 30),
                //Title
                Container(
                  alignment: Alignment.center,
                  child: TextFont(
                      data: "Ajuste a posição",
                      weight: FontWeight.w700,
                      hexColor: _data.darkMode ? "#130F26" : "FFFFFF",
                      size: 35,
                      gFont: GoogleFonts.yanoneKaffeesatz),
                ),
                //
                SizedBox(height: 5),
                // Blue icon
                blueToggle(status: state.screenMsg),

                SizedBox(height: 100),

                // Motor Position and Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //
                    SizedBox(width: 30),
                    // Motor Position
                    customLinearProgressTemperatureVertical(_data),
                    //
                    SizedBox(width: 60),
                    // Move motor Buttons
                    Container(
                      child: Column(
                        children: [
                          // Plus Button
                          GestureDetector(
                            onLongPress: () {
                              // On press start motor Up
                              _blue.mandaMensagem("Motor,Up,Press");
                              print("1");
                            },
                            onLongPressUp: () {
                              // On release stop motor
                              _blue.mandaMensagem("Motor,Up,Release");
                              print("2");
                            },
                            onLongPressCancel: () {
                              // On "problem" stop motor
                              _blue.mandaMensagem("Motor,Up,Release");
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: _data.darkMode ? HexColor.fromHex("#0B2235"): Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  width: 1.5,
                                  color: _data.darkMode ? Colors.transparent : HexColor.fromHex("#FF5427"),
                                ),
                              ),
                              child: Icon(Icons.add,
                                  size: 40,
                                  opticalSize: 60,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(height: 60),
                          // Minus Button
                          GestureDetector(
                            onLongPress: () {
                              // On press start motor Up
                              _blue.mandaMensagem("Motor,Down,Press");
                              print("1");
                            },
                            onLongPressUp: () {
                              // On release stop motor
                              _blue.mandaMensagem("Motor,Down,Release");
                              print("2");
                            },
                            onLongPressCancel: () {
                              // On "problem" stop motor
                              _blue.mandaMensagem("Motor,Down,Release");
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                color: _data.darkMode ? HexColor.fromHex("#0B2235"): Colors.transparent,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  width: 1.5,
                                  color: _data.darkMode ? Colors.transparent : HexColor.fromHex("#FF5427"),
                                ),
                              ),
                              child: Icon(Icons.remove,
                                  size: 40,
                                  opticalSize: 60,
                                  color: Colors.white ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //
                //SizedBox(height: 20),
              ],
            );
          }),
        ),
      ),
    );
  }
}

Color customColorCircularProgress(
    int drawStep, int actualStep, int totalSteps, var _data) {
  if (drawStep <= actualStep) {
    return (Color.lerp(HexColor.fromHex("#FF8A25"), HexColor.fromHex("#FF2E2E"),
        drawStep.toDouble() / totalSteps)!);
  } else {
    return _data.darkMode
        ? HexColor.fromHex("#E6ECF2")
        : HexColor.fromHex('#1D1E1F');
  }
}

Color customColorTraceProgress(int drawStep, int actualStep, int totalSteps) {
  if (drawStep <= actualStep) {
    return (Color.lerp(HexColor.fromHex("#FF8A25"), HexColor.fromHex("#FF2E2E"),
        drawStep.toDouble() / totalSteps)!);
  } else {
    return HexColor.fromHex("#80747D8C");
  }
}

Widget customLinearProgressTemperatureVertical(_data) {
  int totalSteps = 100;
  int actualStep = [10,30,55,75,98][_data.getMotorPos]; // Min 8, Max 98 
  return Container(
    height: 300,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.flip(
          flipY: true,
          child: Stack(
            children: [
              // Linear Indicator
              StepProgressIndicator(
                direction: Axis.vertical,
                totalSteps: totalSteps,
                currentStep: actualStep - 3,
                padding: 0,
                size: 30,
                roundedEdges: const Radius.circular(30 / 2),
                unselectedColor: _data.darkMode
                    ? Colors.grey.shade100
                    : HexColor.fromHex('#1D1E1F'),
                selectedGradientColor: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      HexColor.fromHex("#FF8D27"),
                      Color.lerp(
                          HexColor.fromHex("#FF8D27"),
                          HexColor.fromHex("#FF2E2E"),
                          (actualStep / totalSteps))!
                    ]),
              ),
              // Mark white ball
              Container(
                alignment: Alignment.topCenter,
                height: 300,
                padding: EdgeInsets.only(
                    top: ((300 / totalSteps) * actualStep) - 25),
                //width: double.infinity,
                //alignment: Alignment.centerLeft,
                child: Stack(
                  // The White Mark Ball and Circular fake bar effect after de mark ball
                  alignment: Alignment.center,
                  children: [
                    // Circular color end effect
                    Container(
                      //margin: EdgeInsets.only(left: 0),
                      width: 26 + 4,
                      height: 26 + 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20 + 4),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.lerp(
                                HexColor.fromHex("#FF8D27"),
                                HexColor.fromHex("#FF2E2E"),
                                ((actualStep - 24) / totalSteps))!,
                            Color.lerp(
                                HexColor.fromHex("#FF8D27"),
                                HexColor.fromHex("#FF2E2E"),
                                (actualStep / totalSteps))!
                          ],
                        ),
                      ),
                    ),
                    // White Mark Ball
                    Container(
                      width: 20 + 4,
                      height: 20 + 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    /*
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          //
          SizedBox(height: 7),
          // Linear Indicator + Ball white Mark
          Stack(
            children: [
              // Shadow below of content
              Container(
                //height: 26,
                width: 100,
                decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: _data.darkMode
                        ? HexColor.fromHex("E6ECF2")
                        : Colors.black,
                    blurRadius: 9.2,
                    offset: Offset(4.6, 4.6), // changes position of shadow
                  ),
                  BoxShadow(
                    color: _data.darkMode
                        ? HexColor.fromHex("#80FFFFFF")
                        : Colors.black,
                    blurRadius: 9.2,
                    offset: Offset(-4.6, 4.6), // changes position of shadow
                  ),
                ], borderRadius: BorderRadius.circular(20)),
              ),
              // Linear Progress Bar
              StepProgressIndicator(
                size: 26,
                roundedEdges: const Radius.circular(26 / 2),
                padding: 0,
                currentStep: actualStep,
                totalSteps: totalSteps,
                unselectedColor: _data.darkMode
                    ? Colors.grey.shade100
                    : HexColor.fromHex('#1D1E1F'),
                selectedGradientColor: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      HexColor.fromHex("#FF8D27"),
                      Color.lerp(HexColor.fromHex("#FF8D27"),
                          HexColor.fromHex("#FF2E2E"), (actualStep / totalSteps))!
                    ]),
              ),
    
              // Mark white ball
              Container(
                height: 26,
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: LayoutBuilder(builder: (context, constraints) {
                  // LayoutBuilder to now the width of ProgressBar
                  return Padding(
                    padding: EdgeInsets.only(
                      left: circleLinearTemperaturePadding(
                          // Fun to set a minimum padding avoiding the Mark ball go out in the left of progressBar
                          actualStep,
                          constraints.maxWidth,
                          totalSteps),
                    ),
                    child: Stack(
                      // The White Mark Ball and Circular fake bar effect after de mark ball
                      alignment: Alignment.center,
                      children: [
                        // Circular color end effect
                        Container(
                          //margin: EdgeInsets.only(left: 0),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color.lerp(
                                    HexColor.fromHex("#FF8D27"),
                                    HexColor.fromHex("#FF2E2E"),
                                    ((actualStep - 20) / totalSteps))!,
                                Color.lerp(
                                    HexColor.fromHex("#FF8D27"),
                                    HexColor.fromHex("#FF2E2E"),
                                    (actualStep / totalSteps))!
                              ],
                            ),
                          ),
                        ),
                        // White Mark Ball
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ],
      ),*/
  );
}

// Fun to set a minimum padding avoiding the Mark ball go out in the left of progressBar
double circleLinearTemperaturePadding(actualStep, maxWidth, totalSteps) {
  double calc = (actualStep * (maxWidth / totalSteps)) - 14;
  if (calc < 0) {
    return 3.0;
  } else {
    return calc;
  }
}
