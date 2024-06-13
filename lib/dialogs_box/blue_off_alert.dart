import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

blueOffAlert(context) async {
  showDialog(
    context: context,
    builder: (context) => GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: const AlertDialog(
        title: Text('Dispositivo Desconectado'),
        content: Text(
            'Para acessar as configurações é necessario conectar com a churrasqueira por bluetooth'),
      ),
    ),
  );
}
