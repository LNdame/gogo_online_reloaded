import 'dart:math';

import 'package:global_configuration/global_configuration.dart';

class Media {
  String id;
  String name;
  String url;
  String thumb;
  String icon;
  String size;

  Media() {
    var random= Random();
    int min = 1;
    int max = 5;
    int node = min + random.nextInt(max - min);

    url = "${GlobalConfiguration().getString('base_url')}images/female_avatar_$node.jpg";
    thumb = "${GlobalConfiguration().getString('base_url')}images/female_avatar_$node.jpg";
    icon = "${GlobalConfiguration().getString('base_url')}images/female_avatar_$node.jpg";
  }

  Media.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      url = jsonMap['url'];
      thumb = jsonMap['thumb'];
      icon = jsonMap['icon'];
      size = jsonMap['formated_size'];
    } catch (e) {
      url = "${GlobalConfiguration().getString('base_url')}images/male_avatar_1.jpg";
      thumb = "${GlobalConfiguration().getString('base_url')}images/male_avatar_1.jpg";
      icon = "${GlobalConfiguration().getString('base_url')}images/male_avatar_1.jpg";
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["url"] = url;
    map["thumb"] = thumb;
    map["icon"] = icon;
    map["formated_size"] = size;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }
}
