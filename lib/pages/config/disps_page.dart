import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc_events.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc_events.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc_events.dart';
import 'package:apptempesp32/dialogs_box/info_config_alert.dart';
import 'package:apptempesp32/pages/menus/body_top.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';

class PagDisp extends StatelessWidget {
  const PagDisp({super.key});

  @override
  Widget build(BuildContext context) {
    final BlueController blue = BlueController();
    final AwsController aws = AwsController();
    final AllData _data = AllData();
    final PageIndex _pageController = PageIndex();

    return PopScope(
      canPop: false,
      onPopInvoked: (_) => {_pageController.setIndex = 0},
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

              if (certState.stateActual == "empty") {
                aws.dispsRegistered(() {
                  context.read<CertBloc>().add(const ALinkIni());
                });
              }

              return BodyStart(children: [
                const SizedBox(width: 20),
                certState.stateActual != "empty"
                    ?
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
                            // Title Config
                            Center(
                              child: TextYanKaf(
                                data: "Dispositivos",
                                height: 0.87,
                                weight: FontWeight.w700,
                                hexColor:
                                    _data.darkMode ? "#0B2235" : "#FFFFFF",
                                size: 35,
                              ),
                            ),
                            //
                            SizedBox(height: 30),
                            //
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextYanKaf(
                                data: "Selecionado",
                                height: 0.87,
                                weight: FontWeight.w500,
                                hexColor:
                                    _data.darkMode ? "#0B2235" : "#FFFFFF",
                                size: 25,
                              ),
                            ),
                            //
                            const SizedBox(height: 5),
                            // Selected
                            if (aws.getListDispsPath.length <=
                                _data.getFileIdDispActual) // NovoDisp Selected
                              widgetNewDisp(_data)
                            else
                              widgetOneDisp(
                                  _data,
                                  aws.getListDispsPath[
                                      _data.getFileIdDispActual],
                                  context),
                            //
                            SizedBox(height: 20),
                            //
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextYanKaf(
                                data: "Outros",
                                height: 0.87,
                                weight: FontWeight.w500,
                                hexColor:
                                    _data.darkMode ? "#0B2235" : "#FFFFFF",
                                size: 25,
                              ),
                            ),
                            //
                            const SizedBox(height: 5),
                            //
                            for (List<String> disp in aws.getListDispsPath)
                              if (disp.isNotEmpty)
                                if (disp[0] !=
                                    _data.getFileIdDispActual
                                        .toString()) //Ignore Disp in Selecionado
                                  GestureDetector(
                                    onTap: () {
                                      _data.setFileIdDispActual =
                                          int.parse(disp[0]);
                                      context
                                          .read<CertBloc>()
                                          .add(const ALinkIni());
                                    },
                                    child: widgetOneDisp(_data, disp, context),
                                  ),

                            SizedBox(height: 20),
                            if (aws.getListDispsPath.length >
                                _data.getFileIdDispActual) // NovoDisp Selected
                              GestureDetector(
                                onTap: () {
                                  //print("Size: ${aws.getListDispsPath.length}");
                                  _data.setFileIdDispActual = aws
                                      .getListDispsPath
                                      .length; //New disp recive last id of the list of disps
                                  //print("DispAtual: ${_data.getFileIdDispActual}");
                                  context
                                      .read<CertBloc>()
                                      .add(const ALinkIni());
                                },
                                child: widgetNewDisp(_data),
                              ),
                          ],
                        ),
                      )
                    // end Pag
                    : Container(
                        child: const SizedBox(
                        height: 20,
                        width: 20,
                      )),
                // Fim teste
                TextButton(
                    onPressed: () {
                      SystemNavigator.pop(); // RESET APP
                      //_data.getRestartAppTree();
                    },
                    child: Text("RESET"))
              ]);
            },
          ),
        ),
      ),
    );
  }
}

Widget MyPrint(disp, _data) {
  print("1: ${disp[0]} 2: ${_data.getFileIdDispActual}");
  return SizedBox();
}

Widget widgetOneDisp(_data, dispNum, context) {
  print(dispNum.length);
  return Column(
    children: [
      const SizedBox(height: 10),
      // Conexão Internet Container
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
            color:
                _data.darkMode ? HexColor.fromHex('#F8F8F8') : Colors.black45,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Row - Title and Info
            Row(
              children: [
                TextYanKaf(
                  data: _data.getMyDispNames(dispNum[1]),
                  //data: "Churrasqueira ${dispNum[1]}",
                  weight: FontWeight.w500,
                  hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                  size: 20,
                ),
                IconButton(
                    onPressed: () {
                      dispNameCreate(context, dispNum[1], () {});
                    },
                    icon: Icon(
                      Icons.edit,
                      color: _data.darkMode ? Colors.black : Colors.white70,
                    ))
              ],
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(size: 30, Icons.delete_forever, color: Colors.red)),
          ],
        ),
      ),
    ],
  );
}

Widget widgetNewDisp(_data) {
  return Column(
    children: [
      const SizedBox(height: 10),
      // Conexão Internet Container
      Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 50,
        decoration: BoxDecoration(
            color:
                _data.darkMode ? HexColor.fromHex('#F8F8F8') : Colors.black45,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Row - Title and Info
            Row(
              children: [
                TextYanKaf(
                  data: "Adicionar novo dispositivo",
                  weight: FontWeight.w500,
                  hexColor: _data.darkMode ? "#0B2235" : "#FFFFFF",
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

List<Widget> widgetWifiForm(contextBloc, BlueController blue, AllData data) {
  final loginWifiController = TextEditingController();
  final passwordWifiController = TextEditingController();

  return [
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          TextField(
            controller: loginWifiController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Rede Wifi',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: passwordWifiController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Senha Wifi',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                print(
                    "${loginWifiController.text} - ${passwordWifiController.text}");
                data.setWifiLogin = loginWifiController.text;
                data.setWifiPassword = passwordWifiController.text;
                blue.mandaMensagem("Wifi");
              },
              child: Text('Enviar'))
        ],
      ),
    )
  ];
}
