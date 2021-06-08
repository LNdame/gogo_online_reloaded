import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/models/chat_user.dart';
import 'package:gogo_online/src/models/user.dart';
import 'package:gogo_online/src/pages/messaging/widget/avatar.dart';
import 'package:gogo_online/src/repository/user_repository.dart';
import 'package:permission_handler/permission_handler.dart';

import '../call_page.dart';


class ChatAppBar extends StatefulWidget {
  final ChatUser peer;
  final String groupId;
  ChatAppBar(this.peer, this.groupId);
  @override
  _ChatAppBarState createState() => _ChatAppBarState();
}

class _ChatAppBarState extends State<ChatAppBar>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  Animation _animation;

  Timer _timer;
  bool collapsed = false;
  var stream;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    // steram of peer details
    stream = Firestore.instance
        .collection(AppConstants.USERS_COLLECTION)
        .document(widget.peer.id)
        .snapshots();

    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);

    _timer = Timer(Duration(seconds: 3), () {
      collapse();
    });
  }

  @override
  void dispose() {
    _animationController.removeListener(() {});
    _animationController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void collapse() {
    _animationController.forward();
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      if (this.mounted) setState(() => collapsed = true);
    });
  }

  //TODO go to healer page or patient profile
  /*void goToContactDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ContactDetails(contact: widget.peer, groupId: widget.groupId),
      ),
    );
  }*/

  bool tapped = false;
  void toggle() {
    setState(() {
      tapped = !tapped;
    });
  }

  Future<void> onJoinMeeting() async {
    //TODO: try using the groupID instead if same across
    var meetingID = currentUser.value.role.name == AppConstants.ROLE_CLIENT
        ? currentUser.value.firebaseUid
        : widget.peer.id;

    await _handleCameraAndMic(Permission.camera);
    await _handleCameraAndMic(Permission.microphone);

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(channelName: meetingID),
        ));
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppConstants.deepYellow,
      // centerTitle: true,
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back),
        color: Theme.of(context).hintColor,
      ),
      title: CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: (){},//goToContactDetails,
        child: Row(
          children: [
            Avatar(imageUrl: widget.peer.imageUrl, radius: kToolbarHeight / 2 - 5),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.peer.username, style: Theme.of(context).textTheme.bodyText1, overflow: TextOverflow.ellipsis,),
                  if (collapsed)
                    StreamBuilder(
                        stream: stream,
                        builder: (ctx, snapshot) {
                          if (!snapshot.hasData)
                            return Container(width: 0, height: 0);
                          else {
                            return AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: 13, //snapshot.data['isOnline'] ? 13 : 0,
                              child: Text(
                                'Online',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                              ),
                            );
                            // return Container();
                          }
                        }),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.easeIn,
                    height: collapsed ? 0 : 13,
                    child: FadeTransition(
                      opacity: _animation,
                      child: Text(
                        'tap for more info',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20, top: 5, bottom: 5),
          child: Wrap(
            children: [
              CupertinoButton(
                onPressed: (){}, // TODO re-enable when doing feature/Video-Call makeVoiceCall,
                padding: const EdgeInsets.all(0),
                child: Icon(Icons.call, color: Theme.of(context).accentColor),
                // Avatar(imageUrl: widget.peer.imageUrl, radius: 23, color: kBlackColor3),
              ),
              CupertinoButton(
                onPressed:onJoinMeeting, // TODO re-enable when doing feature/Video-Call makeVoiceCall,
                padding: const EdgeInsets.all(0),
                child: Icon(Icons.video_call,
                    color: Theme.of(context).accentColor),
                // Avatar(imageUrl: widget.peer.imageUrl, radius: 23, color: kBlackColor3),
              ),
            ],
          ),
        ),
      ],
    );
  }


  /* TODO re-enable when doing feature/Video-Call
  void makeVoiceCall() {
    OverlayUtils.overlay(
      context: context,
      alignment: Alignment.topCenter,
      child: CallingScreen(reciever: widget.peer),
      duration: Duration(seconds: 5),
    );
  }

  void makeVideoCall() {
    OverlayUtils.overlay(
      context: context,
      alignment: Alignment.topCenter,
      child: CallingScreen(reciever: widget.peer),
      duration: Duration(seconds: 5),
    );
  }*/
}
