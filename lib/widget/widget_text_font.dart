import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextYanKaf extends StatelessWidget {
  TextYanKaf({super.key, required this.data, required this.weight, required this.hexColor, required this.size, this.height = 1});
  String data;
  FontWeight weight;
  String hexColor;
  double size;
  double height;

  Widget build(BuildContext context) {
    return Text(
      data,
      style: GoogleFonts.yanoneKaffeesatz(
          textStyle: TextStyle(
              height: height,
              fontWeight: weight,
              color: HexColor.fromHex(hexColor),
              fontSize: size)),
    );
  }
}

class TextFont extends StatelessWidget {
  TextFont({super.key, required this.data, required this.weight, required this.hexColor, required this.size, required this.gFont, this.height = 1, this.letter = 0});
  String data;
  FontWeight weight;
  String hexColor;
  double size;
  double height;
  var gFont;
  double letter;

  Widget build(BuildContext context) {
    return Text(
      data,
      style: gFont(
          textStyle: TextStyle(
              letterSpacing: letter == 0 ? null : 0.01*size*letter, //Figma % convert, maybe wrong!
              height: height,
              fontWeight: weight,
              color: HexColor.fromHex(hexColor),
              fontSize: size)),
    );
  }
}


