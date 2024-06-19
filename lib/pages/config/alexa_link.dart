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
                "ALinkTutorial3"
              ];
              return BodyStart(
                children: [
                  Expanded(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (certState.stateActual == "ALinkIni")
                              AlexaTutorial0()
                            else if (certState.stateActual == "ALinkTutorial1")
                              AlexaTutorial1()
                            else if (certState.stateActual == "ALinkTutorial2")
                              AlexaTutorial2()
                            else if (certState.stateActual == "ALinkTutorial3")
                              AlexaTutorial1()
                            else
                              Container(),
                            BottonSelector(
                                listItens.indexWhere(
                                    (element) => element == certState.stateActual),
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

Widget AlexaTutorial0() {
  return Container(
    child: Text('TESTANDO0'),
  );
}

Widget AlexaTutorial1() {
  final Uri _url = Uri.parse('https://www.amazon.com.br/dp/B0D63DLP9X/');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  return Container(
      child: Column(
    children: [
      Text("TESTEEEE"),
      TextButton(onPressed: _launchUrl, child: Text("MeuLink"))
    ],
  ));
}

Widget AlexaTutorial2() {
  return Container(
    child: Text('TESTANDO1'),
  );
}

Widget AlexaTutorial3() {
  return Container(
    child: Text('TESTANDO2'),
  );
}

Widget BottonSelector(int actualPag, testeww) {
  List listSelect = [
    ALinkIni(),
    ALinkTutorial1(),
    ALinkTutorial2(),
    ALinkTutorial3()
  ];
  int npags = 4;
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
        for (int pag = 0; pag < npags; pag++)
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
              if (actualPag != 3) {
                testeww.add(listSelect[actualPag + 1]);
              }
            },
            icon: Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 40,
              color: actualPag != 3 ? Colors.black : Colors.transparent,
            )),
      ],
    ),
  );
}
