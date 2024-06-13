import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/bloc/aws_bloc_files/aws_bloc.dart';
import 'package:apptempesp32/bloc/blue_bloc_files/blue_bloc.dart';
import 'package:apptempesp32/bloc/dynamoDB_bloc_files/dynamo_bloc.dart';
import 'package:apptempesp32/pages/alarm_page.dart';
import 'package:apptempesp32/pages/config/alexa_link.dart';
import 'package:apptempesp32/pages/config/cert_page.dart';
import 'package:apptempesp32/pages/config/configs.dart';
import 'package:apptempesp32/pages/home_page.dart';
import 'package:apptempesp32/pages/init_banner.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/motor_page.dart';
import 'package:apptempesp32/pages/recipe_pages/more_recipe.dart';
import 'package:apptempesp32/pages/recipe_pages/one_recipe_page.dart';
import 'package:apptempesp32/pages/recipe_pages/home_recipe_page.dart';
import 'package:apptempesp32/pages/temperature_page.dart';
import 'package:apptempesp32/theme_data.dart';
import 'package:apptempesp32/widget/widget_alarm_creat.dart';
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
    return MultiBlocProvider(
        providers: [
          BlocProvider<BlueBloc>(
            create: (BuildContext context) => BlueBloc(),
          ),
          BlocProvider<AwsBloc>(
            create: (BuildContext context) => AwsBloc(),
          ),
          BlocProvider<DynamoBloc>(
            create: (BuildContext context) => DynamoBloc(),
          ),
        ], // Call AppBloc() to pick inicial state
        /*
                theme: ThemeData(
                  brightness: Brightness.light,
                  /* light theme settings */
                ),
                darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  /* dark theme settings */
                ),
                themeMode: ThemeMode.dark,

          */

        child: MaterialApp(
          debugShowCheckedModeBanner: false, //Remove debug banner
          theme: myLightThemeData(), // standard dark theme
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
  final PageIndex _pageController = PageIndex();
  void attPageState(int index) {
    //fun to update current body Page
    setState(() {
      _index = index;
    });
  }

  @override
  void initState() {
    final AllData _data = AllData();
    _data.loadFavoriteIdList();
    _data.loadDarkMode().then((_) {
      Future.delayed(Duration(seconds: 3)).then((_) {
        _pageController.setIndex = 0;
      });
    });
    _index = PageIndex(attPageState: attPageState)
        .getIndex; //Passing fun to PageIndex and obtain inicial index
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return /*BlocListener<AppBloc, AppState>(listener: (context, state){if (state.blueIsOn){context.read<AppBloc>().add(const BlueIsOn());}}, child:*/ [
      //List of Pages
      const HomePage(),
      const TemperaturePage(),
      //const MotorPage2(),
      const AlarmPage(),
      const MotorPage(),
      const RecipeHomePag(),
      const OneRecipePag(),
      const MoreRecipePag(),
      const PagConfig(),
      const BannerInit(),
      const PagAlexaLink(),
    ][_index];
  }
}
