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

    int nowStep = 15;
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
              SizedBox(height: 50,),
              //
              
              CircularStepProgressIndicator(
                arcSize: pi * 4/3,
                startingAngle: 2*pi/3,
                totalSteps: 30,
                stepSize: 15,
                selectedStepSize: 15,
                currentStep: nowStep,
                width: 260,
                height: 260,
                
               
              )
            ],
          );
        }),
      ),
    );
  }
}


