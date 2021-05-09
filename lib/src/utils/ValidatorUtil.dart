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
}
