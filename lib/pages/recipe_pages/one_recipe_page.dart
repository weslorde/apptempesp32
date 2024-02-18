import 'dart:convert';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc_events.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_state.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
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
    final PageIndex _pageController = PageIndex();

    String actualId = _data.getSelectedRecipe;

    return Scaffold(
      appBar: const TopBar(),
      //
      bottomNavigationBar: const BottomBar(),
      //
      body: BlocBuilder<DynamoBloc, DynamoState>(
        builder: ((context, state) {
          if (state.stateActual == 'empty') {
            context.read<DynamoBloc>().add(const CheckData());
          }
          return state.stateActual == 'DataOk'
              ? BodyStart(
                  children: [
                    // Top Back Icon and More Icon
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {_pageController.setIndex = 5;}, //Go to home recipes Page
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
                          data: itemRecipeFinder(
                                  actualId, state.recipesAll)['titulo']['S']
                              .toString(),
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
                                        "https://${itemRecipeFinder(actualId, state.recipesAll)['imagem']['S']}.png",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //
                              const SizedBox(height: 15),
                              // Star and Review
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                alignment: AlignmentDirectional.centerStart,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.star,
                                        size: 16,
                                        color: HexColor.fromHex("#FFB661")),
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
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 25),
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
                                      children: // Lista ingredientes
                                          [
                                        //{state.recipesAll['Items'][actualId]['ingredientes']['L']}

                                        //ingredientsListItem(state.recipesAll['Items'][actualId]['ingredientes']['L']),

                                        for (var item = 0;
                                            item <
                                                itemRecipeFinder(actualId,
                                                            state.recipesAll)[
                                                        'ingredientes']['L']
                                                    .length;
                                            item++)
                                          ingredientsListItem(itemRecipeFinder(
                                                  actualId, state.recipesAll)[
                                              'ingredientes']['L'][item]['S'])
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Preparo
                              recipeItemMethod(
                                  "Modo de Preparo:",
                                  itemRecipeFinder(actualId, state.recipesAll)['preparo']
                                      ['L'])
                              //
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : BodyStart(children: []); // Vazio caso nao tiver data Ok
        }),
      ),
    );
  }
}

dynamic itemRecipeFinder(String recipeId, recipesAll) {
  Map<String, dynamic> teste = recipesAll['Items']
      .firstWhere((item) => item['receitaid']['S'] == recipeId);
  return teste;
}

Widget recipeItemMethod(String title, List textList) {
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
        child: Column(
          children: [
            TextFont(
                data: textList[0]['S'],
                weight: FontWeight.w400,
                hexColor: "#000000",
                size: 14,
                height: 23 / 14,
                gFont: GoogleFonts.inter),
            for (var indice = 1; indice < textList.length; indice++)
              TextFont(
                  data: "\n ${textList[indice]['S']}",
                  weight: FontWeight.w400,
                  hexColor: "#000000",
                  size: 14,
                  height: 23 / 14,
                  gFont: GoogleFonts.inter),
          ],
        ),
      ),
    ),
  );
}

Widget ingredientsListItem(text) {
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
            data: text,
            weight: FontWeight.w400,
            hexColor: "#000000",
            size: 14,
            height: 28.42 / 14,
            gFont: GoogleFonts.inter),
      )
    ],
  );
}
