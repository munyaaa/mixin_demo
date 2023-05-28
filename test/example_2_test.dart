import 'package:flutter_test/flutter_test.dart';
import 'package:mixin_demo/example_2.dart';
import 'package:mocktail/mocktail.dart';

class MockValidatorMixinClass with ValidatorMixin {}

abstract class MockFunctionWithAParam {
  void call(String param);
}

abstract class MockFunctionWithAParamAndBoolReturn {
  bool call(String param);
}

class MockOnLog extends Mock implements MockFunctionWithAParam {}

class MockOnValidateEmail extends Mock
    implements MockFunctionWithAParamAndBoolReturn {}

class MockOnValidatePassword extends Mock
    implements MockFunctionWithAParamAndBoolReturn {}

MockOnLog onLogFunction = MockOnLog();
MockOnValidateEmail onValidateEmailFunction = MockOnValidateEmail();
MockOnValidatePassword onValidatePasswordFunction = MockOnValidatePassword();

mixin MockLoggerMixin on LoggerMixin {
  @override
  void log(String message) => onLogFunction.call(message);
}

mixin MockValidatorMixin on ValidatorMixin {
  @override
  bool validateEmail(String email) => onValidateEmailFunction.call(email);

  @override
  bool validatePassword(String password) =>
      onValidatePasswordFunction.call(password);
}

class MockLoginViewModelWithMixin extends LoginViewModel
    with MockLoggerMixin, MockValidatorMixin {}

void main() {
  MockValidatorMixinClass validator = MockValidatorMixinClass();

  group('ValidatorMixin', () {
    test('should return true when email contains @', () {
      expect(validator.validateEmail('something@mail.com'), true);
    });
    test('should return false when email does not contain @', () {
      expect(validator.validateEmail('somethingmail.com'), false);
    });
    test('should return true when password is more than 6 characters', () {
      expect(validator.validatePassword('1234567'), true);
    });
    test('should return false when password is not more than 6 characters', () {
      expect(validator.validatePassword('12'), false);
    });
  });

  group('LoginViewModel', () {
    test('should return true and log message', () {
      MockLoginViewModelWithMixin viewModel = MockLoginViewModelWithMixin();
      viewModel.tag = '[Login]';

      when(() => onValidateEmailFunction.call(any())).thenAnswer(
        (_) => true,
      );

      when(() => onValidatePasswordFunction.call(any())).thenAnswer(
        (_) => true,
      );

      bool isSuccess = viewModel.login(
        email: 'something@mail.com',
        password: '1234567',
      );

      expect(isSuccess, true);
      expect(viewModel.tag, '[Login]');
      verify(() => onLogFunction.call(any())).called(1);
    });

    test('should return false and log message', () {
      MockLoginViewModelWithMixin viewModel = MockLoginViewModelWithMixin();
      viewModel.tag = '[Login]';

      when(() => onValidateEmailFunction.call(any())).thenAnswer(
        (_) => true,
      );

      when(() => onValidatePasswordFunction.call(any())).thenAnswer(
        (_) => false,
      );

      bool isSuccess = viewModel.login(
        email: 'somethingmail.com',
        password: '12345',
      );

      expect(isSuccess, false);
      expect(viewModel.tag, '[Login]');
      verify(() => onLogFunction.call(any())).called(1);
    });
  });
}
