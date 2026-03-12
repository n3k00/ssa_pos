import 'package:shared_preferences/shared_preferences.dart';

class LocaleSettingsService {
  const LocaleSettingsService({this.preferencesProvider = SharedPreferences.getInstance});

  static const String defaultLanguageCode = 'en';
  static const String myanmarLanguageCode = 'my';
  static const String _localeLanguageCodeKey = 'app_locale_language_code';

  final Future<SharedPreferences> Function() preferencesProvider;

  Future<String> loadLanguageCode() async {
    final preferences = await preferencesProvider();
    return preferences.getString(_localeLanguageCodeKey) ?? defaultLanguageCode;
  }

  Future<bool> saveLanguageCode(String languageCode) async {
    final preferences = await preferencesProvider();
    return preferences.setString(_localeLanguageCodeKey, languageCode);
  }
}
