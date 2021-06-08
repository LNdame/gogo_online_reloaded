import 'package:flutter/material.dart';
import 'package:gogo_online/src/models/chat_user.dart';
import 'package:gogo_online/src/pages/messaging/widget/avatar.dart';


class ChatContactWidget extends StatelessWidget {
  final ChatUser chatPeer;

  const ChatContactWidget({Key key, @required this.chatPeer}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      margin: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 5)),
        ],
      ),
      child: Row(
        children: [
          Avatar(imageUrl: chatPeer.imageUrl,  radius: kToolbarHeight / 2 - 5),
          SizedBox(width: 8),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(chatPeer.username, style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis,),
            ],
          ))
        ],
      ),
    );
  }
}
