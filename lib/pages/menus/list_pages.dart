import 'package:apptempesp32/pages/pag_test.dart';
import 'package:flutter/material.dart';

//Icons list of Botton Menu
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

//Simple Page controller
class PageIndex {
  int _currentIndex = 0; //Actual page index
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

  void onDestinationSelected(int index) {
    // Function used in NavigationBar => onDestinationSelected parameters
    setIndex = index;
  }
}

// Widget to return Scaffold => Body with atual Page
class PagSelector extends StatelessWidget {
  final int index;
  const PagSelector({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return const [  //List of Pages
      PagMonitorar(
        pagText: "Page 1",
      ),
      PagMonitorar(
        pagText: "Page 2",
      ),
      PagMonitorar(
        pagText: "Page 3",
      )
    ][index];
  }
}
