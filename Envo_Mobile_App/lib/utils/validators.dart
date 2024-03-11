import 'package:email_validator/email_validator.dart';

bool isEmail(String input) => EmailValidator.validate(input);

bool isPhone(String input) =>
    RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
        .hasMatch(input);

String? validatePhone(String? val) {
  if (isPhone(val!)) {
    return null;
  } else {
    return "Please enter a valid contact number";
  }
}

String? validatePassword(String? value) {
  if (value!.isEmpty) {
    return "Please enter password";
    // } else if (!EmailValidator.validate(value.trim())) {
    //   return "Please enter valid Email Id";
  }
  //  else if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)')
  //     .hasMatch(value.trim())) {
  //   return "Please enter valid password:\n\u2022 Password must be 8 or more characters in length.\n\u2022Password must contain 1 or more uppercase characters.\n\u2022 Password must contain 1 or more digit characters.\n\u2022Password must contain 1 or more special characters.";
  // }

  else {
    return null;
  }
}

String? validateConfirmPassword(String? value, String compareValue) {
  if (value!.isEmpty) {
    return "Please enter password";
    // } else if (!EmailValidator.validate(value.trim())) {
    //   return "Please enter valid Email Id";
  } else if (!RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)')
      .hasMatch(value.trim())) {
    return "Please enter valid password:\n\u2022 Password must be 8 or more characters in length.\n\u2022Password must contain 1 or more uppercase characters.\n\u2022 Password must contain 1 or more digit characters.\n\u2022Password must contain 1 or more special characters.";
  } else if (value.trim() != compareValue) {
    return "Passwords do not Match";
  } else
    return null;
}

String? validateEmail(String? value) {
  if (value!.isEmpty) {
    return "Please enter Email";
  }
  if (!isEmail(value)) {
    return "Please enter a valid Email";
  }
}
