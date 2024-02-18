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
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class MotorPage extends StatelessWidget {
  const MotorPage({super.key});

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
              //Big Title
              Container(
                margin: EdgeInsets.only(left: 30),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFont(
                        data: "Ajuste a altura da grelha",
                        weight: FontWeight.w700,
                        hexColor: "#130F26",
                        size: 35,
                        height: 34.72 / 35,
                        gFont: GoogleFonts.yanoneKaffeesatz),
                    //
                    SizedBox(height: 20),
                    // Model title text
                    TextFont(
                        data: "Modelo atual",
                        weight: FontWeight.w700,
                        hexColor: "#000000",
                        size: 18,
                        height: 28.42 / 20,
                        gFont: GoogleFonts.yanoneKaffeesatz),
                  ],
                ),
              ),
              //
              SizedBox(height: 5),
              // Row of Box Models
              Padding(
                padding: const EdgeInsets.only(left: 31),
                child: Row(
                  children: [
                    modelContainer(true, "Modelo 1"),
                    modelContainer(false, "Modelo 2"),
                    modelContainer(false, "Modelo 3"),
                  ],
                ),
              ),
              //
              SizedBox(height: 100),

              

              // Buttom new alarm
              /*Container(
                height: 62,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: HexColor.fromHex("#0B2235")),
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
                        data: "CONFIRMAR ALTURA",
                        weight: FontWeight.w700,
                        hexColor: "#FFFFFF",
                        size: 16,
                        height: 19.36 / 16,
                        letter: 12,
                        gFont: GoogleFonts.inter),
                  ],
                ),
              )*/
            ],
          );
        }),
      ),
    );
  }
}

Widget modelContainer(bool selected, String modelo) {
  String primaryColor;
  String secondaryColor;
  if (selected) {
    primaryColor = "#FF5427";
    secondaryColor = "#FFFFFF";
  } else {
    primaryColor = "#FFFFFF";
    secondaryColor = "#FF5427";
  }
  return Container(
    margin: EdgeInsets.only(right: 5),
    alignment: Alignment.center,
    width: 83.2,
    height: 22.4,
    decoration: BoxDecoration(
        color: HexColor.fromHex(primaryColor),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 0.8,
          color: HexColor.fromHex("#FF5427"),
        )),
    child: TextFont(
        data: modelo,
        weight: FontWeight.w800,
        hexColor: secondaryColor,
        size: 10.4,
        gFont: GoogleFonts.inter),
  );
}
