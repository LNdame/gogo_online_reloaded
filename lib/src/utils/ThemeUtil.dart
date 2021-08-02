import 'package:flutter/material.dart';
import 'package:gogo_online/src/helpers/app_constants.dart';


class ThemeUtil{
  static Color getCardColor(Brightness brightness) {
    return brightness == Brightness.light
        ? Colors.white
        : Color.fromRGBO(25, 40, 52, 1);
  }

  static Color getTextColor(Brightness brightness) {
    return brightness == Brightness.dark
        ? Colors.white
        : AppConstants.darkBackground;
  }

  static Color lightDarkColor(
      Color lightColor, Color darkColor, Brightness brightness) {
    return brightness == Brightness.dark ? darkColor : lightColor;
  }

  static Map themeToMap() {
    var themeMap = new Map<String, String>();
    themeMap["app_name"] = "Gogo Online";
    themeMap["enable_stripe"] = "1";
    themeMap["default_tax"] = "15";
    themeMap["default_currency"] = "R";
    themeMap["enable_paypal"] = "1";
    themeMap["main_color"] = "#37474f";
    themeMap["main_dark_color"] = "#312a3d";
    themeMap["second_color"] = "#62727b";
    themeMap["second_dark_color"] = "#ccccdd";
    themeMap["accent_color"] = "#ffc107";
    themeMap["accent_dark_color"] = "#c79100";
    themeMap["scaffold_dark_color"] = "#2c2c2c";
    themeMap["scaffold_color"] = "#37474f";
    themeMap["google_maps_key"] = "AIzaSyAT07iMlfZ9bJt1gmGj9KhJDLFY8srI6dA";
    themeMap["mobile_language"] = "en";
    themeMap["app_version"] = "1.3.0";
    themeMap["enable_version"] = "1";
    themeMap["default_currency_decimal_digits"] = "2";
    themeMap["currency_right"] = "0";

    return themeMap;
  }
}