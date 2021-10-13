
class ValidatorUtil {
  static String phoneValidator(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter a phone number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  static String genericEmptyValidator(String value, String message) {
    if (value.isEmpty) {
      return message;
    }
    return null;
  }

  static String convertDateToZeroFormat(int dateItem){
    if(dateItem<10){
      return "0$dateItem";
    }
    else{
      return "$dateItem";
    }
  }

  static bool isNowPastTheDate(String date, String time){
    String dateTime= "$date $time:00";
    try {
      var parsedDate = DateTime.parse(dateTime);
      var now = new DateTime.now();
      return parsedDate.isBefore(now);
    }on TypeError catch (ce){
      print("$ce");
      return false;
    } catch (e){
      print("$e");
      return false;
    }


  }
}
