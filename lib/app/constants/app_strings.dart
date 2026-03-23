import 'package:ssa/app/router/app_navigation.dart';
import 'package:ssa/l10n/app_localizations.dart';

class AppStrings {
  static const receiptShopTitle = 'Sai Shwe Aye';
  static const receiptPhones = 'Ph - 09445876399, 09776577202';

  static AppLocalizations? get _l10n {
    final context = rootNavigatorKey.currentContext;
    if (context == null) {
      return null;
    }
    return AppLocalizations.of(context);
  }

  static String _resolve(
    String fallback,
    String Function(AppLocalizations value) read,
  ) {
    final l10n = _l10n;
    if (l10n == null) {
      return fallback;
    }
    return read(l10n);
  }

  static String get appName => _resolve('SSA POS', (l10n) => l10n.appName);
  static String get homeTitle =>
      _resolve('SSA POS Home', (l10n) => l10n.homeTitle);
  static String get loginTitle =>
      _resolve('Sign In', (l10n) => l10n.loginTitle);
  static String get loginSubtitle => _resolve(
    'Use your phone number and password to continue.',
    (l10n) => l10n.loginSubtitle,
  );
  static String get signIn => _resolve('Sign In', (l10n) => l10n.signIn);
  static String get phoneNumberLabel =>
      _resolve('Phone Number', (l10n) => l10n.phoneNumberLabel);
  static String get passwordLabel =>
      _resolve('Password', (l10n) => l10n.passwordLabel);
  static String get invalidPhoneNumber => _resolve(
    'Enter a valid Myanmar phone number.',
    (l10n) => l10n.invalidPhoneNumber,
  );
  static String get loginFailedGeneric => _resolve(
    'Invalid phone number or password.',
    (l10n) => l10n.loginFailedGeneric,
  );
  static String get launchStarting =>
      _resolve('Starting SSA POS...', (l10n) => l10n.launchStarting);
  static String get launchCheckingSession => _resolve(
    'Checking session...',
    (l10n) => l10n.launchCheckingSession,
  );
  static String get authStateError => _resolve(
    'Could not check the login state.',
    (l10n) => l10n.authStateError,
  );
  static String get connectPrinter =>
      _resolve('Connect Printer', (l10n) => l10n.connectPrinter);
  static String get menu => _resolve('Menu', (l10n) => l10n.menu);
  static String get home => _resolve('Home', (l10n) => l10n.home);
  static String get voucherList =>
      _resolve('Voucher List', (l10n) => l10n.voucherList);
  static String get addVoucher =>
      _resolve('Add Voucher', (l10n) => l10n.addVoucher);
  static String get voucherFormTitle =>
      _resolve('Voucher Form', (l10n) => l10n.voucherFormTitle);
  static String get voucherListTitle =>
      _resolve('Vouchers', (l10n) => l10n.voucherListTitle);
  static String get settings => _resolve('Settings', (l10n) => l10n.settings);
  static String get profileSettings =>
      _resolve('Profile', (l10n) => l10n.profileSettings);
  static String get profileSettingsHint => _resolve(
    'View the account phone number and sync status',
    (l10n) => l10n.profileSettingsHint,
  );
  static String get printerSettings =>
      _resolve('Printer Settings', (l10n) => l10n.printerSettings);
  static String get receiptSettingsTitle =>
      _resolve('Receipt Header', (l10n) => l10n.receiptSettingsTitle);
  static String get receiptHeaderSettings =>
      _resolve('Receipt Header', (l10n) => l10n.receiptHeaderSettings);
  static String get receiptHeaderSettingsHint => _resolve(
    'Edit the receipt title, phone line and layout preview',
    (l10n) => l10n.receiptHeaderSettingsHint,
  );
  static String get printerTuningSettings =>
      _resolve('Printer Settings', (l10n) => l10n.printerTuningSettings);
  static String get printerTuningSettingsHint => _resolve(
    'Adjust print darkness and paper feed after printing',
    (l10n) => l10n.printerTuningSettingsHint,
  );
  static String get backupRestoreSettings =>
      _resolve('Backup & Restore', (l10n) => l10n.backupRestoreSettings);
  static String get backupRestoreSettingsHint => _resolve(
    'Export a portable backup file or import one from another device',
    (l10n) => l10n.backupRestoreSettingsHint,
  );
  static String get languageSettings =>
      _resolve('Language', (l10n) => l10n.languageSettings);
  static String get languageSettingsHint =>
      _resolve('Choose the app language', (l10n) => l10n.languageSettingsHint);
  static String get languageEnglish =>
      _resolve('English', (l10n) => l10n.languageEnglish);
  static String get languageMyanmar =>
      _resolve('Myanmar', (l10n) => l10n.languageMyanmar);
  static String get languageUpdated =>
      _resolve('Language updated.', (l10n) => l10n.languageUpdated);
  static String get syncNow => _resolve('Sync Now', (l10n) => l10n.syncNow);
  static String get lastSyncTimeLabel =>
      _resolve('Last Sync Time', (l10n) => l10n.lastSyncTimeLabel);
  static String get syncStatusLabel =>
      _resolve('Sync Status', (l10n) => l10n.syncStatusLabel);
  static String get syncingNow =>
      _resolve('Syncing...', (l10n) => l10n.syncingNow);
  static String get syncFailed =>
      _resolve('Sync failed', (l10n) => l10n.syncFailed);
  static String get syncReady =>
      _resolve('Up to date', (l10n) => l10n.syncReady);
  static String get syncNotStarted =>
      _resolve('Not synced yet', (l10n) => l10n.syncNotStarted);
  static String get syncNever =>
      _resolve('Never', (l10n) => l10n.syncNever);
  static String get logout => _resolve('Logout', (l10n) => l10n.logout);
  static String get logoutConfirmTitle =>
      _resolve('Logout', (l10n) => l10n.logoutConfirmTitle);
  static String get logoutConfirmMessage => _resolve(
    'Do you want to sign out now?',
    (l10n) => l10n.logoutConfirmMessage,
  );
  static String get yes => _resolve('Yes', (l10n) => l10n.yes);
  static String get no => _resolve('No', (l10n) => l10n.no);
  static String get exportBackup =>
      _resolve('Export Full Backup', (l10n) => l10n.exportBackup);
  static String get exportDataOnlyBackup =>
      _resolve('Export Data Only', (l10n) => l10n.exportDataOnlyBackup);
  static String get importBackup =>
      _resolve('Import Backup', (l10n) => l10n.importBackup);
  static String get backupExportSuccess => _resolve(
    'Full backup exported successfully.',
    (l10n) => l10n.backupExportSuccess,
  );
  static String get backupDataOnlyExportSuccess => _resolve(
    'Data-only backup exported successfully.',
    (l10n) => l10n.backupDataOnlyExportSuccess,
  );
  static String get backupExportFailed => _resolve(
    'Could not export the full backup.',
    (l10n) => l10n.backupExportFailed,
  );
  static String get backupDataOnlyExportFailed => _resolve(
    'Could not export the data-only backup.',
    (l10n) => l10n.backupDataOnlyExportFailed,
  );
  static String get backupPreparingExport => _resolve(
    'Preparing backup file...',
    (l10n) => l10n.backupPreparingExport,
  );
  static String get backupPreparingDataOnlyExport => _resolve(
    'Preparing data-only backup file...',
    (l10n) => l10n.backupPreparingDataOnlyExport,
  );
  static String get backupWritingExport => _resolve(
    'Choose where to save the backup file...',
    (l10n) => l10n.backupWritingExport,
  );
  static String get backupRestoreConfirmTitle =>
      _resolve('Restore Backup', (l10n) => l10n.backupRestoreConfirmTitle);
  static String get backupRestoreConfirmMessage => _resolve(
    'This will replace the current local data and images on this device.',
    (l10n) => l10n.backupRestoreConfirmMessage,
  );
  static String get backupRestoreDataOnlyConfirmMessage => _resolve(
    'This will replace the current local data on this device. Images will not be restored.',
    (l10n) => l10n.backupRestoreDataOnlyConfirmMessage,
  );
  static String get backupRestoreSuccess => _resolve(
    'Full backup imported. The app will close to finish the restore.',
    (l10n) => l10n.backupRestoreSuccess,
  );
  static String get backupRestoreDataOnlySuccess => _resolve(
    'Data-only backup imported. The app will close to finish the restore.',
    (l10n) => l10n.backupRestoreDataOnlySuccess,
  );
  static String get backupRestoreFailed => _resolve(
    'Could not restore the backup.',
    (l10n) => l10n.backupRestoreFailed,
  );
  static String get backupImportFailed => _resolve(
    'Could not open the selected backup file.',
    (l10n) => l10n.backupImportFailed,
  );
  static String get backupPreparingImport => _resolve(
    'Opening backup file...',
    (l10n) => l10n.backupPreparingImport,
  );
  static String get backupRestoring => _resolve(
    'Importing full backup...',
    (l10n) => l10n.backupRestoring,
  );
  static String get backupRestoringDataOnly => _resolve(
    'Importing data-only backup...',
    (l10n) => l10n.backupRestoringDataOnly,
  );
  static String get receiptPreviewLabel =>
      _resolve('Live Receipt Preview', (l10n) => l10n.receiptPreviewLabel);
  static String get receiptRowFontSizeLabel =>
      _resolve('Row Font Size', (l10n) => l10n.receiptRowFontSizeLabel);
  static String get receiptPaddingTopLabel =>
      _resolve('Padding Top', (l10n) => l10n.receiptPaddingTopLabel);
  static String get receiptPaddingHorizontalLabel => _resolve(
    'Padding Horizontal',
    (l10n) => l10n.receiptPaddingHorizontalLabel,
  );
  static String get receiptPaddingBottomLabel =>
      _resolve('Padding Bottom', (l10n) => l10n.receiptPaddingBottomLabel);
  static String get receiptTitleLabel =>
      _resolve('Receipt Title', (l10n) => l10n.receiptTitleLabel);
  static String get receiptPhonesLabel =>
      _resolve('Phone Line', (l10n) => l10n.receiptPhonesLabel);
  static String get printPresetLabel =>
      _resolve('Print Preset', (l10n) => l10n.printPresetLabel);
  static String get feedLinesLabel =>
      _resolve('Feed Lines', (l10n) => l10n.feedLinesLabel);
  static String get printPresetLight =>
      _resolve('Light', (l10n) => l10n.printPresetLight);
  static String get printPresetBalanced =>
      _resolve('Balanced', (l10n) => l10n.printPresetBalanced);
  static String get printPresetDark =>
      _resolve('Dark', (l10n) => l10n.printPresetDark);
  static String get settingsSaved =>
      _resolve('Settings saved.', (l10n) => l10n.settingsSaved);
  static String get settingsSaveFailed =>
      _resolve('Could not save settings.', (l10n) => l10n.settingsSaveFailed);
  static String get paymentStatusLabel =>
      _resolve('Payment Status', (l10n) => l10n.paymentStatusLabel);
  static String get paymentStatusDue =>
      _resolve('Payment Due', (l10n) => l10n.paymentStatusDue);
  static String get paymentStatusPaid =>
      _resolve('Paid', (l10n) => l10n.paymentStatusPaid);
  static String get saveVoucher =>
      _resolve('Save Voucher', (l10n) => l10n.saveVoucher);
  static String get printPreview =>
      _resolve('Print Preview', (l10n) => l10n.printPreview);
  static String get previewTitle =>
      _resolve('Print Preview', (l10n) => l10n.previewTitle);
  static String get printAndSave =>
      _resolve('Print and Save', (l10n) => l10n.printAndSave);
  static String get reprint => _resolve('Reprint', (l10n) => l10n.reprint);
  static String get receiptDateTimeLabel =>
      _resolve('Date/Time', (l10n) => l10n.receiptDateTimeLabel);
  static String get voucherSaved =>
      _resolve('Voucher saved successfully', (l10n) => l10n.voucherSaved);
  static String get voucherSavedAndPrinted => _resolve(
    'Voucher saved and sent to printer.',
    (l10n) => l10n.voucherSavedAndPrinted,
  );
  static String get voucherReprinted =>
      _resolve('Voucher sent to printer.', (l10n) => l10n.voucherReprinted);
  static String get voucherSavedPrintFailed => _resolve(
    'Voucher saved, but printing failed. Please retry.',
    (l10n) => l10n.voucherSavedPrintFailed,
  );
  static String get voucherPrintFailedNotSaved => _resolve(
    'Printing failed. Voucher was not saved.',
    (l10n) => l10n.voucherPrintFailedNotSaved,
  );
  static String get voucherReprintFailed => _resolve(
    'Reprint failed. Please retry.',
    (l10n) => l10n.voucherReprintFailed,
  );
  static String get printerNotConnected =>
      _resolve('Printer is not connected.', (l10n) => l10n.printerNotConnected);
  static String get printingInProgress => _resolve(
    'Printing... Please wait',
    (l10n) => l10n.printingInProgress,
  );
  static String get voucherSearchHint => _resolve(
    'Search by name, phone, parcel number',
    (l10n) => l10n.voucherSearchHint,
  );
  static String get voucherEmptyMessage =>
      _resolve('No vouchers found.', (l10n) => l10n.voucherEmptyMessage);
  static String get filterByDate =>
      _resolve('Filter by date', (l10n) => l10n.filterByDate);
  static String get clearDateFilter =>
      _resolve('Clear date filter', (l10n) => l10n.clearDateFilter);
  static String get printerRequiredForPreview => _resolve(
    'Please connect a printer before opening print preview.',
    (l10n) => l10n.printerRequiredForPreview,
  );
  static String get requiredFieldMessage => _resolve(
    'This field is required',
    (l10n) => l10n.requiredFieldMessage,
  );
  static String get fillRequiredFields => _resolve(
    'Please fill all required fields.',
    (l10n) => l10n.fillRequiredFields,
  );
  static String get selectPaymentStatus => _resolve(
    'Select payment status',
    (l10n) => l10n.selectPaymentStatus,
  );
  static String get nameLabel =>
      _resolve('Recipient', (l10n) => l10n.nameLabel);
  static String get phoneLabel =>
      _resolve('Phone', (l10n) => l10n.phoneLabel);
  static String get addressLabel =>
      _resolve('Address', (l10n) => l10n.addressLabel);
  static String get facebookLabel =>
      _resolve('Facebook Account', (l10n) => l10n.facebookLabel);
  static String get parcelNumberLabel =>
      _resolve('Parcel Number', (l10n) => l10n.parcelNumberLabel);
  static String get noteLabel => _resolve('Note', (l10n) => l10n.noteLabel);
  static String get itemImageLabel =>
      _resolve('Item Image', (l10n) => l10n.itemImageLabel);
  static String get dispatchReceiptImageLabel => _resolve(
    'Dispatch Receipt Image',
    (l10n) => l10n.dispatchReceiptImageLabel,
  );
  static String get attachmentsLabel =>
      _resolve('Attachments', (l10n) => l10n.attachmentsLabel);
  static String get tapImageToView => _resolve(
    'Tap image to view full size',
    (l10n) => l10n.tapImageToView,
  );
  static String get changesNotSaved => _resolve(
    'Save to keep this image',
    (l10n) => l10n.changesNotSaved,
  );
  static String get pickImage =>
      _resolve('Pick Image', (l10n) => l10n.pickImage);
  static String get addDispatchReceiptImage => _resolve(
    'Add Dispatch Receipt Image',
    (l10n) => l10n.addDispatchReceiptImage,
  );
  static String get saveDispatchReceiptImage => _resolve(
    'Save Dispatch Receipt Image',
    (l10n) => l10n.saveDispatchReceiptImage,
  );
  static String get dispatchReceiptSaved => _resolve(
    'Dispatch receipt image saved.',
    (l10n) => l10n.dispatchReceiptSaved,
  );
  static String get dispatchReceiptSaveFailed => _resolve(
    'Could not save dispatch receipt image.',
    (l10n) => l10n.dispatchReceiptSaveFailed,
  );
  static String get dispatchReceiptAddedOnPrefix =>
      _resolve('Added on ', (l10n) => l10n.dispatchReceiptAddedOnPrefix);
  static String get changeImage =>
      _resolve('Change Image', (l10n) => l10n.changeImage);
  static String get removeImage =>
      _resolve('Remove Image', (l10n) => l10n.removeImage);
  static String get camera => _resolve('Camera', (l10n) => l10n.camera);
  static String get gallery => _resolve('Gallery', (l10n) => l10n.gallery);
  static String get bluetoothPermissionRequired => _resolve(
    'Bluetooth and location permissions are required.',
    (l10n) => l10n.bluetoothPermissionRequired,
  );
  static String get permissionSettingsTitle => _resolve(
    'Permission Required',
    (l10n) => l10n.permissionSettingsTitle,
  );
  static String get permissionSettingsMessage => _resolve(
    'Bluetooth and location permissions are permanently denied. Please enable them in app settings.',
    (l10n) => l10n.permissionSettingsMessage,
  );
  static String get openSettings =>
      _resolve('Open Settings', (l10n) => l10n.openSettings);
  static String get printerConnectedPrefix =>
      _resolve('Connected: ', (l10n) => l10n.printerConnectedPrefix);
  static String get restoreDefaults =>
      _resolve('Defaults', (l10n) => l10n.restoreDefaults);
  static String get ok => _resolve('OK', (l10n) => l10n.ok);
  static String get cancel => _resolve('Cancel', (l10n) => l10n.cancel);
  static String get save => _resolve('Save', (l10n) => l10n.save);
  static String get retry => _resolve('Retry', (l10n) => l10n.retry);
  static String get loading => _resolve('Loading...', (l10n) => l10n.loading);
  static String get noData =>
      _resolve('No data available', (l10n) => l10n.noData);
  static String get errorGeneric =>
      _resolve('Something went wrong', (l10n) => l10n.errorGeneric);
  static String get posReadyMessage => _resolve(
    'POS project initialized. Next: products, cart, checkout, print.',
    (l10n) => l10n.posReadyMessage,
  );

  const AppStrings._();
}
