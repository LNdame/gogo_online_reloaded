import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat_user.g.dart';

@JsonSerializable()
class ChatUser {
  final String id;
  //TODO add a uuid
  final String username; 
  String email; 
  String imageUrl;
  String role;
  String about;
  DateTime aboutChangeDate;

  ChatUser({
    @required this.id,
    @required this.username, 
    this.email,   
    this.imageUrl,
    this.role,
    this.about,
    this.aboutChangeDate,
  });

  factory ChatUser.fromJson(Map<String, dynamic> data) {
    return _$ChatUserFromJson(data);
  }

  static Map<String, dynamic> toJson(ChatUser person) {
    return _$ChatUserToJson(person);
  }
}
