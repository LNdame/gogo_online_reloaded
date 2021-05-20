import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/models/message.dart';


class ReplyMessagePreview extends StatelessWidget {
  const ReplyMessagePreview({
    Key key,
    @required this.repliedMessage,
    @required this.userId,
    @required this.reply,
    @required this.peerName,
    @required this.onCanceled,
  }) : super(key: key);

  final Message repliedMessage;
  final String userId;  
  final String peerName;
  final bool reply;
  final Function onCanceled;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: _Leading(
                repliedMessage: repliedMessage,
                userId: userId,
                peerName: peerName),
          ),
          Flexible(
            child: _Trailing(repliedMessage: repliedMessage, onCanceled: onCanceled),
          ),
        ],
      ),
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({
    Key key,
    @required this.repliedMessage,
    @required this.onCanceled,
  }) : super(key: key);

  final Message repliedMessage;
  final Function onCanceled;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: repliedMessage.type == MessageType.Text ? 54 : 130,
      ),
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (repliedMessage.type == MessageType.Media)
            Container(
              width: 40,
              height: 50,
              child: CachedNetworkImage(
                imageUrl: repliedMessage.mediaUrl,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox(width: 10),
          CupertinoButton(
            padding: const EdgeInsets.only(
              left: 0,
              top: 0,
              bottom: 0,
              right: 10,
            ),
            onPressed: onCanceled,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppConstants.lightBlackSub,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.close, color: Colors.white, size: 17),
            ),
          ),
        ],
      ),
    );
  }
}

class _Leading extends StatelessWidget {
  const _Leading({
    Key key,
    @required this.repliedMessage,
    @required this.userId,
    @required this.peerName,
  }) : super(key: key);

  final Message repliedMessage;
  final String userId;
  final String peerName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: RichText(
            text: TextSpan(
              text: 'Replying to ',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
                // fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: repliedMessage.fromId == userId ? 'yourself' : peerName,
                  style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        Flexible(
          child:
              SizedBox(height: repliedMessage.type == MessageType.Text ? 5 : 0),
        ),
        Flexible(
          child: repliedMessage.type == MessageType.Text
              ? Text(
                  repliedMessage?.content,
                  style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  overflow: TextOverflow.ellipsis,
                )
              : Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      SizedBox(width: 5),
                      Text('Photo')
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
