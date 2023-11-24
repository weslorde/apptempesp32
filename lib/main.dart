import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/monitorar_page1.dart';
import 'package:apptempesp32/pages/pag_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider<BlueBloc>(
        //BlocProvider above MaterialApp for all pages using the same bloc instance
        create: (BuildContext context) =>
            BlueBloc(), // Call AppBloc() to pick inicial state
        child: MaterialApp(
          debugShowCheckedModeBanner: false, //Remove debug banner
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const SelectedPage(),
        ));
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
    return /*BlocListener<AppBloc, AppState>(listener: (context, state){if (state.blueIsOn){context.read<AppBloc>().add(const BlueIsOn());}}, child:*/ [
      //List of Pages
      const MonitorarPag(),
      const PagGeneric(
        pagText: "Page 2",
      ),
      const PagGeneric(
        pagText: "Page 3",
      )
    ][_index];
  }
}
