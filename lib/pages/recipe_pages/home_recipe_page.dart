import 'dart:convert';
import 'dart:ffi';

import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc_events.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_state.dart';
import 'package:apptempesp32/dialogs_box/close_alert.dart';
import 'package:apptempesp32/pages/home_page.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/pages/recipe_pages/cards_recipe.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeHomePag extends StatefulWidget {
  const RecipeHomePag({super.key});

  @override
  State<RecipeHomePag> createState() => _RecipeHomePagState();
}

class _RecipeHomePagState extends State<RecipeHomePag> {
  final _searchBarController = TextEditingController();
  bool searchBool = false;
  final AllData _data = AllData();
  Set<String> _favoriteSet = {};

  void initState() {
    super.initState();
    _searchBarController.addListener(searchSetState);
    _searchBarController.text = _data.getSearchText;
    _data.setFavoritesUpdate(favoritesUpdate);
    _favoriteSet = _data.getFavoriteIdList;
  }

  @override
  void dispose() {
    _data.setSearchText = _searchBarController.text;
    _searchBarController.dispose();
    super.dispose();
  }

  void searchSetState() {
    setState(() {
      if (_searchBarController.text == "") {
        searchBool = false;
      } else {
        searchBool = true;
      }
    });
  }

  void favoritesUpdate() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final BlueController _blue = BlueController();
    final PageIndex _pageController = PageIndex();

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => {onBackPressed(context)},
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
                            data: searchBool
                                ? "O melhor churrasco"
                                : "O melhor jeito de \nfazer churrasco",
                            weight: FontWeight.w700,
                            hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                            size: 47,
                            height: 40.89 / 47,
                            gFont: GoogleFonts.yanoneKaffeesatz),
                      ),
                      //
                      const SizedBox(height: 25),
                      //
                      // Scrollable Pag
                      //
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              children: [
                                // Search Bar and Result Field
                                barSerch(
                                    _data,
                                    _searchBarController,
                                    searchBool,
                                    state.recipesAll['Items'],
                                    _pageController),
                                //
                                SizedBox(height: 25),
                                // Mais Acessadas Container
                                Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Top Text Title
                                      topTextCards("Mais acessadas", "Ver tudo",
                                          _data, _pageController),
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
                                              cardsMaisAcessadas(
                                                  state.recipesAll['Items']
                                                      [indice],
                                                  _data,
                                                  _pageController),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 50),

                                      topTextCards("Receitas Recentes",
                                          "Ver mais", _data, _pageController),
                                      const SizedBox(height: 20),

                                      SingleChildScrollView(
                                        key: const Key("ScrollReceitasHome"),
                                        scrollDirection: Axis.horizontal,
                                        child: Transform.translate(
                                          // Negative magin to match the function left preset margin with this pag pattern margin
                                          offset: Offset(-12, 0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              for (int indice = state
                                                          .recipesAll['Items']
                                                          .length -
                                                      1;
                                                  indice >= 0;
                                                  indice--)
                                                recipeCardsGenerator2(
                                                    state.recipesAll['Items']
                                                        [indice],
                                                    _data,
                                                    _pageController,
                                                    _data),
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
                      )
                    ],
                  )
                : BodyStart(children: []); // Vazio caso nao tiver data Ok
          }),
        ),
      ),
    );
  }
}

Widget barSerch(
    _data, searchBarController, searchBool, recipesData, _pageController) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 25.0),
    child: Column(
      children: [
        // Search Field
        Container(
          height: 40,
          padding:
              EdgeInsets.symmetric(horizontal: 10), // Padding for text hint
          decoration: BoxDecoration(
            color: _data.darkMode
                ? Colors.transparent
                : HexColor.fromHex("#0Cffffff"),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(
                color: _data.darkMode
                    ? HexColor.fromHex("#D9D9D9")
                    : Colors.transparent,
                width: 1),
          ),
          //
          child: TextFormField(
            textAlignVertical: TextAlignVertical.bottom,
            style: TextStyle(color: HexColor.fromHex("#C1C1C1")),
            controller: searchBarController,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              // Search Icon Button
              prefixIcon: IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.search,
                  color: HexColor.fromHex("#D9D9D9"),
                ),
              ),
              // Remove Icon Button
              suffixIcon: searchBool
                  ? IconButton(
                      onPressed: () {
                        searchBarController.text = "";
                      },
                      icon: Icon(
                        Icons.close,
                        color: HexColor.fromHex("#D9D9D9"),
                      ),
                    )
                  : SizedBox(),
              // Text hint
              hintText: "Procurar Receitas",
              hintStyle: TextStyle(color: HexColor.fromHex("#C1C1C1")),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        //Results Container
        searchBool
            ? Container(
                padding: EdgeInsets.only(top: 20),
                height: 400,
                //color: Colors.amber,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...listSearchFilter(recipesData, _data, _pageController,
                          searchBarController)
                    ],
                  ),
                ),
              )
            : SizedBox(),
      ],
    ),
  );
} // barSerch

List<Widget> listSearchFilter(recipesData, _data, _pageController,
    TextEditingController searchBarController) {
  var ListData = recipesData
      .where((data) =>
          data['titulo']['S']
              .toLowerCase()
              .contains(searchBarController.text.toLowerCase()) ||
          data['tipo']['S']
              .toLowerCase()
              .contains(searchBarController.text.toLowerCase()))
      .toList();

  List<Widget> output = [];
  for (int item = 0; item < ListData.length; item++) {
    output.add(Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: cardsMaisAcessadas(ListData[item], _data, _pageController),
    ));
  }
  if (output.length == 0) {
    // If nothing is finding return the warning
    print("entrou");
    output.add(Container(
      child: Text(
        "Nenhuma Receita Encontrada",
        style: TextStyle(color: Colors.red.shade400),
      ),
    ));
  }
  return output;
}

Widget topTextCards(
  String title,
  String more,
  _data,
  PageIndex pageController,
) {
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
        GestureDetector(
          onTap: () {
            pageController.setIndex = 6;
          },
          child: Row(
            children: [
              TextFont(
                  data: more,
                  weight: FontWeight.w600,
                  hexColor: _data.darkMode ? "#E23E3E" : "#FF5427",
                  size: 14,
                  height: 19.6 / 14,
                  gFont: GoogleFonts.poppins),
              const SizedBox(width: 3),
              Icon(
                Icons.arrow_forward,
                color: _data.darkMode
                    ? HexColor.fromHex("#E23E3E")
                    : HexColor.fromHex("#FF5427"),
                size: 20,
              )
            ],
          ),
        )
      ],
    ),
  );
}

