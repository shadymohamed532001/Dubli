class MyValidatorsHelper {
  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display name must be between 3 and 20 characters';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? addressValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a Address name';
    }
    if (value.length < 3) {
      return 'Address must be at least 3 characters long';
    }
    return null;
  }

  static String? tittleValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a Tittle ';
    }
    if (value.length < 3) {
      return 'Tittle must be at least 6 characters long';
    }
    return null;
  }

  static String? noteValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a note ';
    }
    if (value.length < 3) {
      return 'Note must be at least 6 characters long';
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a phone number';
    }
    if (value.length < 6) {
      return 'phone number must be at least 6 numbers';
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
