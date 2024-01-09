import 'dart:convert';

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

class RecipeHomePag extends StatelessWidget {
  const RecipeHomePag({super.key});

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
              //
              const SizedBox(height: 40),
              // Title
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: AlignmentDirectional.centerStart,
                child: TextFont(
                    data: "O melhor jeito de \nfazer churrasco",
                    weight: FontWeight.w700,
                    hexColor: "#0B2235",
                    size: 47,
                    height: 40.89 / 47,
                    gFont: GoogleFonts.yanoneKaffeesatz),
              ),
              //
              const SizedBox(height: 25),
              // Search Field
              Container(height: 60, child: barSerch()),
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
                        // Mais Acessadas Container
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Text Title
                              topTextCards("Mais acessadas", "Ver tudo"),
                              //
                              const SizedBox(height: 20),
                              // Image Cards
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    cardsMaisAcessadas(),
                                    cardsMaisAcessadas(),
                                    cardsMaisAcessadas()
                                  ],
                                ),
                              ),

                              const SizedBox(height: 50),

                              topTextCards("Receitas Recentes", "Ver mais"),
                              const SizedBox(height: 20),

                              SingleChildScrollView(
                                key: const Key("ScrollReceitasHome"),
                                scrollDirection: Axis.horizontal,
                                child: Transform.translate(
                                  // Negative magin to match the function left preset margin with this pag pattern margin
                                  offset: Offset(-12, 0),
                                  child: Row(
                                    children: [
                                      recipeCardsGenerator("teste"),
                                      recipeCardsGenerator("teste"),
                                      recipeCardsGenerator("teste"),
                                      recipeCardsGenerator("teste")
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
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

Widget barSerch() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: SearchAnchor(
        builder: (BuildContext context, SearchController controller) {
      return SearchBar(
        hintText: "Procurar Receitas",
        textStyle: MaterialStateTextStyle.resolveWith(
          (states) => GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              height: 19.6 / 14,
              color: HexColor.fromHex("#C1C1C1"),
            ),
          ),
        ),
        backgroundColor: MaterialStateColor.resolveWith(
          (states) => HexColor.fromHex("#ffffffff"),
        ),
        surfaceTintColor: MaterialStateColor.resolveWith(
          (states) => HexColor.fromHex("#ffffffff"),
        ),
        shape: MaterialStateProperty.all(
          const ContinuousRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        elevation: MaterialStateProperty.all(0),
        side: MaterialStateProperty.all(
            BorderSide(color: HexColor.fromHex("#D9D9D9"))),
        controller: controller,
        padding: const MaterialStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0)),
        onTap: () {
          controller.openView();
        },
        onChanged: (_) {
          controller.openView();
        },
        leading: Icon(Icons.search, color: HexColor.fromHex("#D9D9D9")),
      );
    }, suggestionsBuilder: (BuildContext context, SearchController controller) {
      return List<ListTile>.generate(5, (int index) {
        final String item = 'item $index';
        return ListTile(
          title: Text(item),
          onTap: () {},
        );
      });
    }),
  );
}

Widget topTextCards(String title, String more) {
  return Padding(
    padding: const EdgeInsets.only(right: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextFont(
            data: title,
            weight: FontWeight.w700,
            hexColor: "#303030",
            size: 20,
            height: 28 / 20,
            gFont: GoogleFonts.inter),
        Row(
          children: [
            TextFont(
                data: more,
                weight: FontWeight.w600,
                hexColor: "#E23E3E",
                size: 14,
                height: 19.6 / 14,
                gFont: GoogleFonts.poppins),
            const SizedBox(width: 3),
            Icon(
              Icons.arrow_forward,
              color: HexColor.fromHex("#E23E3E"),
              size: 20,
            )
          ],
        )
      ],
    ),
  );
}

Widget cardsMaisAcessadas() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Image Container
      Stack(
        children: [
          // Image Container
          Container(
            margin: EdgeInsets.only(left: 8),
            height: 180,
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png",
                ),
              ),
            ),
          ),
          // Stack 3 Icons Inside Image
          Container(
            margin: EdgeInsets.only(left: 8, right: 7),
            height: 180,
            width: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stars and Note card
                      Container(
                        height: 28,
                        width: 58,
                        decoration: BoxDecoration(
                            color: HexColor.fromHex("#FF5427"),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            TextFont(
                                data: "4,5",
                                weight: FontWeight.w600,
                                hexColor: "FFFFFF",
                                size: 14,
                                height: 19.6 / 14,
                                gFont: GoogleFonts.poppins),
                          ],
                        ),
                      ),
                      // Favorite Icon Circle
                      Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                              color: HexColor.fromHex("#FFFFFF"),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32 / 2))),
                          child: Icon(
                            Icons.favorite_border,
                            size: 20,
                            color: HexColor.fromHex("#FF8D27"),
                          ))
                    ],
                  ),
                ),
                //Food Type Bottom Tag
                Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.only(right: 20, bottom: 15),
                  child: IntrinsicWidth(
                    child: Container(
                        height: 26,
                        decoration: BoxDecoration(
                            color: HexColor.fromHex("#4C303030"),
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 7),
                          child: TextFont(
                              data: "Vegetais",
                              weight: FontWeight.w400,
                              hexColor: "#FFFFFF",
                              size: 12,
                              height: 18 / 12,
                              gFont: GoogleFonts.poppins),
                        )),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      //
      SizedBox(
        height: 10,
      ),
      // Text Container
      Container(
        width: 280,
        padding: const EdgeInsets.only(left: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextFont(
                data: "Bife Alcatra Com Chimichurri",
                weight: FontWeight.w600,
                hexColor: "#303030",
                size: 16,
                height: 22.4 / 16,
                gFont: GoogleFonts.inter),
            Icon(Icons.more_horiz)
          ],
        ),
      )
    ],
  );
}
