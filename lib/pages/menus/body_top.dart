import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:flutter/material.dart';

class BodyStart extends StatelessWidget {
  BodyStart({super.key, required this.children});
  final List<Widget> children;
  final AllData _data = AllData();

  Widget build(BuildContext context) {
    return Container(
      color: _data.darkMode ?  HexColor.fromHex("#fafaff") : HexColor.fromHex("#101010"),
      //Screen background body of page "light gray" same of TopBar()
      child: Container(
        decoration: BoxDecoration(
          //color: Colors.white,
          color: _data.darkMode ? Colors.white : HexColor.fromHex('#131313'),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: HexColor.fromHex("#E9E9FF"), //Same Dark and Light
                borderRadius: const BorderRadius.all(Radius.circular(28)),
              ),
            ),
            ...children
          ],
        ),
      ),
    );
  }
}
