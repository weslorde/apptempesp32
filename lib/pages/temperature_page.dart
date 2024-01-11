import 'dart:convert';
import 'dart:math';
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
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TemperaturePage extends StatelessWidget {
  const TemperaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AllData _data = AllData();
    final BlueController _blue = BlueController();

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
              Container(
                alignment: Alignment.center,
                child: TextFont(
                    data: "Ajuste a temperatura",
                    weight: FontWeight.w700,
                    hexColor: "#130F26",
                    size: 35,
                    gFont: GoogleFonts.yanoneKaffeesatz),
              ),
              //
              SizedBox(
                height: 50,
              ),
              //
              Stack(
                alignment: Alignment.center,
                children: [
                  // Trace Target indicator
                  CircularStepProgressIndicator(
                    arcSize: pi * 4 / 3,
                    startingAngle: 2 * pi / 3,
                    padding: pi / 35,
                    totalSteps: 40,
                    stepSize: 15,
                    selectedStepSize: 15,
                    currentStep: nowStep,
                    width: 260,
                    height: 260,
                    customColor: (drawStep) {
                      return customColorCircularProgress(drawStep, nowStep, 40);
                    },
                  ),
                  // Full circle temperature indicator
                  CircularStepProgressIndicator(
                    customColor: (drawStep) {
                      return customColorCircularProgress(
                          drawStep, nowStep2, 330);
                    },
                    totalSteps: 500,
                    currentStep: nowStep2,
                    stepSize: 70 / 2,
                    selectedStepSize: 70 / 2,
                    unselectedColor: HexColor.fromHex("#E6ECF2"),
                    padding: 0,
                    startingAngle: -2 * pi / 3,
                    width: 210,
                    height: 210,
                    roundedCap: (_, __) => true,
                  ),
                  // End Mark White Circle
                  Transform.rotate(
                    angle: nowStep2 * 2 * pi / 500 -
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
                            data: "289º",
                            weight: FontWeight.w600,
                            hexColor: "#130F26",
                            size: 36,
                            height: 44 / 36,
                            gFont: GoogleFonts.inter),
                        SizedBox(height: 3),
                        TextFont(
                            data: "200",
                            weight: FontWeight.w400,
                            hexColor: "#130F26",
                            size: 14.5,
                            height: 17.5 / 14.5,
                            gFont: GoogleFonts.inter)
                      ],
                    ),
                  ),
                  //
                ],
              ),
              //
              SizedBox(
                height: 50,
              ),
              customLinearProgressTemperature(20, 100),
            ],
          );
        }),
      ),
    );
  }
}

Color customColorCircularProgress(
    int drawStep, int actualStep, int totalSteps) {
  if (drawStep <= actualStep) {
    return (Color.lerp(HexColor.fromHex("#FF8A25"), HexColor.fromHex("#FF2E2E"),
        drawStep.toDouble() / totalSteps)!);
  } else {
    return HexColor.fromHex("#E6ECF2");
  }
}

Widget customLinearProgressTemperature(int actualStep, int totalSteps) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("data"),
          Text("data"),
        ],
      ),
      StepProgressIndicator(
        size: 15,
        roundedEdges: const Radius.circular(10),
        padding: 0,
        currentStep: actualStep,
        totalSteps: totalSteps,
        selectedGradientColor: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              HexColor.fromHex("#FF8D27"),
              Color.lerp(HexColor.fromHex("#FF8D27"),
                  HexColor.fromHex("#FF2E2E"), (actualStep / totalSteps))!
            ]),
      ),
    ],
  );
}
