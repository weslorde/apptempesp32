import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc_events.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc_events.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_state.dart';
import 'package:apptempesp32/dialogs_box/alexa_link_alert.dart';
import 'package:apptempesp32/dialogs_box/close_alert.dart';
import 'package:apptempesp32/dialogs_box/info_config_alert.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/widget/widget_blue_toggle.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PagAlexaLink extends StatelessWidget {
  const PagAlexaLink({super.key});

  @override
  Widget build(BuildContext context) {
    final BlueController _blue = BlueController();
    final AwsController _aws = AwsController();
    final AllData _data = AllData();
    final PageIndex _pageController = PageIndex();
    final TextEditingController _textEmailController = TextEditingController();
    final TextEditingController _textCodeController = TextEditingController();

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => {_pageController.setIndex = 7},
      child: Scaffold(
        backgroundColor:
            _data.darkMode ? Colors.white : HexColor.fromHex('#101010'),
        appBar: TopBar(),
        //
        bottomNavigationBar: BottomBar(),
        //
        body: MultiBlocProvider(
          providers: [
            BlocProvider<CertBloc>(
              create: (BuildContext context) => CertBloc(),
            )
          ],
          child: Builder(
            builder: (context) {
              final certState = context.watch<CertBloc>().state;
              final awsState = context.watch<AwsBloc>().state;
              final blueState = context.watch<BlueBloc>().state;

              _aws.setfunAlexaLink = (int n) {
                Navigator.of(context).pop(); // Close Loading Dialog
                if (n == 0) {
                  context.read<CertBloc>().add(const ALinkDataRecived());
                } else if (n == 1) {
                  context.read<CertBloc>().add(const ALinkWarning());
                }
              };
              if (certState.stateActual == "empty") {
                context.read<CertBloc>().add(const ALinkIni());
              }
              List<String> listItens = [
                "ALinkIni",
                "ALinkTutorial1",
                "ALinkTutorial2",
                "ALinkTutorial3",
                "ALinkTutorial4"
              ];
              return BodyStart(
                children: [
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (certState.stateActual == "ALinkIni")
                              AlexaTutorial0(_data)
                            else if (certState.stateActual == "ALinkTutorial1")
                              AlexaTutorial1(context, _data)
                            else if (certState.stateActual == "ALinkTutorial2")
                              AlexaTutorial2(context, _data)
                            else if (certState.stateActual == "ALinkTutorial3")
                              AlexaTutorial3(context, _data)
                            else if (certState.stateActual == "ALinkTutorial4")
                              AlexaTutorial4(context, _data, _aws)
                            else
                              Container(),
                            BottonSelector(
                                listItens.indexWhere((element) =>
                                    element == certState.stateActual),
                                context.read<CertBloc>())
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

Widget AlexaTutorial0(_data) {
  return Container(
      child: Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextYanKaf(
          data: "Conectar com Alexa",
          height: 0.87,
          weight: FontWeight.w700,
          hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
          size: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 40),
          child: TextYanKaf(
            data:
                "Veja as instruções, ao final acesse o link na tela para conectar com a skill Alexa.",
            height: 1.2,
            weight: FontWeight.w500,
            hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
            size: 25,
          ),
        ),
        SizedBox(),
      ],
    ),
  ));
}

Widget AlexaTutorial1(context, _data) {
  return Container(
    child: Column(
      children: [
        TextYanKaf(
          data: "Ativar Skill",
          height: 0.87,
          weight: FontWeight.w700,
          hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
          size: 30,
        ),
        SizedBox(height: 30),
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 4),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0 - 4),
                child: Image.asset('lib/assets/images/amazon/AmazonAtivar.jpg',
                    width: MediaQuery.of(context).size.width * 0.7))),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 40),
          child: TextYanKaf(
            data:
                "Se necessario entre com sua conta Amazon e aperte em ativar.",
            height: 1.2,
            weight: FontWeight.w500,
            hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
            size: 25,
          ),
        ),
      ],
    ),
  );
}

Widget AlexaTutorial2(context, _data) {
  return Container(
    child: Column(
      children: [
        TextYanKaf(
          data: "Vincular Conta",
          height: 0.87,
          weight: FontWeight.w700,
          hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
          size: 30,
        ),
        SizedBox(height: 30),
        Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 4),
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0 - 4),
                child: Image.asset(
                    'lib/assets/images/amazon/AmazonVincular.jpg',
                    width: MediaQuery.of(context).size.width * 0.7))),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 40),
          child: TextYanKaf(
            data: "Aperte em vincular conta.",
            height: 1.2,
            weight: FontWeight.w500,
            hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
            size: 25,
          ),
        ),
      ],
    ),
  );
}

Widget AlexaTutorial3(context, _data) {
  return Container(
    child: Column(
      children: [
        TextYanKaf(
          data: "Vincular Conta",
          height: 0.87,
          weight: FontWeight.w700,
          hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
          size: 30,
        ),
        SizedBox(height: 30),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 4),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0 - 4),
            child: Image.asset('lib/assets/images/amazon/AmazonPermitir.jpg',
                width: MediaQuery.of(context).size.width * 0.5),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 4),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0 - 4),
            child: Image.asset('lib/assets/images/amazon/AmazonConcluido.jpg',
                width: MediaQuery.of(context).size.width * 0.5),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 40),
          child: TextYanKaf(
            data:
                "Permita que a conta seja vinculada, ao concluir feche através do X para retornar.",
            height: 1.2,
            weight: FontWeight.w500,
            hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
            size: 25,
          ),
        ),
      ],
    ),
  );
}

Widget AlexaTutorial4(context, _data, _aws) {
  final Uri _url = Uri.parse('https://www.amazon.com.br/dp/B0D63DLP9X/');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textCodeController = TextEditingController();

  return Container(
      child: Column(
    children: [
      // Title
      TextYanKaf(
        data: "Cadastro Skill",
        height: 0.87,
        weight: FontWeight.w700,
        hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
        size: 30,
      ),
      SizedBox(height: 40),
      // Button Container Link Skill
      GestureDetector(
        onTap: _launchUrl,
        child: Container(
          height: 62,
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color:
                    _data.darkMode ? Colors.white : HexColor.fromHex('#FF5427'),
              ),
              borderRadius: BorderRadius.circular(12),
              color: _data.darkMode
                  ? HexColor.fromHex("#0B2235")
                  : Colors.transparent),
          margin: EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.open_in_browser,
                color: Colors.white,
                size: 23,
              ),
              SizedBox(
                width: 10,
              ),
              TextFont(
                  data: "Acessar Alexa Skill",
                  weight: FontWeight.w700,
                  hexColor: "#FFFFFF",
                  size: 16,
                  height: 19.36 / 16,
                  letter: 12,
                  gFont: GoogleFonts.inter),
            ],
          ),
        ),
      ),
      //TextButton(onPressed: _launchUrl, child: Text("MeuLink")),
      SizedBox(height: 40),
      // Skill vinculado com sucesso?
      TextYanKaf(
        data: "A Skill foi vinculada com successo?",
        height: 0.87,
        weight: FontWeight.w500,
        hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
        size: 25,
      ),
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: TextYanKaf(
          data:
              '- Utilize o comando de voz com sua alexa para iniciar a skill dizendo: "Alexa, abrir meu churrasco"',
          height: 0.9,
          weight: FontWeight.w500,
          hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
          size: 20,
        ),
      ),
      SizedBox(height: 20),
      //
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: TextYanKaf(
          data: "- Em seguida pergunte qual o código de cadrastro                            ",
          height: 0.87,
          weight: FontWeight.w500,
          hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
          size: 20,
        ),
      ),
      //
      SizedBox(height: 30),
      // Forms Email and Code
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: BoxDecoration(
                  color: _data.darkMode
                      ? HexColor.fromHex('#F8F8F8')
                      : Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextFormField(
                style: TextStyle(
                  color: _data.darkMode ? Colors.black : Colors.white,
                ),
                controller: _textEmailController,
                decoration: InputDecoration(
                    hintText: "Email Cadastrado na Alexa",
                    hintStyle: TextStyle(
                      color: _data.darkMode ? Colors.black38 : Colors.white38,
                    )),
              )),
          //
          SizedBox(height: 10),
          //
          Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 60,
              decoration: BoxDecoration(
                  color: _data.darkMode
                      ? HexColor.fromHex('#F8F8F8')
                      : Colors.black45,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextFormField(
                style: TextStyle(
                  color: _data.darkMode ? Colors.black : Colors.white,
                ),
                controller: _textCodeController,
                decoration: InputDecoration(
                    hintText: "Código de Cadastro (4 números)",
                    hintStyle: TextStyle(
                      color: _data.darkMode ? Colors.black38 : Colors.white38,
                    )),
              )),
        ]),
      ),
      //
      SizedBox(height: 20),

      TextButton(
          onPressed: () {
            infoConfigAlert(context, "Conexão Internet", "");
            _aws.awsMsg('DynamoSendShadow/update',
                '{"state": { "desired": {"MsgError": "", "Email": "${_textEmailController.text}", "Dispositivo": "${_aws.getDispName}", "MyKey": "${_textCodeController.text}", "Error": "0", "MsgError": ""}}}');
            context.read<CertBloc>().add(const ALinkLoading());
          },
          child: Text(
            "TESTE",
            style: TextStyle(
              color: _data.darkMode ? Colors.black : Colors.white,
            ),
          )),
      SizedBox(
        height: 30,
      ),
      Text(
        "Mensagem: ${_aws.getAlexaLinkResponse}",
        style: TextStyle(
          color: _data.darkMode ? Colors.black : Colors.white,
        ),
      )
    ],
  ));
}

Widget BottonSelector(int actualPag, testeww) {
  List listSelect = [
    ALinkIni(),
    ALinkTutorial1(),
    ALinkTutorial2(),
    ALinkTutorial3(),
    ALinkTutorial4()
  ];
  int totalpags = 5;
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              if (actualPag != 0) {
                testeww.add(listSelect[actualPag - 1]);
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 40,
              color: actualPag != 0 ? Colors.black : Colors.transparent,
            )),
        for (int pag = 0; pag < totalpags; pag++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Icon(
              Icons.circle,
              size: 20,
              color: pag == actualPag ? Colors.black : Colors.grey.shade300,
            ),
          ),
        IconButton(
            onPressed: () {
              if (actualPag != totalpags - 1) {
                testeww.add(listSelect[actualPag + 1]);
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 40,
              color: actualPag != totalpags - 1
                  ? Colors.black
                  : Colors.transparent,
            )),
      ],
    ),
  );
}
