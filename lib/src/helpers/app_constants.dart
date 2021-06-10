import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../generated/l10n.dart';

class AppConstants {


  static const primaryColor = Color.fromRGBO(21, 77, 222, 1);
  static const primaryColorLight = Color.fromRGBO(21, 77, 222, 0.1);
  static const whiteColor = Color.fromRGBO(255, 255, 255, 1);
  static const blackColor = Color.fromRGBO(0, 0, 0, 1);
  static const deepBlue = Color.fromRGBO(53, 54, 79, 1);
  static const quietBlack = Color(0xFF3B3E58);
  static const inactiveColor = Color.fromRGBO(53, 54, 79, 0.3);
  static const lightBlackSub = Color.fromRGBO(53, 54, 79, 0.62);
  static const dangerColor = Color(0xFFE85050);
  static const customBackground = Color(0xFF37474F);
  static const deepYellow = Color(0xFFFFc107);
  static double normalFontSize = 20.0;
  static double normalFontSize2x = 21.0;
  static double smallFontSize2x = 17.0;
  static double smallFontSize3x = 18.0;
  static double smallFontSize4x = 19.0;
  static double smallFontSize = 16.0;
  static double miniFontSize = 13.0;
  static double microFontSize = 12.0;
  static double miniFontSize2x = 14.0;
  static double miniFontSize3x = 15.0;
  static double bigFontTitle = 28.0;
  static Color darkSubtitle = Color(0xFFb0b3b8);
  static double buttonHeight = ScreenUtil().setHeight(48.0);
  static FontWeight boldFont = FontWeight.bold;

  //Roles
  static const String ROLE_CLIENT = "client";
  static const String ROLE_MANAGER = "manager";

  //Provinces coordinates
  static const String EASTERN_CAPE_LAT_LON = "-32.2968, 26.4194";
  static const String FREE_STATE_LAT_LON = "-28.4541, 26.7968";
  static const String GAUTENG_LAT_LON = "-26.2708, 28.1123";
  static const String KWAZULU_NATAL_LAT_LON = "-28.5306, 30.8958";
  static const String LIMPOPO_LAT_LON = "-23.4013, 29.4179";
  static const String MPUMALANGA_LAT_LON = "-25.5653, 30.5279";
  static const String NORTHERN_CAPE_LAT_LON = "-29.0467, 21.8569";
  static const String NORTH_WEST_LAT_LON = "-26.6639, 25.2838";
  static const String WESTERN_CAPE_LAT_LON = "-33.2278, 21.8569";

  //Provinces
  static const String EASTERN_CAPE = "Eastern Cape";
  static const String FREE_STATE= "Free State";
  static const String GAUTENG= "Gauteng";
  static const String KWAZULU_NATAL = "Kwazulu Natal";
  static const String LIMPOPO= "Limpopo";
  static const String MPUMALANGA = "Mpumalanga";
  static const String NORTHERN_CAPE = "Northern Cape";
  static const String NORTH_WEST = "North West";
  static const String WESTERN_CAPE = "Western Cape";


/*ScreenUtil.init(constraints)

  static double font24 = ScreenUtil().setSp(24.0, allowFontScalingSelf: true);
  static double font22 = ScreenUtil().setSp(22.0, allowFontScalingSelf: true);
  static double font20 = ScreenUtil().setSp(20.0, allowFontScalingSelf: true);
  static double font19 = ScreenUtil().setSp(19.0, allowFontScalingSelf: true);
  static double font18 = ScreenUtil().setSp(18.0, allowFontScalingSelf: true);
  static double font17 = ScreenUtil().setSp(17.0, allowFontScalingSelf: true);
  static double font16 = ScreenUtil().setSp(16.0, allowFontScalingSelf: true);
  static double font15 = ScreenUtil().setSp(15.0, allowFontScalingSelf: true);
  static double font14 = ScreenUtil().setSp(14.0, allowFontScalingSelf: true);
  static double font13 = ScreenUtil().setSp(13.0, allowFontScalingSelf: true);
  static double font12 = ScreenUtil().setSp(12.0, allowFontScalingSelf: true);
  static double font10 = ScreenUtil().setSp(10.0, allowFontScalingSelf: true);*/

  static List<String> yearMonths = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  static List<String> getYearMonths(S intlDelegate) {
    return [
      intlDelegate.january,
      intlDelegate.february,
      intlDelegate.march,
      intlDelegate.april,
      intlDelegate.may,
      intlDelegate.june,
      intlDelegate.july,
      intlDelegate.august,
      intlDelegate.september,
      intlDelegate.october,
      intlDelegate.november,
      intlDelegate.december,
    ];
  }

  static List<String> getWeekDays(S intlDelegate) {
    return [
      intlDelegate.sunday,
      intlDelegate.monday,
      intlDelegate.tuesday,
      intlDelegate.wednesday,
      intlDelegate.thursday,
      intlDelegate.friday,
      intlDelegate.saturday,
    ];
  }

  static Color greyColor = Color.fromRGBO(2, 19, 51, 1);
  static Color greenColor = Color.fromRGBO(131, 208, 71, 1);
  static Color darkBackground = Color.fromRGBO(21, 33, 43, 1);

   static const String ALL_MESSAGES_COLLECTION = 'MESSAGES';
   static const String USERS_COLLECTION = 'USERS';
   static const String CHATS_COLLECTION = 'CHATS';
   static const String MEDIA_COLLECTION = 'MEDIA';

  static const String CHATS_MEDIA_STORAGE_REF = 'ChatsMedia';

}

enum MediaType {
  Photo,
  Video,
}

enum MessageType {
  Text,
  Media,
}