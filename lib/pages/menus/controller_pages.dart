import 'package:flutter/material.dart';

//Icons list of Botton Menu
List<BottomNavigationBarItem> listNavigation() {
  return const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.speed),
      label: 'Temperatura',
    ),
    /*BottomNavigationBarItem(
      icon: Icon(Icons.local_fire_department_outlined),
      label: 'Churrasco',
    ),*/
    BottomNavigationBarItem(
      icon: Icon(Icons.timer_sharp),
      label: 'Alarme',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.swap_vert_rounded),
      label: 'Posição',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.newspaper),
      label: 'Receitas',
    ),
  ];
}

//Simple Page controller
class PageIndex {
  int _currentIndex = 8; //Actual page index
  Function(int) _attPageState = (int _) {}; //Fun to updateState

  // Creat Singleton
  static final PageIndex _shared = PageIndex._sharedInstance();
  PageIndex._sharedInstance();
  factory PageIndex({Function(int)? attPageState}) {
    if (attPageState != null) {
      // Optional Function parameter
      _shared._attPageState =
          attPageState; // If Function is not null pass to a local variable
    }
    return _shared; // return Singleton
  }

  set setIndex(int index) {

    if (_currentIndex != index) {
      _currentIndex = index;
      _attPageState(_currentIndex); // Call Fun to updateState
    }
  }

  int get getIndex => _currentIndex;
  int get getNavBotIndex {
    if (_currentIndex > 4) {
      return 0;
    } else {
      return _currentIndex;
    }
  }

  void onTap(int index) {
    // Function used in NavigationBar => onDestinationSelected parameters
    setIndex = index;
  }

  //End class PageIndex
}
