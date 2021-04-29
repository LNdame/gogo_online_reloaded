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

  /*static void initScreenUtil(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(374, 812), allowFontScaling: false);
  }*/
}