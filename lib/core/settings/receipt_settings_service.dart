import 'package:shared_preferences/shared_preferences.dart';

enum PrintDensityPreset { light, balanced, dark }

class ReceiptSettings {
  const ReceiptSettings({
    required this.title,
    required this.phones,
    required this.titleFontSize,
    required this.phonesFontSize,
    required this.rowFontSize,
    required this.paddingTop,
    required this.paddingHorizontal,
    required this.paddingBottom,
    required this.printDensityPreset,
    required this.feedLinesAfterPrint,
  });

  final String title;
  final String phones;
  final double titleFontSize;
  final double phonesFontSize;
  final double rowFontSize;
  final double paddingTop;
  final double paddingHorizontal;
  final double paddingBottom;
  final PrintDensityPreset printDensityPreset;
  final int feedLinesAfterPrint;
}

class ReceiptSettingsService {
  const ReceiptSettingsService();

  static const double fixedPaddingBottom = 40;

  static const String _titleKey = 'receipt_settings.title';
  static const String _phonesKey = 'receipt_settings.phones';
  static const String _titleFontSizeKey = 'receipt_settings.title_font_size';
  static const String _phonesFontSizeKey = 'receipt_settings.phones_font_size';
  static const String _rowFontSizeKey = 'receipt_settings.row_font_size';
  static const String _paddingTopKey = 'receipt_settings.padding_top';
  static const String _paddingHorizontalKey = 'receipt_settings.padding_horizontal';
  static const String _paddingLeftKey = 'receipt_settings.padding_left';
  static const String _paddingRightKey = 'receipt_settings.padding_right';
  static const String _paddingBottomKey = 'receipt_settings.padding_bottom';
  static const String _printDensityPresetKey = 'receipt_settings.print_density_preset';
  static const String _feedLinesAfterPrintKey =
      'receipt_settings.feed_lines_after_print';

  Future<ReceiptSettings> load({
    required String defaultTitle,
    required String defaultPhones,
    required double defaultTitleFontSize,
    required double defaultPhonesFontSize,
    required double defaultRowFontSize,
    required double defaultPaddingTop,
    required double defaultPaddingHorizontal,
    required double defaultPaddingBottom,
    required PrintDensityPreset defaultPrintDensityPreset,
    required int defaultFeedLinesAfterPrint,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final title = (prefs.getString(_titleKey) ?? defaultTitle).trim();
      final phones = (prefs.getString(_phonesKey) ?? defaultPhones).trim();
      final titleFontSize = prefs.getDouble(_titleFontSizeKey) ?? defaultTitleFontSize;
      final phonesFontSize =
          prefs.getDouble(_phonesFontSizeKey) ?? defaultPhonesFontSize;
      final rowFontSize = prefs.getDouble(_rowFontSizeKey) ?? defaultRowFontSize;
      final paddingTop = prefs.getDouble(_paddingTopKey) ?? defaultPaddingTop;
      final legacyPaddingLeft = prefs.getDouble(_paddingLeftKey);
      final legacyPaddingRight = prefs.getDouble(_paddingRightKey);
      final paddingHorizontal =
          prefs.getDouble(_paddingHorizontalKey) ??
          (legacyPaddingLeft != null && legacyPaddingRight != null
              ? ((legacyPaddingLeft + legacyPaddingRight) / 2)
              : legacyPaddingLeft ?? legacyPaddingRight ?? defaultPaddingHorizontal);
      final paddingBottom = fixedPaddingBottom;
      final printDensityPreset = _parsePrintDensityPreset(
        prefs.getString(_printDensityPresetKey),
        fallback: defaultPrintDensityPreset,
      );
      final feedLinesAfterPrint =
          prefs.getInt(_feedLinesAfterPrintKey) ?? defaultFeedLinesAfterPrint;
      return ReceiptSettings(
        title: title.isEmpty ? defaultTitle : title,
        phones: phones.isEmpty ? defaultPhones : phones,
        titleFontSize: titleFontSize,
        phonesFontSize: phonesFontSize,
        rowFontSize: rowFontSize,
        paddingTop: paddingTop,
        paddingHorizontal: paddingHorizontal,
        paddingBottom: paddingBottom,
        printDensityPreset: printDensityPreset,
        feedLinesAfterPrint: feedLinesAfterPrint,
      );
    } catch (_) {
      return ReceiptSettings(
        title: defaultTitle,
        phones: defaultPhones,
        titleFontSize: defaultTitleFontSize,
        phonesFontSize: defaultPhonesFontSize,
        rowFontSize: defaultRowFontSize,
        paddingTop: defaultPaddingTop,
        paddingHorizontal: defaultPaddingHorizontal,
        paddingBottom: fixedPaddingBottom,
        printDensityPreset: defaultPrintDensityPreset,
        feedLinesAfterPrint: defaultFeedLinesAfterPrint,
      );
    }
  }

  Future<bool> save({
    required String title,
    required String phones,
    required double titleFontSize,
    required double phonesFontSize,
    required double rowFontSize,
    required double paddingTop,
    required double paddingHorizontal,
    required double paddingBottom,
    required PrintDensityPreset printDensityPreset,
    required int feedLinesAfterPrint,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTitle = await prefs.setString(_titleKey, title.trim());
      final savedPhones = await prefs.setString(_phonesKey, phones.trim());
      final savedTitleFontSize =
          await prefs.setDouble(_titleFontSizeKey, titleFontSize);
      final savedPhonesFontSize =
          await prefs.setDouble(_phonesFontSizeKey, phonesFontSize);
      final savedRowFontSize =
          await prefs.setDouble(_rowFontSizeKey, rowFontSize);
      final savedPaddingTop = await prefs.setDouble(_paddingTopKey, paddingTop);
      final savedPaddingHorizontal =
          await prefs.setDouble(_paddingHorizontalKey, paddingHorizontal);
      if (prefs.containsKey(_paddingLeftKey)) {
        await prefs.remove(_paddingLeftKey);
      }
      if (prefs.containsKey(_paddingRightKey)) {
        await prefs.remove(_paddingRightKey);
      }
      final savedPaddingBottom = await prefs.setDouble(
        _paddingBottomKey,
        fixedPaddingBottom,
      );
      final savedPrintDensityPreset = await prefs.setString(
        _printDensityPresetKey,
        printDensityPreset.name,
      );
      final savedFeedLinesAfterPrint = await prefs.setInt(
        _feedLinesAfterPrintKey,
        feedLinesAfterPrint,
      );
      return savedTitle &&
          savedPhones &&
          savedTitleFontSize &&
          savedPhonesFontSize &&
          savedRowFontSize &&
          savedPaddingTop &&
          savedPaddingHorizontal &&
          savedPaddingBottom &&
          savedPrintDensityPreset &&
          savedFeedLinesAfterPrint;
    } catch (_) {
      return false;
    }
  }

  PrintDensityPreset _parsePrintDensityPreset(
    String? raw, {
    required PrintDensityPreset fallback,
  }) {
    for (final preset in PrintDensityPreset.values) {
      if (preset.name == raw) {
        return preset;
      }
    }
    return fallback;
  }
}
