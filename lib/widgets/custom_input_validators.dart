class CustomInputValidators {
  static String? validateEmpty(dynamic value) {
    if (value == null) {
      return 'Required';
    } else if (value is String && value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  static String? validateString(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Required';
    }
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return !emailValid ? "Enter valid email" : null;
  }

  String? validatePassword(String? value) {
    // if (value == null || value.isEmpty) {
    //   return 'Required';
    // } else if (value.length >= 8) {
    //   bool result = advanceValidatePassword(value);
    //   if (result) {
    //     return null;
    //   } else {
    //     return "Must have capital, small letter, No & Special";
    //   }
    // } else if (value.length < 8) {
    //   return 'Password must be atleast 8 characters';
    // }
    if (value == null || value.isEmpty) {
      return 'Required';
    } else if (value.length < 8) {
      return 'Password must be atleast 8 characters';
    }
    return null;
  }

  bool advanceValidatePassword(String pass) {
    RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)");
    if (passValid.hasMatch(pass.trim())) {
      return true;
    } else {
      return false;
    }
  }
}
