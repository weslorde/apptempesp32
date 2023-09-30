import 'package:flutter/material.dart';

class PagMonitorar extends StatelessWidget {
  final String pagText;

  const PagMonitorar({super.key, required this.pagText});
  

  @override
  Widget build(BuildContext context) {
    return Center(
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          Text(pagText),
        ],
      ),
    );
  }
}