// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SSA POS';

  @override
  String get homeTitle => 'SSA POS Home';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get loginSubtitle => 'Use your phone number and password to continue.';

  @override
  String get signIn => 'Sign In';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get passwordLabel => 'Password';

  @override
  String get invalidPhoneNumber => 'Enter a valid Myanmar phone number.';

  @override
  String get loginFailedGeneric => 'Invalid phone number or password.';

  @override
  String get launchStarting => 'Starting SSA POS...';

  @override
  String get launchCheckingSession => 'Checking session...';

  @override
  String get authStateError => 'Could not check the login state.';

  @override
  String get connectPrinter => 'Connect Printer';

  @override
  String get menu => 'Menu';

  @override
  String get home => 'Home';

  @override
  String get voucherList => 'Voucher List';

  @override
  String get addVoucher => 'Add Voucher';

  @override
  String get voucherFormTitle => 'Voucher Form';

  @override
  String get voucherListTitle => 'Vouchers';

  @override
  String get settings => 'Settings';

  @override
  String get profileSettings => 'Profile';

  @override
  String get profileSettingsHint => 'View the account phone number and sync status';

  @override
  String get printerSettings => 'Printer Settings';

  @override
  String get receiptSettingsTitle => 'Receipt Header';

  @override
  String get receiptHeaderSettings => 'Receipt Header';

  @override
  String get receiptHeaderSettingsHint => 'Edit the receipt title, phone line and layout preview';

  @override
  String get printerTuningSettings => 'Printer Settings';

  @override
  String get printerTuningSettingsHint => 'Adjust print darkness and paper feed after printing';

  @override
  String get backupRestoreSettings => 'Backup & Restore';

  @override
  String get backupRestoreSettingsHint => 'Export a portable backup file or import one from another device';

  @override
  String get languageSettings => 'Language';

  @override
  String get languageSettingsHint => 'Choose the app language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageMyanmar => 'Myanmar';

  @override
  String get languageUpdated => 'Language updated.';

  @override
  String get syncNow => 'Sync Now';

  @override
  String get lastSyncTimeLabel => 'Last Sync Time';

  @override
  String get syncStatusLabel => 'Sync Status';

  @override
  String get syncingNow => 'Syncing...';

  @override
  String get syncFailed => 'Sync failed';

  @override
  String get syncReady => 'Up to date';

  @override
  String get syncNotStarted => 'Not synced yet';

  @override
  String get syncNever => 'Never';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Do you want to sign out now?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get exportBackup => 'Export Full Backup';

  @override
  String get exportDataOnlyBackup => 'Export Data Only';

  @override
  String get importBackup => 'Import Backup';

  @override
  String get backupExportSuccess => 'Full backup exported successfully.';

  @override
  String get backupDataOnlyExportSuccess => 'Data-only backup exported successfully.';

  @override
  String get backupExportFailed => 'Could not export the full backup.';

  @override
  String get backupDataOnlyExportFailed => 'Could not export the data-only backup.';

  @override
  String get backupPreparingExport => 'Preparing backup file...';

  @override
  String get backupPreparingDataOnlyExport => 'Preparing data-only backup file...';

  @override
  String get backupWritingExport => 'Choose where to save the backup file...';

  @override
  String get backupRestoreConfirmTitle => 'Restore Backup';

  @override
  String get backupRestoreConfirmMessage => 'This will replace the current local data and images on this device.';

  @override
  String get backupRestoreDataOnlyConfirmMessage => 'This will replace the current local data on this device. Images will not be restored.';

  @override
  String get backupRestoreSuccess => 'Full backup imported. The app will close to finish the restore.';

  @override
  String get backupRestoreDataOnlySuccess => 'Data-only backup imported. The app will close to finish the restore.';

  @override
  String get backupRestoreFailed => 'Could not restore the backup.';

  @override
  String get backupImportFailed => 'Could not open the selected backup file.';

  @override
  String get backupPreparingImport => 'Opening backup file...';

  @override
  String get backupRestoring => 'Importing full backup...';

  @override
  String get backupRestoringDataOnly => 'Importing data-only backup...';

  @override
  String get receiptPreviewLabel => 'Live Receipt Preview';

  @override
  String get receiptRowFontSizeLabel => 'Row Font Size';

  @override
  String get receiptPaddingTopLabel => 'Padding Top';

  @override
  String get receiptPaddingHorizontalLabel => 'Padding Horizontal';

  @override
  String get receiptPaddingBottomLabel => 'Padding Bottom';

  @override
  String get receiptTitleLabel => 'Receipt Title';

  @override
  String get receiptPhonesLabel => 'Phone Line';

  @override
  String get printPresetLabel => 'Print Preset';

  @override
  String get feedLinesLabel => 'Feed Lines';

  @override
  String get printPresetLight => 'Light';

  @override
  String get printPresetBalanced => 'Balanced';

  @override
  String get printPresetDark => 'Dark';

  @override
  String get settingsSaved => 'Settings saved.';

  @override
  String get settingsSaveFailed => 'Could not save settings.';

  @override
  String get paymentStatusLabel => 'Payment Status';

  @override
  String get paymentStatusDue => 'Payment Due';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get saveVoucher => 'Save Voucher';

  @override
  String get printPreview => 'Print Preview';

  @override
  String get previewTitle => 'Print Preview';

  @override
  String get printAndSave => 'Print and Save';

  @override
  String get reprint => 'Reprint';

  @override
  String get receiptDateTimeLabel => 'Date/Time';

  @override
  String get voucherSaved => 'Voucher saved successfully';

  @override
  String get voucherSavedAndPrinted => 'Voucher saved and sent to printer.';

  @override
  String get voucherReprinted => 'Voucher sent to printer.';

  @override
  String get voucherSavedPrintFailed => 'Voucher saved, but printing failed. Please retry.';

  @override
  String get voucherPrintFailedNotSaved => 'Printing failed. Voucher was not saved.';

  @override
  String get voucherReprintFailed => 'Reprint failed. Please retry.';

  @override
  String get printerNotConnected => 'Printer is not connected.';

  @override
  String get printingInProgress => 'Printing... Please wait';

  @override
  String get voucherSearchHint => 'Search by name, phone, parcel number';

  @override
  String get voucherEmptyMessage => 'No vouchers found.';

  @override
  String get filterByDate => 'Filter by date';

  @override
  String get clearDateFilter => 'Clear date filter';

  @override
  String get printerRequiredForPreview => 'Please connect a printer before opening print preview.';

  @override
  String get requiredFieldMessage => 'This field is required';

  @override
  String get fillRequiredFields => 'Please fill all required fields.';

  @override
  String get selectPaymentStatus => 'Select payment status';

  @override
  String get nameLabel => 'Recipient';

  @override
  String get phoneLabel => 'Phone';

  @override
  String get addressLabel => 'Address';

  @override
  String get facebookLabel => 'Facebook Account';

  @override
  String get parcelNumberLabel => 'Parcel Number';

  @override
  String get noteLabel => 'Note';

  @override
  String get itemImageLabel => 'Item Image';

  @override
  String get dispatchReceiptImageLabel => 'Dispatch Receipt Image';

  @override
  String get attachmentsLabel => 'Attachments';

  @override
  String get tapImageToView => 'Tap image to view full size';

  @override
  String get changesNotSaved => 'Save to keep this image';

  @override
  String get pickImage => 'Pick Image';

  @override
  String get addDispatchReceiptImage => 'Add Dispatch Receipt Image';

  @override
  String get saveDispatchReceiptImage => 'Save Dispatch Receipt Image';

  @override
  String get dispatchReceiptSaved => 'Dispatch receipt image saved.';

  @override
  String get dispatchReceiptSaveFailed => 'Could not save dispatch receipt image.';

  @override
  String get dispatchReceiptAddedOnPrefix => 'Added on ';

  @override
  String get changeImage => 'Change Image';

  @override
  String get removeImage => 'Remove Image';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get bluetoothPermissionRequired => 'Bluetooth and location permissions are required.';

  @override
  String get permissionSettingsTitle => 'Permission Required';

  @override
  String get permissionSettingsMessage => 'Bluetooth and location permissions are permanently denied. Please enable them in app settings.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get printerConnectedPrefix => 'Connected: ';

  @override
  String get restoreDefaults => 'Defaults';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data available';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get posReadyMessage => 'POS project initialized. Next: products, cart, checkout, print.';
}
