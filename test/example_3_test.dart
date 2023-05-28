import 'package:flutter_test/flutter_test.dart';
import 'package:mixin_demo/example_3.dart';
import 'package:mocktail/mocktail.dart';

abstract class MockFunction {
  void call();
}

class MockOnFoo extends Mock implements MockFunction {}

MockOnFoo onFooFunction = MockOnFoo();

mixin MockAMixin on A {
  @override
  void foo() => onFooFunction.call();
}

class MockMyClassWithMixin extends MyClass with MockAMixin {}

void main() {
  group('MyClass', () {
    test('should call foo', () {
      MockMyClassWithMixin myClass = MockMyClassWithMixin();

      myClass.printSomething();

      verify(() => onFooFunction.call()).called(1);
    });
  });
}
