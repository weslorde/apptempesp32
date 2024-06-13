import 'dart:io';
import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/pages/temperature_page.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class temperatureTargetModal extends StatefulWidget {
  temperatureTargetModal({super.key});

  @override
  State<temperatureTargetModal> createState() => _temperatureTargetModalState();
}

class _temperatureTargetModalState extends State<temperatureTargetModal> {
  final BlueController _blue = BlueController();
  final AllData _data = AllData();
  final AwsController _aws = AwsController();

  double grausStep = 3;
  int sensorSelected = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      color: _data.darkMode
          ? HexColor.fromHex("#E6ECF2")
          : HexColor.fromHex("#101010"),
      child: Center(
        child: Column(
          children: [
            //
            SizedBox(height: 30),
            // Titulo Grande
            TextFont(
                data: "${(grausStep.toInt() + 1) * 25}º",
                weight: FontWeight.w700,
                hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                size: 44,
                gFont: GoogleFonts.yanoneKaffeesatz),
            //
            SizedBox(height: 30),
            // Minutos
            Column(
              children: [
                // Num Minutos
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int x = 50; x < 301; x += 50)
                        Text(
                          "${x}º",
                          style: TextStyle(
                            color: _data.darkMode
                                ? HexColor.fromHex("#0B2235")
                                : HexColor.fromHex("#747D8C"),
                          ),
                        ),
                    ],
                  ),
                ),
                // Marcas Minutos
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int x = 0; x < 56; x += 5)
                        x % 10 == 0
                            ? Text(
                                "|",
                                style: TextStyle(
                                  color: _data.darkMode
                                      ? HexColor.fromHex("#0B2235")
                                      : HexColor.fromHex("#747D8C"),
                                ),
                              )
                            : Text(
                                "|",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: _data.darkMode
                                      ? HexColor.fromHex("#0B2235")
                                      : HexColor.fromHex("#747D8C"),
                                ),
                              ),
                    ],
                  ),
                ),
              ],
            ),
            // Barra Minutos
            GestureDetector(
              onTapDown: (details) {
                grausStep = test3Fun(details, grausStep);
                setState(() {});
              },
              onHorizontalDragUpdate: (details) {
                grausStep = test3Fun(details, grausStep);
                setState(() {});
              },
              child: customLinearProgressTemperature2(
                  (grausStep.toInt() * 8), 100, "200", _data),
            ),
            //
            SizedBox(height: 40),
            //
            GestureDetector(
              onTap: () {
                if (!_data.getAwsIotBoardConnect) {
                  _blue.mandaMensagem("Target,${(grausStep.toInt() + 1) * 25}");
                } else {
                  const topic = 'TemperaturesShadow/update';
                  var msg =
                      '{"state": {"desired": {"Flutter": "1", "TAlvoFlutter": "${(grausStep.toInt() + 1) * 25}"}}}';
                  _aws.awsMsg(topic, msg);
                }
                Navigator.pop(context);
              },
              child:
                  buttonNewAlarmBig("Salvar Temperatura", Icons.timer, _data),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buttonNewAlarm(String text, IconData icon, _data) {
  return Container(
    height: 45,
    width: 158,
    decoration: BoxDecoration(
        border: Border.all(
            width: 1.5,
            color: _data.darkMode
                ? Colors.transparent
                : HexColor.fromHex("#FF5427")),
        borderRadius: BorderRadius.circular(12),
        color:
            _data.darkMode ? HexColor.fromHex("#0B2235") : Colors.transparent),
    //margin: EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: HexColor.fromHex("#FF5427"),
          size: 23,
        ),
        SizedBox(
          width: 10,
        ),
        TextFont(
            data: text,
            weight: FontWeight.w700,
            hexColor: "#FFFFFF",
            size: 15,
            height: 18.15 / 15,
            gFont: GoogleFonts.inter),
      ],
    ),
  );
}

Widget buttonNewAlarmBig(String text, IconData icon, _data) {
  return Container(
    height: 62,
    width: 300,
    decoration: BoxDecoration(
        border: Border.all(
            width: 1.5,
            color: _data.darkMode
                ? Colors.transparent
                : HexColor.fromHex("#FF5427")),
        borderRadius: BorderRadius.circular(12),
        color:
            _data.darkMode ? HexColor.fromHex("#0B2235") : Colors.transparent),
    //margin: EdgeInsets.symmetric(horizontal: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: HexColor.fromHex("#FF5427"),
          size: 23,
        ),
        SizedBox(
          width: 10,
        ),
        TextFont(
            data: text,
            weight: FontWeight.w700,
            hexColor: "#FFFFFF",
            size: 15,
            height: 18.15 / 15,
            letter: 12,
            gFont: GoogleFonts.inter),
      ],
    ),
  );
}

Widget customLinearProgressTemperature2(
    int actualStep, int totalSteps, String temperature, _data) {
  return Container(
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
              height: 26,
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: _data.darkMode
                      ? HexColor.fromHex("#30E6ECF2")
                      : HexColor.fromHex("#000000"),
                  blurRadius: 9.2,
                  offset: Offset(4.6, 4.6), // changes position of shadow
                ),
                BoxShadow(
                  color: _data.darkMode
                      ? HexColor.fromHex("#20FFFFFF")
                      : HexColor.fromHex("#80000000"),
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
                  : HexColor.fromHex("#1D1E1F"),
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

test1Fun(details, double testStep) {
  testStep = details.localPosition.dx / 55 + .5;
  if (testStep > 6) {
    testStep = 6;
  }
  if (testStep < 1) {
    testStep = 1;
  }
  return testStep;
}

test2Fun(double testStep, int iniNum) {
  if (testStep == 6) {
    sleep(Durations.medium3);
    iniNum += 3;
    testStep = 3;
  }
  if (testStep < 2) {
    sleep(Durations.medium3);
    iniNum -= 3;
    if (iniNum < 0) {
      iniNum = 0;
    } else {
      testStep = 4;
    }
  }
  return [testStep, iniNum];
}

test3Fun(details, double testStep) {
  print(details.localPosition.dx);
  testStep = details.localPosition.dx / 29 + 0.2;
  if (testStep > 12) {
    testStep = 12;
  }
  if (testStep < 1) {
    testStep = 1;
  }
  return testStep;
}
