import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc_events.dart';
import 'package:apptempesp32/dialogs/close_alert.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/pages/recipe_pages/cards_recipe.dart';
import 'package:apptempesp32/pages/recipe_pages/home_recipe_page.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void attState() {
    //fun to update current body Page
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final AllData _data = AllData();
    final BlueController _blue = BlueController();
    final PageIndex _pageController = PageIndex();

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => {onBackPressed(context)},
      child: Scaffold(
        backgroundColor:
            _data.darkMode ? Colors.white : HexColor.fromHex('#101010'),
        appBar: TopBar(),
        //
        bottomNavigationBar: BottomBar(),
        //
        body: MultiBlocProvider(
          providers: [
            BlocProvider<DynamoBloc>(
              create: (BuildContext context) => DynamoBloc(),
            )
          ],
          child: Builder(builder: (context) {
            final dynamoState = context.watch<DynamoBloc>().state;
            final blueState = context.watch<BlueBloc>().state;
            if (dynamoState.stateActual == 'empty') {
              context.read<DynamoBloc>().add(const CheckData());
            }
            return dynamoState.stateActual == 'DataOk'
                ? BodyStart(children: [
                      // Top spacing need - 20 px to macth
                      // Start of Perfil Avatar and Text
                      Container(
                        margin: const EdgeInsets.only(left: 28, top: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 46 / 2,
                                  backgroundColor: Colors.white,
                                  child: Icon(
                                      size: 46,
                                      color: Colors.black45,
                                      Icons.supervised_user_circle),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Text(
                                    "Olá!",
                                    style: GoogleFonts.yanoneKaffeesatz(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: _data.darkMode
                                                ? HexColor.fromHex("#303030")
                                                : Colors.white,
                                            fontSize: 33)),
                                  ),
                                ),
                              ],
                            ),
                            // Icon Dark Mode
                            GestureDetector(
                              onTap: () {
                                _data.setDarkMode();
                                attState();
                              },
                              child: Container(
                                height: 40,
                                width: 70,
                                //color: Colors.amber,
                                child: _data.darkMode
                                    ? const Icon(
                                        Icons.dark_mode_outlined,
                                        color: Colors.black,
                                      )
                                    : const Icon(
                                        Icons.light_mode,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //Scrool screen
          
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              //TEXTO Quadros Acesso Rapido
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 24, right: 24, top: 50),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Seus acessos rápidos",
                                      style: GoogleFonts.yanoneKaffeesatz(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: _data.darkMode
                                                  ? HexColor.fromHex(
                                                      "#690B2235")
                                                  : Colors.white,
                                              fontSize: 16)),
                                    ),
                                    Row(
                                      children: [
                                        roundedBarIcons(4, 4, "#FF8D27"),
                                        roundedBarIcons(4, 20, "#D9D9D9"),
                                        roundedBarIcons(4, 20, "#D9D9D9"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              //Quadros Acesso Rapido
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 15),
                                height: 117,
                                child: SingleChildScrollView(
                                  key: const Key("ScrollAcessoRapido"),
                                  scrollDirection: Axis.horizontal,
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 24),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: homeCardsGenerator(
                                              Icons.key,
                                              "Meus             Dispositivos",
                                              0),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _pageController.setIndex = 2;
                                          },
                                          child: homeCardsGenerator(
                                              Icons.timer_sharp,
                                              "Meus             Alarmes",
                                              1),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _pageController.setIndex = 7;
                                          },
                                          child: homeCardsGenerator(Icons.wifi,
                                              "Configurar       Wi-fi", 2),
                                        ),
                                        //...homeCardsGenerator(
                                        //    Icons.key, "Meus Dispositivos", 0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        
                              // Space
                              SizedBox(height: 40),
                              //Quadro Receitas
                              Column(
                                children: [
                                  // TEXTO Quadro Receitas
                                  Container(
                                    margin: EdgeInsets.only(left: 22),
                                    child: TextYanKaf(
                                      data:
                                          "Deixe seu churrasco                                                                     com ainda mais sabor",
                                      height: 0.87,
                                      weight: FontWeight.w700,
                                      hexColor: _data.darkMode
                                          ? "#0B2235"
                                          : "#FFFFFF",
                                      size: 35,
                                    ),
                                  ),
                                  // Space
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // QUADRO Receitas
                                  SingleChildScrollView(
                                    key: const Key("ScrollReceitasHome"),
                                    scrollDirection: Axis.horizontal,
                                    child: Transform.translate(
                                      // Negative magin to match the function left preset margin with this pag pattern margin
                                      offset: Offset(0, 0),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          for (int indice = dynamoState
                                                      .recipesAll['Items']
                                                      .length -
                                                  1;
                                              indice >= 0;
                                              indice--)
                                            recipeCardsGenerator3(
                                                dynamoState.recipesAll['Items']
                                                    [indice],
                                                _data,
                                                _pageController,
                                                _data),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                : Column(children: []); // Vazio caso nao tiver data Ok
          }),
        ),
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

Widget homeCardsGenerator(IconData myIcon, String myText, int colorIndex) {
  List<List<Color>> colorList = [
    [HexColor.fromHex("#FA3E3E"), HexColor.fromHex("#F20E0E")],
    [HexColor.fromHex("#FF8D27"), HexColor.fromHex("#FF5427")],
    [HexColor.fromHex("#003E5C"), HexColor.fromHex("#0B2235")],
  ];
  return Row(children: [
    Container(
      width: 113,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: colorList[colorIndex],
          )),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(myIcon, color: Colors.white),
            const SizedBox(
              height: 14,
            ),
            Text(myText,
                style: GoogleFonts.yanoneKaffeesatz(
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 18)))
          ],
        ),
      ),
    ),
    const SizedBox(
      width: 14,
    )
  ]);
}

Widget recipeCardsGenerator(String myText, var _data) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 21),
        width: 124,
        height: 124,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage("https://i.ibb.co/98CqG2n/Hi-Fi-Rush.png"),
              fit: BoxFit.cover),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 25, top: 7),
        width: 124 - 4,
        child: TextFont(
          data: "Alcatra com            alho e mostarda",
          weight: FontWeight.w600,
          hexColor: _data.darkMode ? '#303030' : '#FFFFFF',
          size: 14,
          height: 16.66 / 14,
          gFont: GoogleFonts.inter,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 25),
        child: TextFont(
          data: "Há 2 horas",
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

Widget recipeCardsGenerator3(
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

//Text(myText, style: const TextStyle(color: Colors.white ))
