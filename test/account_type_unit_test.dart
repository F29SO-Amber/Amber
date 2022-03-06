import 'package:amber/screens/auth/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amber/screens/auth/login.dart';
void main() {
  test('acctest1', () {
    var x = PWValidator.validateacc('Artist');
    expect(x, true);
  });

test('acctest2', () {
    var x = PWValidator.validateacc('Student');
    expect(x, true);
  });

  test('acctest3', () {
    var x = PWValidator.validateacc('Content Creator');
    expect(x, true);
  });
  test('acctest4', () {
    var x = PWValidator.validateacc('Brand Marketer');
    expect(x, true);
  });

  test('acctest5', () {
    var x = PWValidator.validateacc('Personal');
    expect(x, true);
  });
  test('acctest6', () {
    var x = PWValidator.validateacc('aaaa');
    expect(x, false);
  });
  test('acctest7', () {
    var x = PWValidator.validateacc('');
    expect(x, false);
  });
}
