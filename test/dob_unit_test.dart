import 'package:amber/screens/auth/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amber/screens/auth/login.dart';
void main() {
  test('dobtest', () {
    var x = PWValidator.validatedob('01/12/21');
    expect(x, true);
  });

  test('dobtest', () {
    var x = PWValidator.validatedob('10102002');
    expect(x, false);
  });
  test('dobtest', () {
    var x = PWValidator.validatedob('10)10)10');
    expect(x, false);
  });

  test('dobtest', () {
    var x = PWValidator.validatedob('10/11/2200');
    expect(x, true);
  });
  test('dobtest', () {
    var x = PWValidator.validatedob('aa.aa.111a');
    expect(x, false);
  });
  test('dobtest', () {
    var x = PWValidator.validatedob('1.1.2001');
    expect(x, true);
  });
}