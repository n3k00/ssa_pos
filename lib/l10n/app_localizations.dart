import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_my.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('my')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SSA POS'**
  String get appName;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'SSA POS Home'**
  String get homeTitle;

  /// No description provided for @connectPrinter.
  ///
  /// In en, this message translates to:
  /// **'Connect Printer'**
  String get connectPrinter;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @voucherList.
  ///
  /// In en, this message translates to:
  /// **'Voucher List'**
  String get voucherList;

  /// No description provided for @addVoucher.
  ///
  /// In en, this message translates to:
  /// **'Add Voucher'**
  String get addVoucher;

  /// No description provided for @voucherFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Voucher Form'**
  String get voucherFormTitle;

  /// No description provided for @voucherListTitle.
  ///
  /// In en, this message translates to:
  /// **'Vouchers'**
  String get voucherListTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @printerSettings.
  ///
  /// In en, this message translates to:
  /// **'Printer Settings'**
  String get printerSettings;

  /// No description provided for @receiptSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt Header'**
  String get receiptSettingsTitle;

  /// No description provided for @receiptHeaderSettings.
  ///
  /// In en, this message translates to:
  /// **'Receipt Header'**
  String get receiptHeaderSettings;

  /// No description provided for @receiptHeaderSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Edit the receipt title, phone line and layout preview'**
  String get receiptHeaderSettingsHint;

  /// No description provided for @printerTuningSettings.
  ///
  /// In en, this message translates to:
  /// **'Printer Settings'**
  String get printerTuningSettings;

  /// No description provided for @printerTuningSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Adjust print darkness and paper feed after printing'**
  String get printerTuningSettingsHint;

  /// No description provided for @backupRestoreSettings.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupRestoreSettings;

  /// No description provided for @backupRestoreSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Export a portable backup file or import one from another device'**
  String get backupRestoreSettingsHint;

  /// No description provided for @languageSettings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettings;

  /// No description provided for @languageSettingsHint.
  ///
  /// In en, this message translates to:
  /// **'Choose the app language'**
  String get languageSettingsHint;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageMyanmar.
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get languageMyanmar;

  /// No description provided for @languageUpdated.
  ///
  /// In en, this message translates to:
  /// **'Language updated.'**
  String get languageUpdated;

  /// No description provided for @exportBackup.
  ///
  /// In en, this message translates to:
  /// **'Export Full Backup'**
  String get exportBackup;

  /// No description provided for @exportDataOnlyBackup.
  ///
  /// In en, this message translates to:
  /// **'Export Data Only'**
  String get exportDataOnlyBackup;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import Backup'**
  String get importBackup;

  /// No description provided for @backupExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Full backup exported successfully.'**
  String get backupExportSuccess;

  /// No description provided for @backupDataOnlyExportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data-only backup exported successfully.'**
  String get backupDataOnlyExportSuccess;

  /// No description provided for @backupExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export the full backup.'**
  String get backupExportFailed;

  /// No description provided for @backupDataOnlyExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not export the data-only backup.'**
  String get backupDataOnlyExportFailed;

  /// No description provided for @backupPreparingExport.
  ///
  /// In en, this message translates to:
  /// **'Preparing backup file...'**
  String get backupPreparingExport;

  /// No description provided for @backupPreparingDataOnlyExport.
  ///
  /// In en, this message translates to:
  /// **'Preparing data-only backup file...'**
  String get backupPreparingDataOnlyExport;

  /// No description provided for @backupWritingExport.
  ///
  /// In en, this message translates to:
  /// **'Choose where to save the backup file...'**
  String get backupWritingExport;

  /// No description provided for @backupRestoreConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get backupRestoreConfirmTitle;

  /// No description provided for @backupRestoreConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will replace the current local data and images on this device.'**
  String get backupRestoreConfirmMessage;

  /// No description provided for @backupRestoreDataOnlyConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will replace the current local data on this device. Images will not be restored.'**
  String get backupRestoreDataOnlyConfirmMessage;

  /// No description provided for @backupRestoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Full backup imported. The app will close to finish the restore.'**
  String get backupRestoreSuccess;

  /// No description provided for @backupRestoreDataOnlySuccess.
  ///
  /// In en, this message translates to:
  /// **'Data-only backup imported. The app will close to finish the restore.'**
  String get backupRestoreDataOnlySuccess;

  /// No description provided for @backupRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not restore the backup.'**
  String get backupRestoreFailed;

  /// No description provided for @backupImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the selected backup file.'**
  String get backupImportFailed;

  /// No description provided for @backupPreparingImport.
  ///
  /// In en, this message translates to:
  /// **'Opening backup file...'**
  String get backupPreparingImport;

  /// No description provided for @backupRestoring.
  ///
  /// In en, this message translates to:
  /// **'Importing full backup...'**
  String get backupRestoring;

  /// No description provided for @backupRestoringDataOnly.
  ///
  /// In en, this message translates to:
  /// **'Importing data-only backup...'**
  String get backupRestoringDataOnly;

  /// No description provided for @receiptPreviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Live Receipt Preview'**
  String get receiptPreviewLabel;

  /// No description provided for @receiptRowFontSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Row Font Size'**
  String get receiptRowFontSizeLabel;

  /// No description provided for @receiptPaddingTopLabel.
  ///
  /// In en, this message translates to:
  /// **'Padding Top'**
  String get receiptPaddingTopLabel;

  /// No description provided for @receiptPaddingHorizontalLabel.
  ///
  /// In en, this message translates to:
  /// **'Padding Horizontal'**
  String get receiptPaddingHorizontalLabel;

  /// No description provided for @receiptPaddingBottomLabel.
  ///
  /// In en, this message translates to:
  /// **'Padding Bottom'**
  String get receiptPaddingBottomLabel;

  /// No description provided for @receiptTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Receipt Title'**
  String get receiptTitleLabel;

  /// No description provided for @receiptPhonesLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Line'**
  String get receiptPhonesLabel;

  /// No description provided for @printPresetLabel.
  ///
  /// In en, this message translates to:
  /// **'Print Preset'**
  String get printPresetLabel;

  /// No description provided for @feedLinesLabel.
  ///
  /// In en, this message translates to:
  /// **'Feed Lines'**
  String get feedLinesLabel;

  /// No description provided for @printPresetLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get printPresetLight;

  /// No description provided for @printPresetBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get printPresetBalanced;

  /// No description provided for @printPresetDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get printPresetDark;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved.'**
  String get settingsSaved;

  /// No description provided for @settingsSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save settings.'**
  String get settingsSaveFailed;

  /// No description provided for @paymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatusLabel;

  /// No description provided for @paymentStatusDue.
  ///
  /// In en, this message translates to:
  /// **'Payment Due'**
  String get paymentStatusDue;

  /// No description provided for @paymentStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paymentStatusPaid;

  /// No description provided for @saveVoucher.
  ///
  /// In en, this message translates to:
  /// **'Save Voucher'**
  String get saveVoucher;

  /// No description provided for @printPreview.
  ///
  /// In en, this message translates to:
  /// **'Print Preview'**
  String get printPreview;

  /// No description provided for @previewTitle.
  ///
  /// In en, this message translates to:
  /// **'Print Preview'**
  String get previewTitle;

  /// No description provided for @printAndSave.
  ///
  /// In en, this message translates to:
  /// **'Print and Save'**
  String get printAndSave;

  /// No description provided for @reprint.
  ///
  /// In en, this message translates to:
  /// **'Reprint'**
  String get reprint;

  /// No description provided for @receiptDateTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Date/Time'**
  String get receiptDateTimeLabel;

  /// No description provided for @voucherSaved.
  ///
  /// In en, this message translates to:
  /// **'Voucher saved successfully'**
  String get voucherSaved;

  /// No description provided for @voucherSavedAndPrinted.
  ///
  /// In en, this message translates to:
  /// **'Voucher saved and sent to printer.'**
  String get voucherSavedAndPrinted;

  /// No description provided for @voucherReprinted.
  ///
  /// In en, this message translates to:
  /// **'Voucher sent to printer.'**
  String get voucherReprinted;

  /// No description provided for @voucherSavedPrintFailed.
  ///
  /// In en, this message translates to:
  /// **'Voucher saved, but printing failed. Please retry.'**
  String get voucherSavedPrintFailed;

  /// No description provided for @voucherPrintFailedNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Printing failed. Voucher was not saved.'**
  String get voucherPrintFailedNotSaved;

  /// No description provided for @voucherReprintFailed.
  ///
  /// In en, this message translates to:
  /// **'Reprint failed. Please retry.'**
  String get voucherReprintFailed;

  /// No description provided for @printerNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Printer is not connected.'**
  String get printerNotConnected;

  /// No description provided for @printingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Printing... Please wait'**
  String get printingInProgress;

  /// No description provided for @voucherSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, phone, parcel number'**
  String get voucherSearchHint;

  /// No description provided for @voucherEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No vouchers found.'**
  String get voucherEmptyMessage;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get filterByDate;

  /// No description provided for @clearDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Clear date filter'**
  String get clearDateFilter;

  /// No description provided for @printerRequiredForPreview.
  ///
  /// In en, this message translates to:
  /// **'Please connect a printer before opening print preview.'**
  String get printerRequiredForPreview;

  /// No description provided for @requiredFieldMessage.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredFieldMessage;

  /// No description provided for @fillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields.'**
  String get fillRequiredFields;

  /// No description provided for @selectPaymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Select payment status'**
  String get selectPaymentStatus;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get nameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @facebookLabel.
  ///
  /// In en, this message translates to:
  /// **'Facebook Account'**
  String get facebookLabel;

  /// No description provided for @parcelNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Parcel Number'**
  String get parcelNumberLabel;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @itemImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Item Image'**
  String get itemImageLabel;

  /// No description provided for @dispatchReceiptImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Dispatch Receipt Image'**
  String get dispatchReceiptImageLabel;

  /// No description provided for @attachmentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachmentsLabel;

  /// No description provided for @tapImageToView.
  ///
  /// In en, this message translates to:
  /// **'Tap image to view full size'**
  String get tapImageToView;

  /// No description provided for @changesNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Save to keep this image'**
  String get changesNotSaved;

  /// No description provided for @pickImage.
  ///
  /// In en, this message translates to:
  /// **'Pick Image'**
  String get pickImage;

  /// No description provided for @addDispatchReceiptImage.
  ///
  /// In en, this message translates to:
  /// **'Add Dispatch Receipt Image'**
  String get addDispatchReceiptImage;

  /// No description provided for @saveDispatchReceiptImage.
  ///
  /// In en, this message translates to:
  /// **'Save Dispatch Receipt Image'**
  String get saveDispatchReceiptImage;

  /// No description provided for @dispatchReceiptSaved.
  ///
  /// In en, this message translates to:
  /// **'Dispatch receipt image saved.'**
  String get dispatchReceiptSaved;

  /// No description provided for @dispatchReceiptSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save dispatch receipt image.'**
  String get dispatchReceiptSaveFailed;

  /// No description provided for @dispatchReceiptAddedOnPrefix.
  ///
  /// In en, this message translates to:
  /// **'Added on '**
  String get dispatchReceiptAddedOnPrefix;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// No description provided for @removeImage.
  ///
  /// In en, this message translates to:
  /// **'Remove Image'**
  String get removeImage;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @bluetoothPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth and location permissions are required.'**
  String get bluetoothPermissionRequired;

  /// No description provided for @permissionSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get permissionSettingsTitle;

  /// No description provided for @permissionSettingsMessage.
  ///
  /// In en, this message translates to:
  /// **'Bluetooth and location permissions are permanently denied. Please enable them in app settings.'**
  String get permissionSettingsMessage;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @printerConnectedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Connected: '**
  String get printerConnectedPrefix;

  /// No description provided for @restoreDefaults.
  ///
  /// In en, this message translates to:
  /// **'Defaults'**
  String get restoreDefaults;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// No description provided for @posReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'POS project initialized. Next: products, cart, checkout, print.'**
  String get posReadyMessage;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'my'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'my': return AppLocalizationsMy();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
