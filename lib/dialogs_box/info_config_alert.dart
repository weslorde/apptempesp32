import 'package:apptempesp32/api/aws_api.dart';
import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc_events.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

alexaLinkLoadingResponse(
    context, String topTitle, String infoText, _data) async {
  _data.setAlexaLinkPopLoad = true; // Define que AlertDialog abriu
  Future.delayed(const Duration(seconds: 6), () {
    if (_data.getAlexaLinkPopLoad) {
      // Se ainda tiver aberto fecha
      _data.setAlexaLinkPopLoad = false;
      Navigator.of(context).pop();
    }
  });
  showDialog(
    context: context,
    builder: (context) => PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {},
        child: AlertDialog(
          title: Center(child: Text(topTitle)),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: 60, width: 60, child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    ),
  );
}

dispNameCreate(context, String dispID, attFun) async {
  final AllData _data = AllData();
  final TextEditingController _textNameController = TextEditingController();
  showDialog(
    context: context,
    builder: (context) => GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: AlertDialog(
        title: Text("Dispositivo $dispID"),
        content: TextFormField(
          style: TextStyle(
            color: _data.darkMode ? Colors.black : Colors.white,
          ),
          controller: _textNameController,
          decoration: InputDecoration(
              hintText: "Novo Apelido",
              hintStyle: TextStyle(
                color: _data.darkMode ? Colors.black38 : Colors.white38,
              )),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              _data.setListDispNames(dispID, _textNameController.text);
              attFun();
              Navigator.of(context).pop();
            },
            child: Text("Salvar"),
          ),
        ],
        /*Column(
          children: [
            Text(infoText),
            
            Row(
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text("Sim"),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("Nao"),
                ),
              ],
            )
          ],*/
      ),
    ),
  );
}

confirmDispChange(context, title, text, attFun) async {
  final AllData _data = AllData();
  showDialog(
    context: context,
    builder: (context) => GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: AlertDialog(
        title: Text(title),
        content: Text(text),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              attFun();
              Navigator.of(context).pop();
            },
            child: Text("Sim"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Não"),
          ),
        ],
      ),
    ),
  );
}

