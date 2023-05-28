mixin LoggerMixin {
  String tag = '[Default]';

  void log(String message) {
    print('$tag: $message');
  }
}

mixin ValidatorMixin {
  bool validateEmail(String email) {
    return email.contains('@');
  }

  bool validatePassword(String password) {
    return password.length > 6;
  }
}

class LoginViewModel with LoggerMixin, ValidatorMixin {
  LoginViewModel() {
    tag = '[Login]';
  }

  bool login({
    required String email,
    required String password,
  }) {
    if (validateEmail(email) && validatePassword(password)) {
      log('Login Success!');
      return true;
    }
    log('Login Failed!');
    return false;
  }
}
