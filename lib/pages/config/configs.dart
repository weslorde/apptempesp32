import 'dart:io';

import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/aws_dynamodb_api.dart';
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

class PagConfig extends StatelessWidget {
  const PagConfig({super.key});

  @override
  Widget build(BuildContext context) {
    final BlueController _blue = BlueController();
    final AwsController _aws = AwsController();
    final AllData _data = AllData();
    final PageIndex _pageController = PageIndex();
    final AwsDynamoDB _dynamo = AwsDynamoDB();

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => {_pageController.setIndex = 0},
      child: Scaffold(
        backgroundColor:
            _data.darkMode ? Colors.white : HexColor.fromHex('#101010'),
        appBar: TopBar(),
        //
        //if(true){}
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

              _dynamo.getClientHasDisp(_aws.getDispName, () {
                try {
                  //prevent error when change state after go out of the pag and the bloc doesnt exist
                  context.read<CertBloc>().add(const ALinkLoading());
                } catch (_) {
                  print("error config hasDisp");
                }
              });

              if (certState.stateActual == "CertfOne") {
                return CertBlueFilesLoading(_data, 1);
              } else if (certState.stateActual == "CertfTwo") {
                return CertBlueFilesLoading(_data, 2);
              } else if (certState.stateActual == "CertfThree") {
                return CertBlueFilesLoading(_data, 3);
              } else if (certState.stateActual == "CertEnd") {
                return CertBlueFilesLoading(_data, 3);
              } else {
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
                          margin: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //
                              const SizedBox(height: 30),
                              // Title Config
                              Center(
                                child: TextYanKaf(
                                  data: "Configurações",
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
                                data: "Passo 1",
                                height: 0.87,
                                weight: FontWeight.w700,
                                hexColor:
                                    _data.darkMode ? "#0B2235" : "#FFFFFF",
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
                              //
                              const SizedBox(height: 20),
                              //
                              // Passo 2 Title
                              TextYanKaf(
                                data: "Passo 2",
                                height: 0.87,
                                weight: FontWeight.w700,
                                hexColor:
                                    _data.darkMode ? "#0B2235" : "#FFFFFF",
                                size: 25,
                              ),
                              const SizedBox(height: 10),
                              // Vincular Churrasqueira Container
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
                                                            "Complete os itens da seção: Como Vincular.");
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
                              ), // End Vincular Churrasuqeira
                              //
                              const SizedBox(height: 20),
                              //
                              // ---- Como Vincular
                              //
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextYanKaf(
                                      data: "Como Vincular",
                                      height: 0.87,
                                      weight: FontWeight.w500,
                                      hexColor: _data.darkMode
                                          ? "#0B2235"
                                          : "#FFFFFF",
                                      size: 25,
                                    ),
                                    //
                                    const SizedBox(height: 10),
                                    //
                                    // Conectar Bluetooth
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: _data.darkMode
                                              ? HexColor.fromHex('#F8F8F8')
                                              : Colors.black45,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Left Row - Title and Info
                                          Row(
                                            children: [
                                              TextYanKaf(
                                                data: "Conectar Bluetooth",
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
                                                        "Conectar Bluetooth",
                                                        "Para vincular seu celular, primeiro ligue a churrasqueira e conecte-se via Bluetooth.");
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
                                              _blue.getblueConnect
                                                  ? Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    )
                                                  : Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              context
                                                                  .read<
                                                                      BlueBloc>()
                                                                  .add(
                                                                      const BlueIsSup());
                                                              _blue.setToggleBool =
                                                                  true;
                                                            },
                                                            icon: Icon(
                                                              Icons.replay,
                                                              color: _data
                                                                      .darkMode
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white70,
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
                                    //
                                    SizedBox(height: 10),
                                    // Vincular certificados
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: _data.darkMode
                                              ? HexColor.fromHex('#F8F8F8')
                                              : Colors.black45,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Left Row - Title and Info
                                          Row(
                                            children: [
                                              TextYanKaf(
                                                data: "Vincular Agora",
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
                                                        "Vincular Agora",
                                                        "Para vincular seu celular à churrasqueira, mantenha-o próximo para garantir uma conexão Bluetooth estável durante o processo.");
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
                                                              if (_blue
                                                                  .getblueConnect) {
                                                                context
                                                                    .read<
                                                                        CertBloc>()
                                                                    .add(
                                                                        const InitCertFiles());
                                                              } else {
                                                                infoConfigAlert(
                                                                    context,
                                                                    "Erro ao Vincular Agora",
                                                                    "Necessário estar conectado por Bluetooth para fazer essa etapa.");
                                                              }
                                                            },
                                                            icon: Icon(
                                                              Icons.replay,
                                                              color: _data
                                                                      .darkMode
                                                                  ? Colors.black
                                                                  : Colors
                                                                      .white70,
                                                            )),
                                                        Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ), // End Vincular Churrasuqeira
                              //
                              const SizedBox(height: 20),
                              //
                              // Passo 3 Title
                              TextYanKaf(
                                data: "Passo 3 (Opcional)",
                                height: 0.87,
                                weight: FontWeight.w700,
                                hexColor:
                                    _data.darkMode ? "#0B2235" : "#FFFFFF",
                                size: 25,
                              ),
                              //
                              const SizedBox(height: 10),
                              //
                              // Conectar Alexa Container
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
                                          data: "Conectar com Alexa",
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
                                                  "Conectar com Alexa",
                                                  "Habilitar sua Alexa para controlar a churrasqueira por comandos de voz.");
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
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  if (!_aws.getAwsHasCert) {
                                                    infoConfigAlert(
                                                        context,
                                                        "Erro ao Vincular Agora",
                                                        "Necessário estar conectado por Bluetooth para fazer essa etapa.");
                                                  } else if (!_aws
                                                      .getMQTTConnect) {
                                                    infoConfigAlert(
                                                        context,
                                                        "Erro ao Conectar",
                                                        "Erro com a comunicação com o servidor tente novamente mais tarde.");
                                                  } else if (_data
                                                      .getDynamoUserAlexaLink) {
                                                    //If Alexa already done
                                                    confirmDispChange(
                                                        context,
                                                        "Alexa já conectada!",
                                                        "Alexa já está cadastrada com uma conta, gostaria de substituir por uma nova?",
                                                        () {
                                                      _pageController.setIndex =
                                                          9;
                                                    });
                                                  } else {
                                                    _pageController.setIndex =
                                                        9;
                                                  }
                                                },
                                                icon: Icon(
                                                  Icons.replay,
                                                  color: _data.darkMode
                                                      ? Colors.black
                                                      : Colors.white70,
                                                )),
                                            _data.getDynamoUserAlexaLink
                                                ? Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  )
                                                : certState.stateActual ==
                                                        "empty"
                                                    ? Icon(
                                                        Icons.timelapse,
                                                        color: Colors.grey,
                                                      )
                                                    : Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ), // End Vincular Churrasuqeira
                            ],
                          ),
                        ),
                        // Loading Effect
                      ],
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget CertBlueFilesLoading(_data, int passoAtual) {
  return BodyStart(
    children: [
      Container(
        width: double.infinity,
        height: 500,
        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFont(
              data: "Vinculando dispositivo",
              weight: FontWeight.w500,
              hexColor: _data.darkMode ? "#101010" : "#FFFFFF",
              size: 30,
              gFont: GoogleFonts.yanoneKaffeesatz,
            ),
            SizedBox(height: 15),
            TextFont(
              data: "Pode demorar cerca de 1 minuto",
              weight: FontWeight.w500,
              hexColor: _data.darkMode ? "#101010" : "#FFFFFF",
              size: 20,
              gFont: GoogleFonts.yanoneKaffeesatz,
            ),
            SizedBox(height: 15),
            TextFont(
              data: "Mantenha o celular proximo para manter o Bluetooth",
              weight: FontWeight.w500,
              hexColor: _data.darkMode ? "#101010" : "#FFFFFF",
              size: 20,
              gFont: GoogleFonts.yanoneKaffeesatz,
            ),
            SizedBox(height: 20),
            TextFont(
              data: "Passo $passoAtual de 3",
              weight: FontWeight.w500,
              hexColor: _data.darkMode ? "#101010" : "#FFFFFF",
              size: 25,
              gFont: GoogleFonts.yanoneKaffeesatz,
            ),
            SizedBox(height: 50),
            Container(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  color: HexColor.fromHex("FF5427"),
                  strokeWidth: 8,
                )),
          ],
        ),
      ),
    ],
  );
}
