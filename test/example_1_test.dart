import 'package:flutter_test/flutter_test.dart';
import 'package:mixin_demo/example_1.dart';
import 'package:mocktail/mocktail.dart';

class MockLoggerMixinClass with LoggerMixin {}

abstract class MockFunctionWithAParam {
  void call(String message);
}

class MockOnLog extends Mock implements MockFunctionWithAParam {}

MockOnLog onLogFunction = MockOnLog();

mixin MockLoggerMixin on LoggerMixin {
  @override
  void log(String message) => onLogFunction.call(message);
}

class MockLoginViewModelWithMixin extends LoginViewModel with MockLoggerMixin {}

void main() {
  MockLoggerMixinClass logger = MockLoggerMixinClass();

  group('LoggerMixin', () {
    test('should have a correct behavior', () {
      logger.tag = '[Testing]';
      logger.log('Foo!');

      expect(logger.tag, '[Testing]');
    });
  });

  group('LoginViewModel', () {
    test('should successfully log message', () {
      MockLoginViewModelWithMixin viewModel = MockLoginViewModelWithMixin();

      viewModel.tag = '[Login]';
      viewModel.login();

      verify(() => onLogFunction.call(any())).called(1);
      expect(viewModel.tag, '[Login]');
    });
  });
}
