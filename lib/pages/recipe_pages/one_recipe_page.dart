import 'dart:convert';

import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class OneRecipePag extends StatelessWidget {
  const OneRecipePag({super.key});

  @override
  Widget build(BuildContext context) {
    final AllData _data = AllData();
    final BlueController _blue = BlueController();

    return Scaffold(
      appBar: const TopBar(),
      //
      bottomNavigationBar: const BottomBar(),
      //
      body: BlocBuilder<BlueBloc, BlueState>(
        builder: ((context, state) {
          return BodyStart(
            children: [
              // Top Back Icon and More Icon
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: HexColor.fromHex("#0B2235"),
                        )),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              //
              const SizedBox(height: 30),
              // Title
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: AlignmentDirectional.centerStart,
                child: TextFont(
                    data: "Bife de Alcatra com Chimichurri",
                    weight: FontWeight.w700,
                    hexColor: "#0B2235",
                    size: 35,
                    height: 38.15 / 35,
                    gFont: GoogleFonts.yanoneKaffeesatz),
              ),
              //
              const SizedBox(height: 25),
              //
              // Scrollable Pag
              //
              Expanded(
                child: SingleChildScrollView(
                  key: const Key("ScrollReceitaFullPag"),
                  child: Container(
                    child: Column(
                      children: [
                        // Image Banner
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          alignment: AlignmentDirectional.centerStart,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
                                ),
                              ),
                            ),
                          ),
                        ),
                        //
                        const SizedBox(height: 15),
                        // Star and Review
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          alignment: AlignmentDirectional.centerStart,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.star,
                                  size: 16, color: HexColor.fromHex("#FFB661")),
                              const SizedBox(
                                width: 4,
                              ),
                              TextFont(
                                  data: "4,5",
                                  weight: FontWeight.w600,
                                  hexColor: "#303030",
                                  size: 14,
                                  height: 19.6 / 14,
                                  gFont: GoogleFonts.poppins),
                              const SizedBox(
                                width: 4,
                              ),
                              TextFont(
                                  data: "(300 Reviews)",
                                  weight: FontWeight.w400,
                                  hexColor: "#A9A9A9",
                                  size: 14,
                                  height: 19.6 / 14,
                                  gFont: GoogleFonts.poppins),
                            ],
                          ),
                        ),
                        //
                        const SizedBox(height: 20),
                        // Ingredientes
                        Container(
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 25),
                            title: TextFont(
                                data: "Ingredientes:",
                                weight: FontWeight.w700,
                                hexColor: "#000000",
                                size: 14,
                                height: 28.42 / 14,
                                gFont: GoogleFonts.inter),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(
                                  right:
                                      20), // Right limit of text until jump a line
                              child: Column(
                                  children: LineSplitter.split(
                                          "4 bifes de alcatra \nSal e pimenta a gosto \n1 xícara de folhas de salsa fresca \n3 dentes de alho \n2 colheres de sopa de vinagre de vinho tinto \n1 colher de chá de pimenta vermelha esmagada")
                                      .map((x) {
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // Dot mark and space
                                    TextFont(
                                        data: " \u2022 ",
                                        weight: FontWeight.w400,
                                        hexColor: "#000000",
                                        size: 14,
                                        height: 25 / 14,
                                        gFont: GoogleFonts.inter),
                                    Expanded(
                                      child: TextFont(
                                          data: x,
                                          weight: FontWeight.w400,
                                          hexColor: "#000000",
                                          size: 14,
                                          height: 28.42 / 14,
                                          gFont: GoogleFonts.inter),
                                    )
                                  ],
                                );
                              }).toList()),
                            ),
                          ),
                        ),
                        // Preparo
                        recipeItemMethod("Modo de Preparo:", loremipsum())
                        //
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

Widget recipeItemMethod(String title, String text) {
  return Container(
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25),
      title: TextFont(
          data: title,
          weight: FontWeight.w700,
          hexColor: "#000000",
          size: 14,
          height: 28.42 / 14,
          gFont: GoogleFonts.inter),
      subtitle: Padding(
        padding: const EdgeInsets.only(
            right: 20), // Right limit of text until jump a line
        child: TextFont(
            data: text,
            weight: FontWeight.w400,
            hexColor: "#000000",
            size: 14,
            height: 23 / 14,
            gFont: GoogleFonts.inter),
      ),
    ),
  );
}


String loremipsum(){
  return ''' Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Orci ac auctor augue mauris augue. Integer eget aliquet nibh praesent tristique magna. Tortor condimentum lacinia quis vel eros donec ac. Tellus cras adipiscing enim eu turpis egestas. Vitae ultricies leo integer malesuada. Vitae sapien pellentesque habitant morbi tristique. Sed cras ornare arcu dui vivamus. Mauris rhoncus aenean vel elit scelerisque. Cras tincidunt lobortis feugiat vivamus at augue. Felis eget velit aliquet sagittis id consectetur.

Viverra accumsan in nisl nisi scelerisque eu ultrices. Tristique magna sit amet purus gravida quis blandit. Ultricies mi quis hendrerit dolor magna eget. Magna sit amet purus gravida quis. Ac odio tempor orci dapibus ultrices in iaculis. Nulla facilisi etiam dignissim diam quis. Viverra suspendisse potenti nullam ac tortor vitae. Ut eu sem integer vitae justo eget magna. Nullam ac tortor vitae purus faucibus ornare. Enim neque volutpat ac tincidunt vitae semper quis. Duis ut diam quam nulla porttitor massa id neque. Pellentesque dignissim enim sit amet venenatis urna cursus eget nunc. Ut etiam sit amet nisl purus in mollis nunc. Dolor morbi non arcu risus quis varius quam quisque.''';
}