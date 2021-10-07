import 'package:flutter/material.dart';
import 'package:gogo_online/generated/l10n.dart';
import 'package:gogo_online/src/controllers/messaging_controller.dart';
import 'package:gogo_online/src/controllers/notification_controller.dart';
import 'package:gogo_online/src/elements/EmptyChatsWidget.dart';
import 'package:gogo_online/src/elements/NotificationItemWidget.dart';
import 'package:gogo_online/src/elements/PermissionDeniedWidget.dart';
import 'package:gogo_online/src/elements/WaitingRoomButtonWidget.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/models/chat_data.dart';
import 'package:gogo_online/src/pages/messaging/widget/chats_list_item.dart';
import 'package:gogo_online/src/repository/services/db.dart';
import 'package:gogo_online/src/repository/user_repository.dart';
import 'package:gogo_online/src/widgets/body_list.dart';
import 'package:mvc_pattern/mvc_pattern.dart';



class ActiveChatWidget extends StatefulWidget {

  final GlobalKey<ScaffoldState> parentScaffoldKey;

  const ActiveChatWidget({Key key, this.parentScaffoldKey}) : super(key: key);
  @override
  _ActiveChatWidgetState createState() => _ActiveChatWidgetState();
}

class _ActiveChatWidgetState extends StateMVC<ActiveChatWidget> {
  MessagingController _con;
  DB db;

  _ActiveChatWidgetState() : super(MessagingController()) {
    _con = controller;
  }


  @override
  void initState() {
    print('active chat initcalled =============');
    super.initState();
    db = DB();
    print('${currentUser.value.firebaseUid} active chat init database =============');
    _con.getUserDetailsAndContacts(currentUser.value.firebaseUid);
    print('active chat init _con.getUserDetailsAndContacts =============');
  }

  Widget _buildChats(List<ChatData> chats) => BodyList(
    child: ListView.separated(
      padding: const EdgeInsets.only(top: 10),
      itemCount: chats.length,
      itemBuilder: (ctx, i) => ChatListItem(chatData: chats[i], con: _con,),
      separatorBuilder: (ctx, i) {
        return Divider(
          indent: 85,
          endIndent: 15,
          height: 0,
          thickness: 1,
          color: AppConstants.customBackground,
        );
      },
    ),
  );


  void updateChats(BuildContext context, AsyncSnapshot<dynamic> snapshots) {
    if (snapshots != null && snapshots.data != null) {
      final currContacts = _con.getContacts;
      final currContactLength = currContacts.length;
      final contacts = snapshots.data['contacts'];
      if (contacts != null) if (contacts.length > currContactLength) {
           _con.handleMessagesNotFromContacts(contacts);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final chats = _con.chats;
    final isLoading = _con.isLoading;
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
          : StreamBuilder(
          stream: db.getUserContactsStream(currentUser.value.firebaseUid),
          builder: (ctx, snapshots){
            if (!isLoading && snapshots.hasData) updateChats(context, snapshots);
           return isLoading|| chats.isEmpty ? EmptyChatsWidget() :
                //SingleChildScrollView(
                  //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                 // child:
            Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      /*Padding(
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
                      ),*/
                     _buildChats(chats)
                    ],
                 // ),
                );

          })


    );
  }
}
