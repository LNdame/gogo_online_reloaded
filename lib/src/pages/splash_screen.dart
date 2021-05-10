import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../../generated/l10n.dart';
import '../repository/user_repository.dart' as userRepo;



import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() {
    _con.progress.addListener(() {
      double progress = 0;
      _con.progress.value.values.forEach((_progress) {
        progress += _progress;
      });
      if (progress <=100) {
        try {
          userRepo.currentUser.value.apiToken != null || userRepo.currentUser.value.role.name == AppConstants.ROLE_CLIENT ?
         Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2): Navigator.of(context).pushNamed('/HealerPages', arguments: 2);
         // Navigator.of(context).pushReplacementNamed('/Onboarding');
        } catch (e) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: AppConstants.customBackground,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/logo.png',
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



/*Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/img/logo.png',
                width: 150,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 50),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              ),
            ],
          ),
        ),
      ),*/

/*Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(child: Container(
            child: OnboardingScreen(),
          )
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 26.0),
            child: Column(
              children: [
                Container(
                  width: _size.width,
                  height: AppConstants.buttonHeight,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    color: AppConstants.primaryColor,
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/SignUp');
                    },
                    child: Text(
                      S.of(context).get_started.toUpperCase(),
                      style: TextStyle(
                        color: AppConstants.whiteColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  width: _size.width,
                  height: AppConstants.buttonHeight,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                      side: BorderSide(
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    color: AppConstants.whiteColor,
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/Login');
                    },
                    child: Text(
                      S.of(context).login.toUpperCase(),
                      style: TextStyle(
                        color: AppConstants.primaryColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                )
              ],
            ),
          )
        ],
      )*/