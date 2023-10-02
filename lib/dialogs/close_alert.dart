import 'package:flutter/material.dart';

Future<bool> onBackPressed(context) async {
  return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tem certeza?'),
          content: const Text('Deseja fechar o aplicativo?'),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: <Widget>[
            GestureDetector(
              onTap: () => Navigator.of(context).pop(false),
              child: const Text(
                "Não",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(true),
              child: const Text(
                "Sim",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ) ??
      false;
}