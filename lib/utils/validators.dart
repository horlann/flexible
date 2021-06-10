String? phoneNumberValidator(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{3,10}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

String? emailValidator(String value) {
  String pattern =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  RegExp regExp = new RegExp(pattern);
  if (!regExp.hasMatch(value)) {
    return 'Please enter valid email';
  }
  return null;
}

String? nameValidator(String value) {
  String pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
  RegExp regExp = new RegExp(pattern);
  if (regExp.hasMatch(value)) {
    return 'Please enter valid name';
  }
  return null;
}
