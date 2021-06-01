import 'package:flutter/material.dart';
import 'package:gogo_online/generated/l10n.dart';
import 'package:gogo_online/src/controllers/notification_controller.dart';
import 'package:gogo_online/src/elements/EmptyChatsWidget.dart';
import 'package:gogo_online/src/elements/NotificationItemWidget.dart';
import 'package:gogo_online/src/elements/PermissionDeniedWidget.dart';
import 'package:gogo_online/src/elements/WaitingRoomButtonWidget.dart';
import 'package:gogo_online/src/repository/user_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';



class ActiveChatWidget extends StatefulWidget {

  final GlobalKey<ScaffoldState> parentScaffoldKey;

  const ActiveChatWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ActiveChatWidgetState createState() => _ActiveChatWidgetState();
}

class _ActiveChatWidgetState extends StateMVC<ActiveChatWidget> {
  NotificationController _con;

  _ActiveChatWidgetState() : super(NotificationController()) {
    _con = controller;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Theme.of(context).hintColor),
          onPressed: () => widget.parentScaffoldKey.currentState.openDrawer(),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Chats",
          style: Theme.of(context).textTheme.headline6.merge(TextStyle(letterSpacing: 1.3)),
        ),
        actions: <Widget>[
          new WaitingRoomButtonWidget(iconColor: Theme.of(context).hintColor, labelColor: Theme.of(context).accentColor),
        ],
      ),
      body: currentUser.value.apiToken == null
          ? PermissionDeniedWidget()
          : RefreshIndicator(
        onRefresh: _con.refreshNotifications,
        child: _con.notifications.isEmpty
            ? EmptyChatsWidget()
            : SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                  leading: Icon(
                    Icons.notifications,
                    color: Theme.of(context).hintColor,
                  ),
                  title: Text(
                   "Chats",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
              ListView.separated(
                padding: EdgeInsets.symmetric(vertical: 15),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                itemCount: _con.notifications.length,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 15);
                },
                itemBuilder: (context, index) {
                  return NotificationItemWidget(notification: _con.notifications.elementAt(index));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
