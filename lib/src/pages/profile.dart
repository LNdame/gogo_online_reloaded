import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gogo_online/src/models/user.dart';
import 'package:gogo_online/src/repository/services/db.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/profile_controller.dart';
import '../elements/DrawerWidget.dart';
import '../elements/EmptyConsultationsWidget.dart';
import '../elements/ConsultationItemWidget.dart';
import '../elements/PermissionDeniedWidget.dart';
import '../elements/ProfileAvatarWidget.dart';
import '../elements/WaitingRoomButtonWidget.dart';
import '../repository/user_repository.dart';

class ProfileWidget extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldKey;

  ProfileWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends StateMVC<ProfileWidget> {
  ProfileController _con;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  _ProfileWidgetState() : super(ProfileController()) {
    _con = controller;
  }

  Future<bool> addUserToFirebase(User currentUser, String password) async{
    try{
      final db = DB();
      //AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword();
       //   email: currentUser.email, password: password);
      //FirebaseUser user = result.user;

      db.addNewUser(currentUser.id, currentUser.image.thumb, currentUser.name, currentUser.email);
      UserUpdateInfo info = UserUpdateInfo();
      info.displayName = currentUser.name;
      //user.updateProfile(info);

    }catch(error) {
      print(error);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      drawer: DrawerWidget(),
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).primaryColor),
          onPressed: () => _con.scaffoldKey?.currentState?.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          S.of(context).profile,
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3, color: Theme.of(context).primaryColor)),
        ),
        actions: <Widget>[
          new WaitingRoomButtonWidget(iconColor: Theme.of(context).primaryColor, labelColor: Theme.of(context).hintColor),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : SingleChildScrollView(
//              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                children: <Widget>[
                  ProfileAvatarWidget(user: currentUser.value),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(
                      Icons.person,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text(
                      S.of(context).about,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      currentUser.value?.bio ?? "",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextButton(
                        onPressed: (){
                          addUserToFirebase(currentUser.value, "123456");
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat,
                              color: Theme.of(context).primaryColor,
                              size: 24,
                            ),
                            SizedBox(width: 16,),
                            Text("Add to firebase", style: TextStyle(color: Theme.of(context).primaryColor,),)
                          ],
                        ) ,
                        style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context).accentColor.withOpacity(0.9),
                          shape: StadiumBorder(),
                        )
                    )
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    leading: Icon(
                      Icons.calendar_today,
                      color: Theme.of(context).hintColor,
                    ),
                    title: Text("Recent Consultations",
                     // S.of(context).recent_orders,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  _con.recentConsultations.isEmpty
                      ? EmptyConsultationsWidget()
                      : ListView.separated(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: _con.recentConsultations.length,
                          itemBuilder: (context, index) {
                            var _order = _con.recentConsultations.elementAt(index);
                            return ConsultationItemWidget(expanded: index == 0 ? true : false, consultation: _order);
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 20);
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
