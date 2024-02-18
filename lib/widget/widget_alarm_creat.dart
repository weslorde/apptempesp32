import 'dart:ffi';
import 'dart:io';

import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/pages/temperature_page.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class alarmBotModal extends StatefulWidget {
  alarmBotModal({super.key});

  @override
  State<alarmBotModal> createState() => _alarmBotModalState();
}

class _alarmBotModalState extends State<alarmBotModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ElevatedButton(
          child: const Text('showModalBottomSheet'),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return alarmBotModal2();
              },
            );
          },
        ),
      ),
    );
  }
}

class alarmBotModal2 extends StatefulWidget {
  alarmBotModal2({super.key});

  @override
  State<alarmBotModal2> createState() => _alarmBotModalState2();
}

class _alarmBotModalState2 extends State<alarmBotModal2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      color: HexColor.fromHex("#E6ECF2"),
      child: Center(
        child: Column(
          children: [
            //
            SizedBox(height: 50),
            // Titulo Grande
            TextFont(
                data: "Criar Alarme",
                weight: FontWeight.w700,
                hexColor: "#0B2235",
                size: 44,
                gFont: GoogleFonts.yanoneKaffeesatz),
            //
            SizedBox(height: 15),
            // Sub Titulo
            TextFont(
                data: "Qual tipo de alarme você deseja criar?",
                weight: FontWeight.w500,
                hexColor: "#8A0B2235",
                size: 14,
                height: 17 / 14,
                letter: 4,
                gFont: GoogleFonts.inter),
            //
            SizedBox(height: 30),
            //
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return alarmBotModal3();
                      },
                    );
                  },
                  child: buttonNewAlarm("Tempo", Icons.timer),
                ),
                SizedBox(
                  width: 5,
                ),
                buttonNewAlarm("Temperatura", Icons.fireplace),
              ],
            ),

            SizedBox(height: 30),
            //

            ElevatedButton(
              child: const Text('Close BottomSheet'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class alarmBotModal3 extends StatefulWidget {
  alarmBotModal3({super.key});

  @override
  State<alarmBotModal3> createState() => _alarmBotModalState3();
}

class _alarmBotModalState3 extends State<alarmBotModal3> {
  double hoursStep = 2;
  int hoursBaseNum = 0;
  double minutesStep = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      color: HexColor.fromHex("#E6ECF2"),
      child: Center(
        child: Column(
          children: [
            //
            SizedBox(height: 30),
            // Titulo Grande
            TextFont(
                data:
                    "${hoursStep.toInt() + hoursBaseNum - 1}h ${(minutesStep.toInt() - 1) * 5}m",
                weight: FontWeight.w700,
                hexColor: "#0B2235",
                size: 44,
                gFont: GoogleFonts.yanoneKaffeesatz),
            //
            SizedBox(height: 15),
            // Horas
            Column(
              children: [
                // Num Horas
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int x = hoursBaseNum; x < hoursBaseNum + 6; x++)
                        Text("${x}h")
                    ],
                  ),
                ),
                // Marcas Horas
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      for (int x = hoursBaseNum; x < hoursBaseNum + 6; x++)
                        Text("|")
                    ],
                  ),
                ),
              ],
            ),
            // Barra horas
            GestureDetector(
              onTapDown: (details) {
                hoursStep = test1Fun(details, hoursStep);
                setState(() {});
              },
              onHorizontalDragUpdate: (details) {
                hoursStep = test1Fun(details, hoursStep);
                setState(() {});
              },
              onTapUp: (details) {
                var newValues = test2Fun(hoursStep, hoursBaseNum);
                hoursStep = newValues[0];
                hoursBaseNum = newValues[1];
                setState(() {});
              },
              onHorizontalDragEnd: (details) {
                var newValues = test2Fun(hoursStep, hoursBaseNum);
                hoursStep = newValues[0];
                hoursBaseNum = newValues[1];
                setState(() {});
              },
              child: customLinearProgressTemperature2(
                  (hoursStep.toInt() * 16) - 7, 100, "200"),
            ),
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
                    children: [for (int x = 0; x < 51; x += 10) Text("${x}m")],
                  ),
                ),
                // Marcas Minutos
                Padding(
                  padding: const EdgeInsets.only(left:20, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [for (int x = 0; x < 56; x += 5) x%10==0 ? Text("|"): Text("|",style: TextStyle(fontSize: 10),)],
                  ),
                ),
              ],
            ),
            // Barra Minutos
            GestureDetector(
              onTapDown: (details) {
                minutesStep = test3Fun(details, minutesStep);
                setState(() {});
              },
              onHorizontalDragUpdate: (details) {
                minutesStep = test3Fun(details, minutesStep);
                setState(() {});
              },
              child: customLinearProgressTemperature2(
                  (minutesStep.toInt() * 8), 100, "200"),
            ),
            SizedBox(height: 25),
            buttonNewAlarm("teste",Icons.timer),
          ],
        ),
      ),
    );
  }
}

Widget buttonNewAlarm(String text, IconData icon) {
  return Container(
    height: 45,
    width: 158,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: HexColor.fromHex("#0B2235")),
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

Widget customLinearProgressTemperature2(
    int actualStep, int totalSteps, String temperature) {
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
                  color: HexColor.fromHex("E6ECF2"),
                  blurRadius: 9.2,
                  offset: Offset(4.6, 4.6), // changes position of shadow
                ),
                BoxShadow(
                  color: HexColor.fromHex("#80FFFFFF"),
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
              unselectedColor: Colors.grey.shade100,
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
