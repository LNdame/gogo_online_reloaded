import 'package:gogo_online/src/helpers/app_constants.dart';
import 'package:gogo_online/src/models/reply_message.dart';
import 'package:json_annotation/json_annotation.dart';



/// This allows the `User` class to access private members in
/// the generated file. The value for this is *.g.dart, where
/// the star denotes the source file name.
part 'message.g.dart';

@JsonSerializable(explicitToJson: true)
class Message {
  String content;
  String fromId;
  String toId;
  String timeStamp;
  DateTime sendDate;
  bool isSeen;
  MessageType type;
  MediaType mediaType;
  String mediaUrl;
  bool uploadFinished;
  ReplyMessage reply;


  Message({
    this.content,
    this.fromId,
    this.toId,
    this.timeStamp,
    this.sendDate,
    this.isSeen,
    this.type,
    this.mediaType,
    this.mediaUrl,
    this.uploadFinished, 
    this.reply,
  });

  factory Message.fromMap(Map<String, dynamic> data) {          
    return _$MessageFromJson(data);  
  }

  static Map<String, dynamic> toMap(Message message) {
    return _$MessageToJson(message);  
  }
}
