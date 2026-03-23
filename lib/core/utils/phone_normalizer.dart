class PhoneNormalizer {
  const PhoneNormalizer._();
  static const String _authDomain = 'ssa.com';

  static String normalizeMyanmarPhone(String input) {
    var value = input.trim();
    value = value.replaceAll(RegExp(r'[\s\-()]'), '');

    if (value.startsWith('+95')) {
      value = '0${value.substring(3)}';
    } else if (value.startsWith('95')) {
      value = '0${value.substring(2)}';
    }

    if (!RegExp(r'^\d+$').hasMatch(value)) {
      throw const FormatException('invalid_phone');
    }

    if (!RegExp(r'^09\d{7,15}$').hasMatch(value)) {
      throw const FormatException('invalid_phone');
    }

    return value;
  }

  static String toAuthEmail(String normalizedPhone) {
    return '$normalizedPhone@$_authDomain';
  }

  static String? phoneFromAuthEmail(String? email) {
    if (email == null || email.isEmpty) {
      return null;
    }
    final suffix = '@$_authDomain';
    if (!email.endsWith(suffix)) {
      return null;
    }
    return email.substring(0, email.length - suffix.length);
  }
}
