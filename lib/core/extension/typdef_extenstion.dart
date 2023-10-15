extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }
}

extension EmailAuth on String {
  String addEmailSuffix(String email) {
    final atIndex = email.indexOf('@');
    return '${email.substring(0, atIndex)}'
        '_emailauth${email.substring(atIndex)}';
  }
}
