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

              return BodyStart(
                children: [
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 90.0),
                        child: blueToggle(status: blueState.screenMsg),
                      ), // Blue Status Indicator
                      // ALL the Pag
                      Container(
                        width: double.infinity,
                        margin:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //
                            const SizedBox(height: 30),
                            // Title Alexa Link
                            Center(
                              child: TextYanKaf(
                                data: "Alexa Link",
                                height: 0.87,
                                weight: FontWeight.w700,
                                hexColor:
                                    _data.darkMode ? "#0B2235" : "#FFFFFF",
                                size: 35,
                              ),
                            ),
                            //
                            const SizedBox(height: 30),
                            // Passo 1 Title
                            TextYanKaf(
                              data: "Necessário",
                              height: 0.87,
                              weight: FontWeight.w700,
                              hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                              size: 25,
                            ),
                            const SizedBox(height: 10),
                            // Conexão Internet Container
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: _data.darkMode
                                      ? HexColor.fromHex('#F8F8F8')
                                      : Colors.black45,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left Row - Title and Info
                                  Row(
                                    children: [
                                      TextYanKaf(
                                        data: "Conexão Internet",
                                        weight: FontWeight.w500,
                                        hexColor: _data.darkMode
                                            ? "#0B2235"
                                            : "#FFFFFF",
                                        size: 20,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            infoConfigAlert(
                                                context,
                                                "Conexão Internet",
                                                "Para se comunicar com a churrasqueira sem usar Bluetooth, é necessária uma conexão com a internet. \n\nAlém disso, é preciso vincular o aplicativo ao equipamento antes da primeira utilização.");
                                          },
                                          icon: Icon(
                                            Icons.info,
                                            color: _data.darkMode
                                                ? Colors.black
                                                : Colors.white70,
                                          ))
                                    ],
                                  ),
                                  // Rigth Row - Retry and Status
                                  Row(
                                    children: [
                                      _aws.getAwsHasNet
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      context.read<AwsBloc>().add(
                                                          const CheckConnect());
                                                    },
                                                    icon: Icon(
                                                      Icons.replay,
                                                      color: _data.darkMode
                                                          ? Colors.black
                                                          : Colors.white70,
                                                    )),
                                                Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                )
                                              ],
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // End Wifi Container
                            const SizedBox(height: 10),
                            // Check App Vinculado
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              height: 50,
                              decoration: BoxDecoration(
                                  color: _data.darkMode
                                      ? HexColor.fromHex('#F8F8F8')
                                      : Colors.black45,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Left Row - Title and Info
                                  Row(
                                    children: [
                                      TextYanKaf(
                                        data: "Vincular Churrasqueira",
                                        weight: FontWeight.w500,
                                        hexColor: _data.darkMode
                                            ? "#0B2235"
                                            : "#FFFFFF",
                                        size: 20,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            infoConfigAlert(
                                                context,
                                                "Vincular Churrasqueira",
                                                "Para conectar com sua churrasqueira sem usar Bluetooth, é necessário vincular seu celular ao dispositivo.");
                                          },
                                          icon: Icon(
                                            Icons.info,
                                            color: _data.darkMode
                                                ? Colors.black
                                                : Colors.white70,
                                          ))
                                    ],
                                  ),
                                  // Rigth Row - Retry and Status
                                  Row(
                                    children: [
                                      _aws.getAwsHasCert
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.green,
                                            )
                                          : Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      context.read<AwsBloc>().add(
                                                          const CheckFiles());
                                                      infoConfigAlert(
                                                          context,
                                                          "Vincular Churrasqueira",
                                                          "Na página anterior complete o passo 2.");
                                                    },
                                                    icon: Icon(
                                                      Icons.replay,
                                                      color: _data.darkMode
                                                          ? Colors.black
                                                          : Colors.white70,
                                                    )),
                                                Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                )
                                              ],
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // End Check App Vinculado
                            const SizedBox(height: 30),
                            // Passo 1 Title
                            TextYanKaf(
                              data: "Passo 1",
                              height: 0.87,
                              weight: FontWeight.w700,
                              hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                              size: 25,
                            ),
                            //
                            const SizedBox(height: 10),
                            // Explanation
                            TextYanKaf(
                              data: " Abra seu aplicativo Alexa, baixe a skill Monzio Churrasco, Realize a vinculação de conta pelo aplicativa Alexa. Por voz acione a skill falando: Abrir meu chhurras, apos a resposta pergunte qual a chave de cadastro. Com a chave preencha os campos abaixo",
                              weight: FontWeight.w500,
                              hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                              size: 20,
                            ),
                            //
                            const SizedBox(height: 10),
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
                                child: TextFormField(
                                  style: TextStyle(
                                    color: _data.darkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  controller: _textEmailController,
                                  decoration: InputDecoration(
                                      hintText: "Email da Alexa",
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
                                child: TextFormField(
                                  style: TextStyle(
                                    color: _data.darkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  controller: _textCodeController,
                                  decoration: InputDecoration(
                                      hintText: "Codigo de Cadastro",
                                      hintStyle: TextStyle(
                                        color: _data.darkMode
                                            ? Colors.black38
                                            : Colors.white38,
                                      )),
                                )),
                            TextButton(
                                onPressed: () {
                                  infoConfigAlert(
                                      context, "Conexão Internet", "");
                                  _aws.awsMsg('DynamoSendShadow/update',
                                      '{"state": { "desired": {"MsgError": "", "Email": "${_textEmailController.text}", "Dispositivo": "${_aws.getDispName}", "MyKey": "${_textCodeController.text}", "Error": "0", "MsgError": ""}}}');
                                  context
                                      .read<CertBloc>()
                                      .add(const ALinkLoading());
                                },
                                child: Text(
                                  "TESTE",
                                  style: TextStyle(
                                    color: _data.darkMode
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                )),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "Mensagem: ${_aws.getAlexaLinkResponse}",
                              style: TextStyle(
                                color: _data.darkMode
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
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
