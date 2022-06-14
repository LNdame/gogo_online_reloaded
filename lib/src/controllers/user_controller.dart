//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gogo_online/src/repository/services/db.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../helpers/helper.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool loading = false;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;

  //FirebaseMessaging _firebaseMessaging;
  FirebaseAuth _firebaseAuth;

  OverlayEntry loader;

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseAuth = FirebaseAuth.instance;
    // _firebaseMessaging = FirebaseMessaging();
    /* _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
    }).catchError((e) {
      print('Notification not configured');
    });*/
  }

//TODO look at the update if that is not a better way
  void login() async {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.login(user).then((value) {
        if (value != null && value.apiToken != null) {
          if (value.role.name == "manager") {
            Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/HealerPages', arguments: 2);
          } else {
            Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
          }
          firebaseSilentLogin(user.email, user.password);
        } else {
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text(S.of(state.context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_account_not_exist),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void register() async {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          registerOnFirebase(value, user.password);
          Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
        } else {
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text(S.of(state.context).wrong_email_or_password),
          ));
        }
      }).catchError((e) {
        loader.remove();
        ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
          content: Text(S.of(state.context).this_email_account_exists),
        ));
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void registerFirebaseFirst() async {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      await registerFirstOnFirebase(user, user.password).then((authResult) {
        user.firebaseUid = authResult.user.uid;
        repository.register(user).then((value) {
          if (value != null && value.apiToken != null) {
            try {
              final db = DB();
              db.addNewUser(authResult.user.uid, value.image.thumb, user.name, user.email);
              UserUpdateInfo info = UserUpdateInfo();
              info.displayName = user.name;
              authResult.user.updateProfile(info);
              repository.currentUser.value.firebaseUid = authResult.user.uid;
              repository.setCurrentUserFireBaseUid(authResult.user.uid);

            } catch (error) {
              print(error);
            }
          }
        }).whenComplete(() {
          Helper.hideLoader(loader);
          Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Pages', arguments: 2);
        } );
      });
    }
  }

  void resetPassword() {
    loader = Helper.overlayLoader(state.context);
    FocusScope.of(state.context).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(state.context).insert(loader);
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text(S.of(state.context).your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.of(state.context).login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext).pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          loader.remove();
          ScaffoldMessenger.of(scaffoldKey?.currentContext).showSnackBar(SnackBar(
            content: Text(S.of(state.context).error_verify_email_settings),
          ));
        }
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void registerOnFirebase(User user, String password) {
    _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: password).then((value) {
      try {
        final db = DB();
        db.addNewUser(value.user.uid, user.image.thumb, user.name, user.email);
        UserUpdateInfo info = UserUpdateInfo();
        info.displayName = user.name;
        value.user.updateProfile(info);
        repository.currentUser.value.firebaseUid = value.user.uid;
        repository.setCurrentUserFireBaseUid(value.user.uid);
      } catch (error) {
        print(error);
      }
    });
  }

  Future<AuthResult> registerFirstOnFirebase(User user, String password){
    return _firebaseAuth.createUserWithEmailAndPassword(email: user.email, password: password);
  }

  void firebaseSilentLogin(email, password) {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((value) {
      repository.currentUser.value.firebaseUid = value.user.uid;
      repository.setCurrentUserFireBaseUid(value.user.uid);
    });
  }
}
