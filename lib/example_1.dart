mixin LoggerMixin {
  String tag = '[Default]';

  void log(String message) {
    print('$tag: $message');
  }
}

class LoginViewModel with LoggerMixin {
  LoginViewModel() {
    tag = '[Login]';
  }

  void login() {
    log('Foo!');
  }
}
