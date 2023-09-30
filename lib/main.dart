import 'package:apptempesp32/pages/menus/botton_barr.dart';
import 'package:apptempesp32/pages/menus/list_pages.dart';
import 'package:apptempesp32/pages/menus/top_barr.dart';
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    return Scaffold(
      //Top Menu
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: TopBar(),
      ),

      //Bottom Menu
      // ignore: prefer_const_constructors
      bottomNavigationBar: BottomBar(),

      //Body (all pags)
      body: PagSelector(
        index: _index,
      ),
    );
  }
}
