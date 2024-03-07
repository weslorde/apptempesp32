import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  final PageIndex pageIndex = PageIndex(); //Simple Pag Controller
  final AllData _data = AllData();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: BottomNavigationBar(
        items: listNavigation(),
        currentIndex: pageIndex.getNavBotIndex,
        onTap: pageIndex.onTap,
        selectedItemColor: pageIndex.getIndex > 5 ? _data.darkMode ? Colors.black : Colors.white : HexColor.fromHex("#FF5427"),
      ),
    );
  }
}


/*

NavigationBar(
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      selectedIndex: pageIndex.getIndex, // Get actual index
      onDestinationSelected: pageIndex.onDestinationSelected, //Fun to change de index
      destinations: listNavigation(), //List of pages
    );

*/