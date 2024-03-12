import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BannerInit extends StatefulWidget {
  const BannerInit({super.key});

  @override
  State<BannerInit> createState() => _BannerInitState();
}

class _BannerInitState extends State<BannerInit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          TopBar(),
          Container(
            margin: EdgeInsets.only(top: 70),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25),
              ),
              image: DecorationImage(
                opacity: 0.6,
                image: AssetImage("lib/assets/images/bannerChurrasco.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            alignment: Alignment.bottomCenter,
            /*child: Image.asset(
              ,
              width: double.infinity,
            ),*/
          ),
          Column(
            children: [
              Container(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(top: 16 + 80),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: HexColor.fromHex("#E9E9FF"), //Same Dark and Light
                    borderRadius: const BorderRadius.all(Radius.circular(28)),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 75,
                  width: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("lib/assets/images/logoNome.png"),
                    ),
                  ),
                ),
                TextFont(
                  data: "Churrasqueiras",
                  weight: FontWeight.w300,
                  hexColor: "#FF8D27",
                  size: 28,
                  gFont: GoogleFonts.yanoneKaffeesatz,
                ),
              ],
            ),
          )
          /*
          Column(
            children: [
              Container(
                color: Colors.amber, // HexColor.fromHex("#101010"),
                height: 100,
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}

Widget roundedBarIcons(double height, double width, String hexColor) {
  return Container(
    margin: const EdgeInsets.only(left: 3),
    height: height,
    width: width,
    decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(2)),
        color: HexColor.fromHex(hexColor)),
  );
}
