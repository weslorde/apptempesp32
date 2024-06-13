import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

infoConfigAlert(context, String topTitle, String infoText) async {
  showDialog(
    context: context,
    builder: (context) => GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: AlertDialog(
        title: Text(topTitle),
        content: Text(infoText),
      ),
    ),
  );
}

