import 'dart:io';

import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'generated/l10n.dart';
import 'route_generator.dart';
import 'src/helpers/custom_trace.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'src/repository/user_repository.dart' as userRepo;
import 'src/helpers/app_config.dart' as config;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GlobalConfiguration().loadFromAsset("configurations");
  print(CustomTrace(StackTrace.current, message: "base_url: ${GlobalConfiguration().getString('base_url')}"));
  print(CustomTrace(StackTrace.current, message: "api_base_url: ${GlobalConfiguration().getString('api_base_url')}"));
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GogoOnlineInitializer(),
    );
  }

}


class GogoOnlineInitializer extends StatefulWidget{
  @override
  _GogoOnlineInitializerState createState() => _GogoOnlineInitializerState();
}

class _GogoOnlineInitializerState extends State<GogoOnlineInitializer> {

  @override
  void initState() {
    settingRepo.initSettings();
    settingRepo.getCurrentLocation();
    userRepo.getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ValueListenableBuilder(
        valueListenable: settingRepo.setting,
        builder: (context, Setting _setting, _) {
          return ScreenUtilInit(
            designSize: Size(360, 690),

            builder: ()=> MaterialApp(
                navigatorKey: settingRepo.navigatorKey,
                title: _setting.appName,
                initialRoute: '/Splash',
                onGenerateRoute: RouteGenerator.generateRoute,
                debugShowCheckedModeBanner: false,
                locale: _setting.mobileLanguage.value,
                localizationsDelegates: [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                theme: _setting.brightness.value == Brightness.light
                    ? ThemeData(
                  fontFamily: 'ProductSans',
                  primaryColor: Colors.white,
                  floatingActionButtonTheme: FloatingActionButtonThemeData(elevation: 0, foregroundColor: Colors.white),
                  brightness: Brightness.light,
                  accentColor: config.Colors().mainColor(1),
                  dividerColor: config.Colors().accentColor(0.1),
                  focusColor: config.Colors().accentColor(1),
                  hintColor: config.Colors().secondColor(1),
                  textTheme: TextTheme(
                    headline5: TextStyle(fontSize: 22.0, color: config.Colors().secondColor(1), height: 1.3),
                    headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().secondColor(1), height: 1.3),
                    headline3: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondColor(1), height: 1.3),
                    headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1), height: 1.4),
                    headline1: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondColor(1), height: 1.4),
                    subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondColor(1), height: 1.3),
                    headline6: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainColor(1), height: 1.3),
                    bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1), height: 1.2),
                    bodyText1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondColor(1), height: 1.3),
                    caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().accentColor(1), height: 1.2),
                  ),
                )
                    : ThemeData(
                  fontFamily: 'ProductSans',
                  primaryColor: Color(0xFF252525),
                  brightness: Brightness.dark,
                  scaffoldBackgroundColor: Color(0xFF2C2C2C),
                  accentColor: config.Colors().mainDarkColor(1),
                  dividerColor: config.Colors().accentColor(0.1),
                  hintColor: config.Colors().secondDarkColor(1),
                  focusColor: config.Colors().accentDarkColor(1),
                  textTheme: TextTheme(
                    headline5: TextStyle(fontSize: 22.0, color: config.Colors().secondDarkColor(1), height: 1.3),
                    headline4: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1), height: 1.3),
                    headline3: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700, color: config.Colors().secondDarkColor(1), height: 1.3),
                    headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1), height: 1.4),
                    headline1: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(1), height: 1.4),
                    subtitle1: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500, color: config.Colors().secondDarkColor(1), height: 1.3),
                    headline6: TextStyle(fontSize: 17.0, fontWeight: FontWeight.w700, color: config.Colors().mainDarkColor(1), height: 1.3),
                    bodyText2: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1), height: 1.2),
                    bodyText1: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400, color: config.Colors().secondDarkColor(1), height: 1.3),
                    caption: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300, color: config.Colors().secondDarkColor(0.6), height: 1.2),
                  ),
                )
               ),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,  this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SharedPreferencesDemo extends StatefulWidget {
  SharedPreferencesDemo({Key key}) : super(key: key);

  @override
  SharedPreferencesDemoState createState() => SharedPreferencesDemoState();
}

class SharedPreferencesDemoState extends State<SharedPreferencesDemo> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<int> _counter;

  Future<void> _incrementCounter() async {
    final SharedPreferences prefs = await _prefs;
    final int counter = (prefs.getInt('counter') ?? 0) + 1;

    setState(() {
      _counter = prefs.setInt("counter", counter).then((bool success) {
        return counter;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _counter = _prefs.then((SharedPreferences prefs) {
      return (prefs.getInt('counter') ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SharedPreferences Demo"),
      ),
      body: Center(
          child: FutureBuilder<int>(
              future: _counter,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text(
                        'Button tapped ${snapshot.data} time${snapshot.data == 1 ? '' : 's'}.\n\n'
                            'This should persist across restarts.',
                      );
                    }
                }
              })),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}



