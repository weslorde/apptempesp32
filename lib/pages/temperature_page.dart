import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc_events.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc.dart';
import 'package:apptempesp32/dialogs_box/close_alert.dart';
import 'package:apptempesp32/pages/home_page.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/widget/widget_blue_toggle.dart';
import 'package:apptempesp32/widget/widget_temperature_creat.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({super.key});

  @override
  State<TemperaturePage> createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  final AllData _data = AllData();
  final BlueController _blue = BlueController();

  late Timer _timer;
  @override
  void initState() {
    if (_blue.getblueConnect) {
      _blue.mandaMensagem("Temp");
    }
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_blue.getblueConnect) {
        _blue.mandaMensagem("Temp");
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AllData data = AllData();
    final AwsController _aws = AwsController();

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

        body: MultiBlocProvider(
          providers: [
            BlocProvider<DynamoBloc>(
              create: (BuildContext context) => DynamoBloc(),
            )
          ],
          child: Builder(builder: (context) {
            final blueState = context.watch<BlueBloc>().state;
            final awsState = context.watch<AwsBloc>().state;

            //Temps adiquire
            int targetSteps = int.parse(_data.getListTemp[3]);
            int grelhaSteps = int.parse(_data.getListTemp[0]);
            int s1Steps = int.parse(_data.getListTemp[1]);
            int s2Steps = int.parse(_data.getListTemp[2]);

            //Start blue on start of screen
            if (blueState.stateActual == "empty") {
              if (data.getAwsIotBoardConnect == false) {
                _blue.setToggleBool = true;
                context.read<BlueBloc>().add(const BlueIsSup());
              }
            }

            /*body: BlocBuilder<BlueBloc, BlueState>(
          builder: ((context, state) {
            //
            int targetSteps = int.parse(_data.getListTemp[3]);
            int grelhaSteps = int.parse(_data.getListTemp[0]);
            int s1Steps = int.parse(_data.getListTemp[1]);
            int s2Steps = int.parse(_data.getListTemp[2]);
            //Start blue on start of screen
            if (state.stateActual == "empty") {
              if (data.getAwsIotBoardConnect == false) {
                _blue.setToggleBool = true;
                context.read<BlueBloc>().add(const BlueIsSup());
              }
            }
            */
            return BodyStart(
              children: [
                //
                SizedBox(height: 30),
                //Title
                Container(
                  alignment: Alignment.center,
                  child: TextFont(
                      data: "Ajuste a temperatura",
                      weight: FontWeight.w700,
                      hexColor: _data.darkMode ? "#130F26" : "FFFFFF",
                      size: 35,
                      gFont: GoogleFonts.yanoneKaffeesatz),
                ),
                //
                SizedBox(height: 10),
                //
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            //
                            SizedBox(height: 5),
                            //
                            // Shadow circle
                            Container(
                              width: 210,
                              height: 210,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(210 / 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: _data.darkMode
                                        ? HexColor.fromHex("#E6ECF2")
                                        : HexColor.fromHex("7D000000"),
                                    blurRadius: 14.4,
                                    offset: Offset(
                                        7.2, 7.2), // changes position of shadow
                                  ),
                                  BoxShadow(
                                    color: _data.darkMode
                                        ? HexColor.fromHex("#80FFFFFF")
                                        : HexColor.fromHex("7D000000"),
                                    blurRadius: 14.4,
                                    offset: Offset(-7.2,
                                        -7.2), // changes position of shadow
                                  ),
                                ],
                              ),
                            ),

                            // Mult Trace Target indicator
                            CircularStepProgressIndicator(
                              arcSize: pi * 4 / 3,
                              startingAngle: 2 * pi / 3,
                              padding: pi / 35,
                              totalSteps: 40,
                              stepSize: 12,
                              selectedStepSize: 12,
                              currentStep: targetSteps,
                              width: 260,
                              height: 260,
                              customColor: (drawStep) {
                                return customColorTraceProgress(
                                    drawStep, targetSteps, 40);
                              },
                            ),

                            // Full circle temperature indicator
                            CircularStepProgressIndicator(
                              customColor: (drawStep) {
                                return customColorCircularProgress(
                                    drawStep, grelhaSteps, 330, _data);
                              },
                              totalSteps: 500,
                              currentStep: grelhaSteps,
                              stepSize: 70 / 2,
                              selectedStepSize: 70 / 2,
                              padding: 0,
                              startingAngle: -2 * pi / 3,
                              width: 210,
                              height: 210,
                              roundedCap: (_, __) => true,
                            ),
                            // End Mark White Circle
                            Transform.rotate(
                              angle: grelhaSteps * 2 * pi / 500 -
                                  pi /
                                      6, // step * 2 * pi / totalSteps of circular temperature - offset of startingAngle (pi/6 = pi*2/3 - 1/2 [1/2 is the start angle of Transform.rotate])
                              child: Container(
                                height: 260 -
                                    25 -
                                    70 /
                                        2, // Size of circular temperature indicator - size of this mark circle - StepSize of circular temperature
                                width: 260 - 25 - 70 / 2,
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  width: 25,
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.white),
                                ),
                              ),
                            ),

                            // Internal Circle (Color + Shadow)
                            Container(
                              width: 210 - 70,
                              height: 210 - 70,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: <Color>[
                                    HexColor.fromHex("#eaf0f6"),
                                    HexColor.fromHex("#eaeff5"),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(210 / 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: HexColor.fromHex("80747D8C"),
                                    blurRadius: 45.2,
                                  ),
                                ],
                              ),
                            ),

                            // Inside of temperature circle (Values and Icon)
                            Container(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.task_alt_sharp,
                                    color: HexColor.fromHex("#FF5427"),
                                    size: 18,
                                  ),
                                  SizedBox(height: 3),
                                  TextFont(
                                      data: "${grelhaSteps}º",
                                      weight: FontWeight.w600,
                                      hexColor: "#130F26",
                                      size: 36,
                                      height: 44 / 36,
                                      gFont: GoogleFonts.inter),
                                  SizedBox(height: 3),
                                  TextFont(
                                      data: "${_data.getListTemp[3]}",
                                      weight: FontWeight.w400,
                                      hexColor: "#130F26",
                                      size: 14.5,
                                      height: 17.5 / 14.5,
                                      gFont: GoogleFonts.inter)
                                ],
                              ),
                            ),
                            //
                            // Blue icon
                            Padding(
                              padding: const EdgeInsets.only(bottom: 210),
                              child: blueToggle(status: blueState.screenMsg),
                            ),
                            // End of Stack
                          ],
                        ),

                        //
                        SizedBox(height: 10),
                        // Linear Temperature 1
                        customLinearProgressTemperature(
                            s1Steps, 300, _data.getListTemp[1], _data, 0),
                        //
                        SizedBox(height: 20),
                        // Linear Temperature 2
                        customLinearProgressTemperature(
                            s2Steps, 300, _data.getListTemp[2], _data, 1),
                        //
                        SizedBox(height: 20),
                        //
                        // Button New Alarm
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return temperatureTargetModal();
                              },
                            );
                          },
                          child: Container(
                            height: 62,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: _data.darkMode
                                      ? Colors.white
                                      : HexColor.fromHex('#FF5427'),
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
                                    data: "TEMPERATURA ALVO",
                                    weight: FontWeight.w700,
                                    hexColor: "#FFFFFF",
                                    size: 16,
                                    height: 19.36 / 16,
                                    letter: 5,
                                    gFont: GoogleFonts.inter),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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

Widget customLinearProgressTemperature(
    int actualStep, int totalSteps, String temperature, var _data, int indice) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 25),
    child: Column(
      children: [
        // Text -> name and temperatures
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.thermostat,
                  color: HexColor.fromHex("#FF5427"),
                  size: 20,
                ),
                TextFont(
                    data: "Sensor ${indice + 1}",
                    weight: FontWeight.w700,
                    hexColor: _data.darkMode ? "#130F26" : "#FFFFFF",
                    size: 15,
                    height: 18.15 / 15,
                    gFont: GoogleFonts.inter)
              ],
            ),
            Row(
              children: [
                TextFont(
                    data: "$temperatureº",
                    weight: FontWeight.w700,
                    hexColor: _data.darkMode ? "#FF0000" : "#FF5427",
                    size: 15,
                    height: 18.15 / 15,
                    gFont: GoogleFonts.inter),
                TextFont(
                    data: "/${_data.getTargetTemp[indice]}º",
                    weight: FontWeight.w700,
                    hexColor: _data.darkMode ? "#130F26" : "#FFFFFF",
                    size: 15,
                    height: 17.58 / 15,
                    gFont: GoogleFonts.inter)
              ],
            ),
          ],
        ),
        //
        SizedBox(height: 7),
        // Linear Indicator + Ball white Mark
        Stack(
          children: [
            // Shadow below of content
            Container(
              height: 26,
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: _data.darkMode
                      ? HexColor.fromHex("E6ECF2")
                      : HexColor.fromHex("33000000"),
                  blurRadius: 9.2,
                  offset: Offset(4.6, 4.6), // changes position of shadow
                ),
                BoxShadow(
                  color: _data.darkMode
                      ? HexColor.fromHex("#80FFFFFF")
                      : HexColor.fromHex("4C000000"),
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
    ),
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
