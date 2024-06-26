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

class alarmChoiceModal extends StatefulWidget {
  alarmChoiceModal({super.key});

  @override
  State<alarmChoiceModal> createState() => _alarmChoiceModalState();
}

class _alarmChoiceModalState extends State<alarmChoiceModal> {
  final AllData _data = AllData();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      color: _data.darkMode
          ? HexColor.fromHex("#E6ECF2")
          : HexColor.fromHex('#101010'),
      child: Center(
        child: Column(
          children: [
            //
            SizedBox(height: 50),
            // Titulo Grande
            TextFont(
                data: "Criar Alarme",
                weight: FontWeight.w700,
                hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                size: 44,
                gFont: GoogleFonts.yanoneKaffeesatz),
            //
            SizedBox(height: 15),
            // Sub Titulo
            TextFont(
                data: "Qual tipo de alarme você deseja criar?",
                weight: FontWeight.w500,
                hexColor: _data.darkMode ? "#8A0B2235" : "#979797",
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
                // BUTTON TIMER ALARM
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return alarmTimerModal();
                      },
                    );
                  },
                  child: buttonNewAlarm("Tempo", Icons.timer, _data),
                ),
                //
                SizedBox(width: 5),
                // BUTTON TEMPERATURE ALARM
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return alarmTemperatureModal();
                      },
                    );
                  },
                  child: buttonNewAlarm("Temperatura", Icons.fireplace, _data),
                ),
              ],
            ),
            //
            SizedBox(height: 30),
            //
          ],
        ),
      ),
    );
  }
}

class alarmTemperatureModal extends StatefulWidget {
  alarmTemperatureModal({super.key});

  @override
  State<alarmTemperatureModal> createState() => _alarmTemperatureModalState();
}

class _alarmTemperatureModalState extends State<alarmTemperatureModal> {
  final AwsController _aws = AwsController();
  final BlueController _blue = BlueController();
  final AllData _data = AllData();
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
            SizedBox(height: 25),
            // Sensor temperature SELECT
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // GRELHA Select
                  GestureDetector(
                    onTap: () {
                      sensorSelected = 1;
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: HexColor.fromHex("#FF5427")),
                          color: _data.darkMode
                              ? sensorSelected == 1
                                  ? HexColor.fromHex("#B00B2235")
                                  : HexColor.fromHex("#1D1E1F")
                              : sensorSelected == 1
                                  ? HexColor.fromHex("#40FFFFFF")
                                  : HexColor.fromHex("#101010"),
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(25))),
                      child: Text(
                        "Grelha",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Sensor 1 Select
                  GestureDetector(
                    onTap: () {
                      sensorSelected = 2;
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 70,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: HexColor.fromHex("#FF5427")),
                        color: _data.darkMode
                            ? sensorSelected == 2
                                ? HexColor.fromHex("#B00B2235")
                                : HexColor.fromHex("#1D1E1F")
                            : sensorSelected == 2
                                ? HexColor.fromHex("#40FFFFFF")
                                : HexColor.fromHex("#101010"),
                      ),
                      child: Text(
                        "Sensor 1",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  // Sensor 2 Select
                  GestureDetector(
                    onTap: () {
                      sensorSelected = 3;
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 75,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: HexColor.fromHex("#FF5427")),
                          color: _data.darkMode
                              ? sensorSelected == 3
                                  ? HexColor.fromHex("#B00B2235")
                                  : HexColor.fromHex("#1D1E1F")
                              : sensorSelected == 3
                                  ? HexColor.fromHex("#40FFFFFF")
                                  : HexColor.fromHex("#101010"),
                          borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(25))),
                      child: Text(
                        "Sensor 2",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //
            SizedBox(height: 25),
            //
            GestureDetector(
              onTap: () {
                if (!_data.getAwsIotBoardConnect) {
                  _blue.mandaMensagem("GAl,${[
                    'Grelha',
                    'Sensor1',
                    'Sensor2'
                  ][sensorSelected - 1]},${(grausStep.toInt() + 1) * 25}");
                } else {
                  const topic = 'AlarmShadow/update';
                  String msg =
                      '{"state": {"desired": {"Flutter": "1", "CriaAlarm": "1", "CriaAlarmData":  "GAl,${[
                    'Grelha',
                    'Sensor1',
                    'Sensor2'
                  ][sensorSelected - 1]},${(grausStep.toInt() + 1) * 25}"  }}}';
                  _aws.awsMsg(topic, msg);
                }
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: buttonNewAlarmBig("CRIAR ALARME", Icons.timer, _data),
            ),
          ],
        ),
      ),
    );
  }
}

class alarmTimerModal extends StatefulWidget {
  alarmTimerModal({super.key});

  @override
  State<alarmTimerModal> createState() => _alarmTimerModalState();
}

class _alarmTimerModalState extends State<alarmTimerModal> {
  final AwsController _aws = AwsController();
  double hoursStep = 2;
  int hoursBaseNum = 0;
  double minutesStep = 2;
  final BlueController _blue = BlueController();
  final AllData _data = AllData();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: _data.darkMode
          ? HexColor.fromHex("#E6ECF2")
          : HexColor.fromHex("#131313"),
      child: Center(
        child: Column(
          children: [
            //
            SizedBox(height: 30),
            // Titulo Grande
            TextFont(
                data:
                    "${hoursStep.toInt() + hoursBaseNum - 1} h  ${(minutesStep.toInt() - 1) * 5} min",
                weight: FontWeight.w700,
                hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
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
                        Text(
                          "${x}h",
                          style: TextStyle(
                            color: _data.darkMode
                                ? HexColor.fromHex("#0B2235")
                                : HexColor.fromHex("#747D8C"),
                          ),
                        )
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
                        Text(
                          "|",
                          style: TextStyle(
                            color: _data.darkMode
                                ? HexColor.fromHex("#0B2235")
                                : HexColor.fromHex("#747D8C"),
                          ),
                        )
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
                  (hoursStep.toInt() * 16) - 7, 100, "200", _data),
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
                    children: [
                      for (int x = 0; x < 51; x += 10)
                        Text(
                          "${x}m",
                          style: TextStyle(
                            color: _data.darkMode
                                ? HexColor.fromHex("#0B2235")
                                : HexColor.fromHex("#747D8C"),
                          ),
                        )
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
                              )
                    ],
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
                  (minutesStep.toInt() * 8), 100, "200", _data),
            ),
            SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                if (!_data.getAwsIotBoardConnect) {
                  _blue.mandaMensagem(
                      "TAl,${hoursStep.toInt() + hoursBaseNum - 1},${(minutesStep.toInt() - 1) * 5}"); 
                } else {
                  const topic = 'AlarmShadow/update';
                  String msg =
                      '{"state": {"desired": {"Flutter": "1", "CriaAlarm": "1", "CriaAlarmData": "TAl,${hoursStep.toInt() + hoursBaseNum - 1},${(minutesStep.toInt() - 1) * 5}" }}}';
                  _aws.awsMsg(topic, msg);
                }
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: buttonNewAlarmBig("CRIAR ALARME", Icons.timer, _data),
            ),
            SizedBox(height: 20),
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
