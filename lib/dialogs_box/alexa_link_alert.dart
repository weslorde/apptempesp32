import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc.dart';
import 'package:apptempesp32/bloc/certficado_bloc_files/cert_bloc_events.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

alexaLinkBox(context) async {
  showDialog(
      //barrierDismissible: false, TODO REATIVAR QUANDO TERMINAR
      context: context,
      builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<CertBloc>(
                  create: (BuildContext context) => CertBloc(),
                )
              ],
              child: Builder(builder: (context) {
                final certState = context.watch<CertBloc>().state;

                return GestureDetector(
                  onTap: () {
                    //Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 300),
                    child: Container(
                      color: Colors.amber.shade50,
                      child: Column(
                        children: [
                          Text("Texto"),
                          Text(certState.msg),
                          SizedBox(height: 20),
                          TextButton(
                              onPressed: () {
                                context
                                    .read<CertBloc>()
                                    .add(const InitAlexaLink());
                              },
                              child: Text("AQUI"))
                        ],
                      ),
                    ),
                  ),
                );
              })));
}
