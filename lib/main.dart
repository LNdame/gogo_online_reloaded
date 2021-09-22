import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_crashlytics/firebase_crashlytics.dart';
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
 // FirebaseApp app = await FirebaseApp.configure(name: "Gogo_online", options: null);
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  //Crashlytics.instance.enableInDevMode = true;
// Pass all uncaught errors to Crashlytics.
 // FlutterError.onError = Crashlytics.instance.recordFlutterError;
  runApp(MyApp());
  /*runZonedGuarded(() {
    runApp(MyApp());
  }, (error, stacktrace) {
    Crashlytics.instance.recordError(error, stacktrace);
  });*/
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
    userRepo.getCurrentUser();
    settingRepo.getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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


