import 'dart:ffi';

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
import 'package:email_validator/email_validator.dart';
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
                if (_data.getAlexaLinkPopLoad) {
                  _data.setAlexaLinkPopLoad = false;
                  // Close Loading Dialog
                  Navigator.of(context).pop();
                }
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
                "ALinkTutorial4",
                "ALinkTutorial5"
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
                              AlexaTutorial4(context, _data)
                            else
                              AlexaTutorial5(context, _data,
                                  context.read<CertBloc>(), _aws),
                            BottonSelector(
                                listItens.indexWhere((element) =>
                                    element == certState.stateActual),
                                context.read<CertBloc>(),
                                _data)
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
              border: Border.all(
                  color: _data.darkMode ? Colors.black : Colors.white,
                  width: 4),
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
              border: Border.all(
                  color: _data.darkMode ? Colors.black : Colors.white,
                  width: 4),
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
            border: Border.all(
                color: _data.darkMode ? Colors.black : Colors.white, width: 4),
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
            border: Border.all(
                color: _data.darkMode ? Colors.black : Colors.white, width: 4),
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

Widget AlexaTutorial4(context, _data) {
  final Uri _url = Uri.parse('https://www.amazon.com.br/dp/B0D63DLP9X/');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  return Container(
    child: Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          TextYanKaf(
            data: "Cadastro Skill",
            height: 0.87,
            weight: FontWeight.w700,
            hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
            size: 30,
          ),
          //
          // Warning close page
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 25),
            child: TextYanKaf(
              data:
                  "Caso a página não carregue feche através do X e tente novamente.",
              height: 1,
              weight: FontWeight.w500,
              hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
              size: 25,
            ),
          ),
          // Button Container Link Skill
          GestureDetector(
            onTap: _launchUrl,
            child: Container(
              height: 62,
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: _data.darkMode
                        ? Colors.white
                        : HexColor.fromHex('#FF5427'),
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
        ],
      ),
    ),
  );
}

Widget AlexaTutorial5(context, _data, certBloc, _aws) {
  final TextEditingController _textEmailController = TextEditingController();
  final TextEditingController _textCodeController = TextEditingController();

  bool isFourDigitNumber(String input) {
    final regex = RegExp(r'^\d{4}$');
    if (regex.hasMatch(input)) {
      // Se tiver 4 digitos
      if (int.parse(input) % 127 == 0) {
        return true;
      }
    }
    return false;
  }

  return Container(
      child: Expanded(
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
        //
        SizedBox(height: 15),
        // Scroll Screen
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //
                SizedBox(height: 30),
                // Skill vinculado com sucesso?
                TextYanKaf(
                  data: "A Skill foi vinculada com successo?",
                  height: 0.87,
                  weight: FontWeight.w500,
                  hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                  size: 25,
                ),
                SizedBox(height: 20),
                // Abrir meu churrasco
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
                //
                SizedBox(height: 20),
                // Pedir Codigo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextYanKaf(
                    data:
                        "- Em seguida pergunte qual o código de cadrastro                            ",
                    height: 0.87,
                    weight: FontWeight.w500,
                    hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                    size: 20,
                  ),
                ),
                //
                SizedBox(height: 20),
                // Pedir Email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: TextYanKaf(
                    data:
                        "- Caso necessário pergunte qual o Email                                         ",
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        // EMAIL FORM
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            color: _data.darkMode ? Colors.black : Colors.white,
                          ),
                          controller: _textEmailController,
                          decoration: InputDecoration(
                              hintText: "Email Cadastrado na Alexa",
                              hintStyle: TextStyle(
                                color: _data.darkMode
                                    ? Colors.black38
                                    : Colors.white38,
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        // Key FORM
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: _data.darkMode ? Colors.black : Colors.white,
                          ),
                          controller: _textCodeController,
                          decoration: InputDecoration(
                              hintText: "Código de Cadastro (4 números)",
                              hintStyle: TextStyle(
                                color: _data.darkMode
                                    ? Colors.black38
                                    : Colors.white38,
                              )),
                        )),
                  ]),
                ),
                //
                SizedBox(
                  height: 20,
                ),
                // Resposta do cadastro
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: TextYanKaf(
                    data: ResponseFullString(_aws.getAlexaLinkResponse),
                    weight: FontWeight.w500,
                    hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                    size: 20,
                  ),
                ),
                SizedBox(height: 20),
                // Button Container Enviar Dados
                GestureDetector(
                  onTap: () {
                    //alexaLinkLoadingResponse(context, "Cadastrando", "", _data);
                    if (!EmailValidator.validate(_textEmailController.text)) {
                      _textEmailController.text = "";
                      infoConfigAlert(context, "Erro Email",
                          "Email informado não é valido, tente novamente.");
                    } else if (!isFourDigitNumber(_textCodeController.text)) {
                      _textCodeController.text = "";
                      infoConfigAlert(context, "Erro Código",
                          "Código de cadastro informado não é valido, tente novamente.");
                    } else {
                      FocusScope.of(context).unfocus();
                      alexaLinkLoadingResponse(
                          context, "Cadastrando", "", _data);
                      _aws.awsMsg('DynamoSendShadow/update',
                          '{"state": { "desired": {"MsgError": "", "Email": "${_textEmailController.text}", "Dispositivo": "${_aws.getDispName}", "MyKey": "${_textCodeController.text}", "Error": "0", "MsgError": ""}}}');
                      certBloc.add(const ALinkLoading());
                    }
                  },
                  child: Container(
                    height: 62,
                    width: 220,
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: _data.darkMode
                              ? Colors.white
                              : HexColor.fromHex('#FF5427'),
                        ),
                        borderRadius: BorderRadius.circular(12),
                        color: _data.darkMode
                            ? HexColor.fromHex("#0B2235")
                            : Colors.transparent),
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFont(
                            data: "Finalizar Cadastro",
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
                //
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ));
}

Widget BottonSelector(int actualPag, certBloc, _data) {
  if (actualPag == -1) {
    //Page not found on list go to last page
    actualPag = 5;
  }
  List listSelect = [
    ALinkIni(),
    ALinkTutorial1(),
    ALinkTutorial2(),
    ALinkTutorial3(),
    ALinkTutorial4(),
    ALinkTutorial5()
  ];
  int totalpags = 6;
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              if (actualPag != 0) {
                certBloc.add(listSelect[actualPag - 1]);
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 40,
              color: _data.darkMode
                  ? actualPag != 0
                      ? Colors.black
                      : Colors.transparent
                  : actualPag != 0
                      ? Colors.white
                      : Colors.transparent,
            )),
        for (int pag = 0; pag < totalpags; pag++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Icon(
              Icons.circle,
              size: 20,
              color: _data.darkMode
                  ? pag == actualPag
                      ? Colors.black
                      : Colors.grey.shade300
                  : pag == actualPag
                      ? Colors.white
                      : Colors.grey.shade800,
            ),
          ),
        IconButton(
            onPressed: () {
              if (actualPag != totalpags - 1) {
                certBloc.add(listSelect[actualPag + 1]);
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 40,
              color: _data.darkMode
                  ? actualPag != totalpags - 1
                      ? Colors.black
                      : Colors.transparent
                  : actualPag != totalpags - 1
                      ? Colors.white
                      : Colors.transparent,
            )),
      ],
    ),
  );
}

String ResponseFullString(String response) {
  if (response == "ErroEmail") {
    return "Erro, email não encontrado! Tente novamente ou pergunte para a skill qual o email cadastrado.";
  } else if (response == "ErroServidor") {
    return "Falha ao conectar com o servidor, por favor tente novamente mais tarde.";
  } else if (response == "ErroCodigo") {
    return "Erro, email ou códido de cadastro não encontrado! Tente novamente ou pergunte para a skill.";
  } else if (response == "CadastroConcluido") {
    return "Cadastro concluído com sucesso!";
  } else if (response == "ErroEmail") {
    return "";
  } else
    return "Erro ao cadastrar tente novamente.";
}
