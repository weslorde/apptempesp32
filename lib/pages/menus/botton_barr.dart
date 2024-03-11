import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBar();
}

class _BottomBar extends State<BottomBar> {
  final PageIndex pageIndex = PageIndex(); //Simple Pag Controller
  final AllData _data = AllData();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20, top: 10),
      child: Container(
        child: BottomNavigationBar(
          backgroundColor:
              _data.darkMode ? Colors.white : HexColor.fromHex('#101010'),
          unselectedItemColor: _data.darkMode ? Colors.black : Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          elevation: 0.0,
          items: listNavigation(),
          currentIndex: pageIndex.getNavBotIndex,
          onTap: pageIndex.onTap,
          selectedItemColor: pageIndex.getIndex > 4
              ? _data.darkMode
                  ? Colors.black
                  : Colors.white
              : HexColor.fromHex("#FF5427"),
        ),
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