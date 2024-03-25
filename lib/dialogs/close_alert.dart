import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

onBackPressed(context) async {
  final pageController = PageIndex();
  
  bool logic = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Tem certeza?'),
      content: const Text('Deseja fechar o aplicativo?'),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Não", style: TextStyle(fontSize: 15),)),
        const SizedBox(height: 16),
        TextButton(
            onPressed: () => SystemNavigator.pop(),
            child: const Text("Sim", style: TextStyle(fontSize: 15),)),
      ],
    ),
  );
  //if (logic) {
  //  pageController.setIndex = 1;
  //}
}
