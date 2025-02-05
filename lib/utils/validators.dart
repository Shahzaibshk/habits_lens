import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hoppy/models/habit_model.dart';
import 'package:hoppy/utils/enum.dart';


final goodHabit = Hive.box<HabitModel>(HiveBox.goodHabit.name);

class Validators {
  static String? emptyValidator(String? text) {
    if (text!.isEmpty) {
      return 'Please Fill in the field';
    }

    if (goodHabit.name == text) {
      return 'Habit name already exist';
    }
    return null;
  }

  static String? doubleValidator(String? text) {
    if (text!.isEmpty) {
      return 'Please Fill in the field';
    }
    try {
      double.parse(text);
      return null;
    } catch (e) {
      return 'Please enter correct value';
    }
  }

  static String? nameValidator(String? email) {
    if (email!.isEmpty) {
      return 'Please fill in the name';
    }

    if (email.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  static String? usernameValidator(String? email) {
    if (email!.isEmpty) {
      return 'Please fill in the username';
    }

    if (email.length < 6) {
      return 'Username must be at least 6 characters';
    }
    return null;
  }

  static String? emailValidator(String? email) {
    if (email!.isEmpty) {
      return 'Please Fill in the email';
    }

    const p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    final regExp = RegExp(p);

    if (!regExp.hasMatch(email.trim())) {
      return 'Please Enter Valid Email Address';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password!.isEmpty) {
      return 'Please Fill in the password';
    }

    if (password.length < 6) {
      return 'Text must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPasswordValidator(
      String? password, String? oldPassword) {
    if (password!.isEmpty) {
      return 'Please fill in the password';
    }

    if (password != oldPassword) {
      return "Passwords don't match";
    }
    return null;
  }

static String? pointsValidator(String? field, {required bool isGoodHabit}) {
  if (field == null || field.trim().isEmpty) {
    return 'Please fill in the field';
  }

  final int? points = int.tryParse(field);
  if (points == null) {
    return 'Please enter a valid number';
  }

  if (isGoodHabit) {
    // Validation for good habits: 1 to 100
    if (points < 1 || points > 100) {
      return 'Points must be between 1 and 100';
    }
  } else {
    // Validation for bad habits: -1 to -100
    if (points > -1 || points < -100) {
      return 'Points must be between -1 and -100';
    }
  }

  return null;
}

  static String? dropDownValidator(String? text, String title) {
    if (text!.isEmpty) {
      return 'Please select the $title';
    }
    return null;
  }
}
