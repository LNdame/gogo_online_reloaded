import 'package:flutter/material.dart';
import 'package:gogo_online/src/controllers/onboarding_controller.dart';
import 'package:gogo_online/src/elements/BlockButtonWidget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../helpers/app_constants.dart';
import '../widgets/onboarding_screen_widget.dart';
import '../../generated/l10n.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends StateMVC<OnBoardingPage> {

  OnBoardingController _con;

  _OnBoardingPageState() : super(OnBoardingController()) {
    _con = controller;
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppConstants.customBackground,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Container(
              child: OnboardingScreenWidget(),
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 26.0),
              child: Column(
                children: [
                  Container(
                    width: _size.width,
                    height: AppConstants.buttonHeight,
                    child: BlockButtonWidget(
                      text: Text(
                        S.of(context).get_started.toUpperCase(),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/SignUp');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Container(
                    width: _size.width,
                    height: AppConstants.buttonHeight,
                    child: BlockButtonWidget(
                      text: Text(
                        S.of(context).login.toUpperCase(),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      color: Theme.of(context).focusColor,
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/Login');
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
