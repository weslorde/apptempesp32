import 'dart:convert';

import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc_events.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_state.dart';
import 'package:apptempesp32/pages/home_page.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/pages/recipe_pages/cards_recipe.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MoreRecipePag extends StatefulWidget {
  const MoreRecipePag({super.key});

  @override
  State<MoreRecipePag> createState() => _MoreRecipePagState();
}

class _MoreRecipePagState extends State<MoreRecipePag> {
  final AllData _data = AllData();
  final BlueController _blue = BlueController();
  final PageIndex _pageController = PageIndex();

  @override
  void initState() {
    _data.loadFavoriteIdList();
    _data.setFavoritesUpdate(favoritesUpdate);
    super.initState();
  }

  void favoritesUpdate() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => {_pageController.setIndex = 4},
      child: Scaffold(
        backgroundColor:
            _data.darkMode ? Colors.white : HexColor.fromHex('#101010'),
        appBar: const TopBar(),
        //
        bottomNavigationBar: BottomBar(),
        //
        body: BlocBuilder<DynamoBloc, DynamoState>(
          builder: ((context, state) {
            if (state.stateActual == 'empty') {
              context.read<DynamoBloc>().add(const CheckData());
            }
            return state.stateActual == 'DataOk'
                ? BodyStart(
                    children: [
                      //
                      const SizedBox(height: 40),
                      // Title
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        alignment: AlignmentDirectional.centerStart,
                        child: TextFont(
                            data: "Todas as receitas",
                            weight: FontWeight.w700,
                            hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                            size: 47,
                            height: 40.89 / 47,
                            gFont: GoogleFonts.yanoneKaffeesatz),
                      ),
                      //
                      const SizedBox(height: 25),
                      // Search Field
                      //Container(height: 60, child: barSerch(_data)),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Top Text Title
                                      topTextCards2("Favoritas", _data),
                                      //
                                      const SizedBox(height: 20),
                                      // Image Cards
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            // For creat all the cards on Mais acessadas

                                            for (int indice = state
                                                        .recipesAll['Items']
                                                        .length -
                                                    1;
                                                indice >= 0;
                                                indice--)
                                              isInFavorites(state.recipesAll['Items'][indice], _data) ? cardsMaisAcessadas(
                                                  state.recipesAll['Items']
                                                      [indice],
                                                  _data,
                                                  _pageController)
                                              : SizedBox(),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 50),

                                      topTextCards2("Mais Receitas", _data),
                                      const SizedBox(height: 30),

                                      SingleChildScrollView(
                                        key: const Key("ScrollReceitasHome"),
                                        scrollDirection: Axis.vertical,
                                        child: Transform.translate(
                                          // Negative magin to match the function left preset margin with this pag pattern margin
                                          offset: Offset(-12, 0),
                                          child: Center(
                                            child: Column(
                                              children: [
                                                for (int indice = state
                                                            .recipesAll['Items']
                                                            .length -
                                                        1;
                                                    indice >= 0;
                                                    indice--)
                                                  Column(
                                                    children: [
                                                      cardsMaisAcessadas(
                                                          state.recipesAll[
                                                              'Items'][indice],
                                                          _data,
                                                          _pageController),
                                                      //
                                                      SizedBox(height: 40)
                                                    ],
                                                  ),
                                              ],
                                            ),
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
                  )
                : BodyStart(children: []); // Vazio caso nao tiver data Ok
          }),
        ),
      ),
    );
  }
}

Widget topTextCards2(String title, _data) {
  return Padding(
    padding: const EdgeInsets.only(right: 25),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextFont(
            data: title,
            weight: FontWeight.w700,
            hexColor: _data.darkMode ? "#303030" : "#FFFFFF",
            size: 20,
            height: 28 / 20,
            gFont: GoogleFonts.inter),
      ],
    ),
  );
}

/*
Widget cardsMaisAcessadas(
    dynamic recipeItem, AllData _data, PageIndex pageController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Image Container
      Stack(
        children: [
          // Image Container
          GestureDetector(
            onTap: () {
              _data.setSelectedRecipe = recipeItem['receitaid']['S'];
              pageController.setIndex = 6;
            },
            child: Container(
              margin: EdgeInsets.only(left: 8),
              height: 180,
              width: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    "https://${recipeItem['imagem']['S']}.png",
                  ),
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
                                data: recipeItem['nota']['S'],
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
                              data: recipeItem['tipo']['S'],
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
                data: recipeItem['titulo']['S'],
                weight: FontWeight.w600,
                hexColor: _data.darkMode ? "#303030" : "#FFFFFF",
                size: 16,
                height: 22.4 / 16,
                gFont: GoogleFonts.inter),
            // More Icon
            Icon(
              Icons.more_horiz,
              color: _data.darkMode
                  ? HexColor.fromHex("#000000")
                  : HexColor.fromHex("#747D8C"),
            )
          ],
        ),
      )
    ],
  );
}
*/

Widget recipeCardsGenerator2(
    dynamic recipeItem, AllData data, PageIndex pageController, _data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          data.setSelectedRecipe = recipeItem['receitaid']['S'];
          pageController.setIndex = 6;
        },
        child: Container(
          margin: const EdgeInsets.only(left: 21),
          width: 124,
          height: 124,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("https://${recipeItem['imagem']['S']}.png"),
                fit: BoxFit.cover),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 25, top: 7),
        width: 124 - 4,
        child: TextFont(
          data: recipeItem['titulo']['S'],
          weight: FontWeight.w600,
          hexColor: _data.darkMode ? '#303030' : "FFFFFF",
          size: 14,
          height: 16.66 / 14,
          gFont: GoogleFonts.inter,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 25),
        child: TextFont(
          data: calcDeltaTime(recipeItem['datatime']['N']),
          weight: FontWeight.w400,
          hexColor: '#A9A9A9',
          size: 10,
          height: 15 / 10,
          gFont: GoogleFonts.poppins,
        ),
      ),
    ],
  );
}

String calcDeltaTime(String dataTime) {
  double actualData = DateTime.now().millisecondsSinceEpoch /
      1000; // 1000 milli -> result in seconds
  var deltaHours = ((actualData) - int.parse(dataTime)) /
      3600; // 3600 = 60seg * 60min -> result in hours
  if (deltaHours < 24) {
    if (deltaHours == 1) {
      return "há ${deltaHours.toInt()} hora";
    }
    return "há ${deltaHours.toInt()} horas";
  } else if (deltaHours / 24 < 7) {
    int deltaDay = (deltaHours / 24).toInt();
    if (deltaDay == 1) {
      return "há ${deltaDay} dia";
    } else {
      return "há ${deltaDay} dias";
    }
  } else {
    int deltaWeek = (deltaHours / 168).toInt();
    if (deltaWeek == 1) {
      return "há ${deltaWeek} semana";
    } else {
      return "há ${deltaWeek} semanas";
    }
  }
}

bool isInFavorites(_recipeData, _data) {
  // state.recipesAll['Items']
  var IdFavorites = _data.getFavoriteIdList;
  bool containsValue = IdFavorites.contains(_recipeData['receitaid']['S']);
  return containsValue;
}
