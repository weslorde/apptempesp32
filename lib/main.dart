import 'package:apptempesp32/pages/menus/list_pages.dart';
import 'package:apptempesp32/pages/pag_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  // Lock orientation to Portrait only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp())); //then call All the app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //Remove debug banner
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SelectedPage(),
    );
  }
}

class SelectedPage extends StatefulWidget {
  const SelectedPage({super.key});

  @override
  State<SelectedPage> createState() => _SelectedPageState();
}

class _SelectedPageState extends State<SelectedPage> {
  late int _index;
  void attPageState(int index) {
    //fun to update current body Page
    setState(() {
      _index = index;
    });
  }

  @override
  void initState() {
    _index = PageIndex(attPageState: attPageState)
        .getIndex; //Passing fun to PageIndex and obtain inicial index
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return [  //List of Pages
      const PagGeneric(
        pagText: "Page 1",
      ),
      const PagGeneric(
        pagText: "Page 2",
      ),
      const PagGeneric(
        pagText: "Page 3",
      )
    ][_index];
  }
}


