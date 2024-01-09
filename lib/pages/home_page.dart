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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AllData _data = AllData();
    final BlueController _blue = BlueController();

    return Scaffold(
      appBar: const TopBar(),
      //
      bottomNavigationBar: BottomBar(),
      //
      body: BlocBuilder<BlueBloc, BlueState>(
        builder: ((context, state) {
          return BodyStart(children: [
            // Top spacing need - 20 px to macth
            // Start of Perfil Avatar and Text
            Container(
              margin: const EdgeInsets.only(left: 28, top: 26),
              child: Row(
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
                              color: HexColor.fromHex("#303030"),
                              fontSize: 33)),
                    ),
                  )
                ],
              ),
            ),
            //TEXTO Quadros Acesso Rapido
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Seus acessos rápidos",
                    style: GoogleFonts.yanoneKaffeesatz(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: HexColor.fromHex("#690B2235"),
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
              margin: const EdgeInsets.symmetric(vertical: 15),
              height: 113,
              child: SingleChildScrollView(
                key: const Key("ScrollAcessoRapido"),
                scrollDirection: Axis.horizontal,
                child: Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: Row(
                    children: [
                      ...homeCardsGenerator(
                          Icons.key, "Meus             Dispositivos", 0),
                      ...homeCardsGenerator(
                          Icons.timer_sharp, "Meus             Alarmes", 1),
                      ...homeCardsGenerator(
                          Icons.wifi, "Configurar       Wi-fi", 2),
                      ...homeCardsGenerator(Icons.key, "Meus Dispositivos", 0),
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
                    hexColor: "#0B2235",
                    size: 35,
                  ),
                ),
                // Space
                SizedBox(height: 20,),
                // QUADRO Receitas
                Container(
                  child: SingleChildScrollView(
                    key: const Key("ScrollReceitasHome"),
                    scrollDirection: Axis.horizontal,
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
              ],
            )
          ]);
        }),
        // End of return of Bloc Builder
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

List<Widget> homeCardsGenerator(
    IconData myIcon, String myText, int colorIndex) {
  List<List<Color>> colorList = [
    [HexColor.fromHex("#FA3E3E"), HexColor.fromHex("#F20E0E")],
    [HexColor.fromHex("#FF8D27"), HexColor.fromHex("#FF5427")],
    [HexColor.fromHex("#003E5C"), HexColor.fromHex("#0B2235")],
  ];
  return [
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
  ];
}

Widget recipeCardsGenerator(String myText) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(left: 21),
        width: 124,
        height: 124,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                  "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/220px-Image_created_with_a_mobile_phone.png"),
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
          hexColor: '#303030',
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

//Text(myText, style: const TextStyle(color: Colors.white ))
