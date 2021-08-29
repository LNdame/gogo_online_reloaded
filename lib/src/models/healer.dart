import '../models/media.dart';

class Healer {
  String id;
  String firebaseId;
  String name;
  Media image;
  String rate;
  String address;
  String description;
  String practiceNumber;
  String mobile;
  String information;
 // double deliveryFee;
  double adminCommission;
  double defaultTax;
  String latitude;
  String longitude;
  String language;
  bool closed;
 // bool availableForDelivery;
 // double deliveryRange;
  double distance;
  double hourlyPrice;

  Healer();

  Healer.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      firebaseId = jsonMap['firebase_id'] != null ? jsonMap['firebase_id'] : '';
      name = jsonMap['name'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      rate = jsonMap['rate'] ?? '0';
    //  deliveryFee = jsonMap['delivery_fee'] != null ? jsonMap['delivery_fee'].toDouble() : 0.0;
      adminCommission = jsonMap['admin_commission'] != null ? jsonMap['admin_commission'].toDouble() : 0.0;
     // deliveryRange = jsonMap['delivery_range'] != null ? jsonMap['delivery_range'].toDouble() : 0.0;
      address = jsonMap['address'];
      description = jsonMap['description'];
      practiceNumber = jsonMap['phone'];
      mobile = jsonMap['mobile'];
      defaultTax = jsonMap['default_tax'] != null ? jsonMap['default_tax'].toDouble() : 0.0;
      information = jsonMap['information'];
      latitude = jsonMap['latitude'];
      longitude = jsonMap['longitude'];
      language = jsonMap['language'] != null ? jsonMap['language'] : '';
      closed = jsonMap['closed'] ?? false;
     // availableForDelivery = jsonMap['available_for_delivery'] ?? false;
      distance = jsonMap['distance'] != null ? double.parse(jsonMap['distance'].toString()) : 0.0;
    } catch (e) {
      id = '';
      firebaseId = '';
      name = '';
      image = new Media();
      rate = '0';
     // deliveryFee = 0.0;
      adminCommission = 0.0;
     // deliveryRange = 0.0;
      address = '';
      description = '';
      practiceNumber = '';
      mobile = '';
      defaultTax = 0.0;
      information = '';
      latitude = '0';
      longitude = '0';
      language = '';
      closed = false;
     // availableForDelivery = false;
      distance = 0.0;
      print(e);
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["firebase_id"] = firebaseId;
    map["name"] = name;
    if(image!=null){
      map["image"]= image?.toMap();
    }
    map["description"] = description;
    map["address"] = address;
    map["latitude"] = latitude;
    map["longitude"] = longitude;
    map["phone"] = practiceNumber;
    map["mobile"] = mobile;
    map["language"] = language;
    map["admin_commission"] = adminCommission;
    map["default_tax"] = defaultTax;
    map["closed"] = closed;
    map["information"] = information;


    return map;
   /* return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      //'delivery_fee': deliveryFee,
      'distance': distance,
    };*/
  }
}
