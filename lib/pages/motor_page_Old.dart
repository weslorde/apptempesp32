import 'package:apptempesp32/api/aws_dynamodb_api.dart';
import 'package:apptempesp32/api/blue_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_state.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc_events.dart';
import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
import 'package:apptempesp32/widget/widget_blue_toggle.dart';
import 'package:apptempesp32/widget/widget_text_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MotorPage2 extends StatelessWidget {
  const MotorPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final AllData _data = AllData();
    final BlueController _blue = BlueController();
    final AwsDynamoDB _dynamo = AwsDynamoDB();
    return Scaffold(
      appBar: const TopBar(),
      // ignore: prefer_const_constructors
      bottomNavigationBar: BottomBar(),
      body: BlocBuilder<BlueBloc, BlueState>(
        builder: ((context, state) {
          String texto = '';
          if (state.msg == null) {
            texto = 'error state do BlocBuild == null';
          } else {
            texto = state.msg;
          }

          return (Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                blueToggle(status: state.stateActual),
                Text(texto),
                const SizedBox(height: 100),
                Listener(
                  onPointerDown: (PointerEvent ignore) {
                    context.read<BlueBloc>().add(const BlueIsSup());
                    //_blue.mandaMensagem("Temp");
                  },
                  onPointerUp: (PointerEvent ignore) {
                    //_blue.mandaMensagem("Motor,Up,Release");
                    print(_dynamo.getRecipeData);
                  },
                  child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.upload,
                        size: 150,
                      )),
                ),
                const SizedBox(height: 20),
                Listener(
                  onPointerDown: (PointerEvent ignore) {
                    print(_data.getAlarmGraus);
                    print(_data.getAlarmeTimer);
                    _blue.mandaMensagem("Alarme");
                  },
                  onPointerUp: (PointerEvent ignore) {
                    //_dynamo.getAllData();
                    //_blue.mandaMensagem("Motor,Down,Release");
                  },
                  child: IconButton(
                      onPressed: () {},
                      icon: const RotatedBox(
                        quarterTurns: 90,
                        child: Icon(
                          Icons.upload,
                          size: 150,
                        ),
                      )),
                ),
              ],
            ),
          ));
        }),
      ),
    );
  }
}

Widget blueIndicator(String status, BlueController blue) {
  Map<String, dynamic> statusToColor = {
    'Conectado': "#FF5427",
    'Conectar': "#FF8D27",
    'Desconectado': "#BBC8D6"
  };
  return Container(
    alignment: Alignment.centerRight,
    child: FittedBox(
      child: GestureDetector(
        onTap: () {
          blue.setBlueIsOn = !blue.getToggleBool;
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: HexColor.fromHex(statusToColor[status]),
              borderRadius: BorderRadius.horizontal(left: Radius.circular(6))),
          child: Row(
            children: [
              Icon(
                Icons.bluetooth,
                size: 20,
                color: Colors.white,
              ),
              blue.getToggleBool == true
                  ? TextFont(
                      data: status,
                      weight: FontWeight.w700,
                      hexColor: "#FFFFFF",
                      size: 11.7,
                      height: 14.2 / 11.7,
                      gFont: GoogleFonts.inter)
                  : SizedBox(),
            ],
          ),
        ),
      ),
    ),
  );
}
