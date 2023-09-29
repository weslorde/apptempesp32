import 'package:flutter/material.dart';

List<Widget> listNavigation() {
  return const [
    NavigationDestination(
      icon: Icon(Icons.data_usage),
      label: 'Monitorar',
    ),
    NavigationDestination(
      icon: Icon(Icons.alarm_on),
      label: 'Alarmes',
    ),
    NavigationDestination(
      icon: Icon(Icons.format_line_spacing),
      label: 'Controle',
    ),
  ];
}

