
import 'package:apptempesp32/pages/menus/list_pages.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  final PageIndex pageIndex = PageIndex(); //Simple Pag Controller
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: pageIndex.getIndex, // Get actual index
      onDestinationSelected: pageIndex.onDestinationSelected, //Fun to change de index
      destinations: listNavigation(), //List of pages
    );
  }
}
