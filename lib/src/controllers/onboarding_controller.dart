import 'dart:async';

//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/helpers/custom_trace.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import '../repository/user_repository.dart' as userRepo;
import '../repository/settings_repository.dart' as settingRepo;

class OnBoardingController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;

  OnBoardingController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  @override
  void initState() {
    super.initState();
    try {
      userRepo.getCurrentUser().then((user) => {
            if (user.auth != null)
              {
                if (user.firebaseUid!=null && user.firebaseUid.isNotEmpty)
                  {
                    user.role.name == AppConstants.ROLE_CLIENT
                        ? settingRepo.navigatorKey.currentState.pushReplacementNamed('/Pages', arguments: 2)
                        : settingRepo.navigatorKey.currentState
                            .pushReplacementNamed('/HealerPages', arguments: 2)
                  }
              }
          });
    } on NoSuchMethodError catch(ne){
      print(CustomTrace(StackTrace.current, message: ne.toString()));
    } on Exception catch(_){
      print("error caught");
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: e));
    }
  }
}
