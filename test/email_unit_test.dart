import 'package:flutter_test/flutter_test.dart';
import 'package:email_validator/email_validator.dart';

void main() {
  test('emailtest0', () {
    var x = EmailValidator.validate('');
    expect(x, false);
  });

  test('emailtest1', () {
    var x = EmailValidator.validate('foo');
    expect(x, false);
  });
  test('emailtest2', () {
    var x = EmailValidator.validate('foo@foo.com');
    expect(x, true);
  });
  test('emailtest3', () {
    var x = EmailValidator.validate('foo!@122233@gmail.com');
    expect(x, false);
    
  });
  test('emailtest4', () {
    var x = EmailValidator.validate('foo1213341241@gmail.com');
    expect(x, true);
  });
}
