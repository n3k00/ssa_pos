import 'package:flutter_test/flutter_test.dart';
import 'package:ssa/core/utils/phone_normalizer.dart';

void main() {
  test('normalizes local Myanmar phone format', () {
    expect(
      PhoneNormalizer.normalizeMyanmarPhone('09 123 456 789'),
      '09123456789',
    );
  });

  test('normalizes +95 Myanmar phone format', () {
    expect(
      PhoneNormalizer.normalizeMyanmarPhone('+95 9 123 456 789'),
      '09123456789',
    );
  });

  test('creates stable auth email from normalized phone', () {
    expect(
      PhoneNormalizer.toAuthEmail('09123456789'),
      '09123456789@ssa.com',
    );
  });

  test('throws for invalid phone number', () {
    expect(
      () => PhoneNormalizer.normalizeMyanmarPhone('08123456789'),
      throwsFormatException,
    );
  });
}
