import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class blueToggle extends StatefulWidget {
  final String status;
  blueToggle({super.key, required this.status});

  @override
  State<blueToggle> createState() => _blueToggleState();
}

class _blueToggleState extends State<blueToggle> {
  @override
  Widget build(BuildContext context) {
    final BlueController _blue = BlueController();
    final AwsController _aws = AwsController();

    bool _toggleBool = _blue.getToggleBool;

    void attWidget() {
      setState(() {
        _toggleBool = !_blue.getToggleBool;
        _blue.setToggleBool = _toggleBool;
        //print(_toggleBool);
      });
    }

    Map<String, dynamic> statusToColor = {
      'Conectado': "#FF5427",
      'Conectando': "#FF8D27",
      'Buscando': "#FF8D27",
    };

    return GestureDetector(
      onTap: () {
        attWidget();
      },
      child: Container(
        alignment: Alignment.centerRight,
        child: FittedBox(
          child: _aws.getMQTTConnect
              ? wifiVersion(_toggleBool)
              : Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: HexColor.fromHex(
                          statusToColor[widget.status] ?? "#BBC8D6"),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(6))),
                  child: Row(
                    children: [
                      Icon(
                        Icons.bluetooth,
                        size: 20,
                        color: Colors.white,
                      ),
                      _toggleBool == true
                          ? TextFont(
                              data: widget.status,
                              weight: FontWeight.w700,
                              hexColor: "#FFFFFF",
                              size: 11.7,
                              height: 14.2 / 11.7,
                              gFont: GoogleFonts.inter)
                          : SizedBox(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

Widget wifiVersion(_toggleBool) {
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: HexColor.fromHex("#FF5427"),
        borderRadius: BorderRadius.horizontal(left: Radius.circular(6))),
    child: Row(
      children: [
        Icon(
          Icons.wifi,
          size: 20,
          color: Colors.white,
        ),
        _toggleBool == true
            ? TextFont(
                data: " WIFI",
                weight: FontWeight.w700,
                hexColor: "#FFFFFF",
                size: 11.7,
                height: 14.2 / 11.7,
                gFont: GoogleFonts.inter)
            : SizedBox(),
      ],
    ),
  );
}
