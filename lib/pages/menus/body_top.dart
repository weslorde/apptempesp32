import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:flutter/material.dart';

class BodyStart extends StatelessWidget {
  BodyStart({super.key, required this.children});
  final List<Widget> children;

  Widget build(BuildContext context) {
    return Container(
      color: HexColor.fromHex("#fafaff"),
      //Screen background body of page "light gray" same of TopBar()
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 16),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: HexColor.fromHex("#E9E9FF"),
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
