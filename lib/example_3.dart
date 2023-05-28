abstract class A {
  void foo();
}

abstract class B {
  void bar();
}

mixin AMixin implements A {
  @override
  void foo() {
    print('Foo');
  }
}

mixin BMixin implements B {
  @override
  void bar() {
    print('Bar');
  }
}

class MyClass with AMixin, BMixin {
  void printSomething() {
    foo();
  }
}
