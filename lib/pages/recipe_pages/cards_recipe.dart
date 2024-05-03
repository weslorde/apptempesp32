import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
              pageController.setIndex = 5;
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
                      GestureDetector(
                        onTap: () {
                          String myId = recipeItem['receitaid']['S'];
                          if (hasInFavorites(_data.getFavoriteIdList, myId)) {
                            _data.removeFavoriteIdSet(myId);
                          } else {
                            _data.setFavoriteIdSet(myId);
                          }
                          //print("Set1");
                          _data.getFavoritesUpdate();
                        },
                        child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                                color: HexColor.fromHex("#FFFFFF"),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32 / 2))),
                            child: Icon(
                              hasInFavorites(_data.getFavoriteIdList,
                                      recipeItem['receitaid']['S'])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: HexColor.fromHex("#FF8D27"),
                            )),
                      )
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

Widget recipeCardsGenerator2(
    dynamic recipeItem, AllData data, PageIndex pageController, _data) {
  return Column( 
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          data.setSelectedRecipe = recipeItem['receitaid']['S'];
          pageController.setIndex = 5;
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

bool hasInFavorites(_favoriteSet, id) {
  return _favoriteSet.contains(id);
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

