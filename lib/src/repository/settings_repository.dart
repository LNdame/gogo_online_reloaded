import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_trace.dart';
import '../helpers/maps_util.dart';
import '../models/address.dart';
import '../models/coupon.dart';
import '../models/setting.dart';

ValueNotifier<Setting> setting = new ValueNotifier(new Setting());
ValueNotifier<Address> billingAddress = new ValueNotifier(new Address());
Coupon coupon = new Coupon.fromJSON({});
final navigatorKey = GlobalKey<NavigatorState>();
//LocationData locationData;

Future<Setting> initSettings() async {
  Setting _setting;
  final String url = '${GlobalConfiguration().getString('api_base_url')}settings';
  Uri uri = Uri.parse(url);
  try {

    Map<String, String> data = {
      "app_name": "Gogo Online",
      "enable_stripe": "1",
      "default_tax": "10",
      "default_currency": "R",
      "enable_paypal": "1",
      "main_color": "#37474f",
      "main_dark_color": "#312a3d",
      "second_color": "#62727b",
      "second_dark_color": "#ccccdd",
      "accent_color": "#ffc107",
      "accent_dark_color": "#c79100",
      "scaffold_dark_color": "#2c2c2c",
      "scaffold_color": "#37474f",
      "google_maps_key": "AIzaSyAT07iMlfZ9bJt1gmGj9KhJDLFY8srI6dA",
      "mobile_language": "en",
      "app_version": "1.3.0",
      "enable_version": "1",
      "default_currency_decimal_digits": "2",
      "currency_right": "0"
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('settings', json.encode(data));
    _setting = Setting.fromJSON(data);
    if (prefs.containsKey('language')) {
      _setting.mobileLanguage.value = Locale(prefs.get('language'), '');
    }
    _setting.brightness.value = prefs.getBool('isDark') ?? false ? Brightness.dark : Brightness.light;
    setting.value = _setting;
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    setting.notifyListeners();

  } catch (e) {
    print(CustomTrace(StackTrace.current, message: url).toString());
    return Setting.fromJSON({});
  }
  return setting.value;
}

Future<dynamic> setCurrentLocation() async {
  var location = new Location();
  MapsUtil mapsUtil = new MapsUtil();
  final whenDone = new Completer();
  Address _address = new Address();
  location.requestService().then((value) async {
    location.getLocation().then((_locationData) async {
      String _addressName = await mapsUtil.getAddressName(new LatLng(_locationData?.latitude, _locationData?.longitude), setting.value.googleMapsKey);
      _address = Address.fromJSON({'address': _addressName, 'latitude': _locationData?.latitude, 'longitude': _locationData?.longitude});
      await changeCurrentLocation(_address);
      whenDone.complete(_address);
    }).timeout(Duration(seconds: 10), onTimeout: () async {
      await changeCurrentLocation(_address);
      whenDone.complete(_address);
      return null;
    }).catchError((e) {
      whenDone.complete(_address);
    });
  });
  return whenDone.future;
}

Future<Address> changeCurrentLocation(Address _address) async {
  if (!_address.isUnknown()) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('delivery_address', json.encode(_address.toMap()));
  }
  return _address;
}

Future<Address> getCurrentLocation() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //await prefs.clear();
  if (prefs.containsKey('delivery_address')) {
    billingAddress.value = Address.fromJSON(json.decode(prefs.getString('delivery_address')));
    return billingAddress.value;
  } else {
    billingAddress.value = Address.fromJSON({});
    return Address.fromJSON({});
  }
}

void setBrightness(Brightness brightness) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (brightness == Brightness.dark) {
    prefs.setBool("isDark", true);
    brightness = Brightness.dark;
  } else {
    prefs.setBool("isDark", false);
    brightness = Brightness.light;
  }
}

Future<void> setDefaultLanguage(String language) async {
  if (language != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}

Future<String> getDefaultLanguage(String defaultLanguage) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('language')) {
    defaultLanguage = await prefs.get('language');
  }
  return defaultLanguage;
}

Future<void> saveMessageId(String messageId) async {
  if (messageId != null) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('google.message_id', messageId);
  }
}

Future<String> getMessageId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.get('google.message_id');
}
