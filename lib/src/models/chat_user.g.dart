// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) {
  return ChatUser(
    id: json['id'] as String,
    username: json['username'] as String,
    email: json['email'] as String,
    imageUrl: json['imageUrl'] as String,
    about: json['about'] as String,
    role: json['role'] as String,
    aboutChangeDate: json['aboutChangeDate'] == null
        ? null
        : DateTime.parse(json['aboutChangeDate'] as String),
  );
}

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'email': instance.email,
      'imageUrl': instance.imageUrl,
      'about': instance.about,
      'role':instance.role,
      'aboutChangeDate': instance.aboutChangeDate?.toIso8601String(),
    };
