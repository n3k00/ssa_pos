import 'package:image_picker/image_picker.dart';
import 'package:ssa/core/storage/local_image_storage_service.dart';

enum VoucherImageSource { camera, gallery }

enum VoucherImageType { item, dispatchReceipt }

class VoucherImageLocalDataSource {
  VoucherImageLocalDataSource({
    ImagePicker? picker,
    required LocalImageStorageService storageService,
  })  : _picker = picker ?? ImagePicker(),
        _storageService = storageService;

  final ImagePicker _picker;
  final LocalImageStorageService _storageService;

  Future<String?> pickAndSave({
    required VoucherImageSource source,
    required VoucherImageType type,
  }) async {
    final picked = await _picker.pickImage(
      source: source == VoucherImageSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null) {
      return null;
    }

    return _storageService.saveFromSourcePath(
      sourcePath: picked.path,
      folderName: 'voucher_images',
      fileNamePrefix: type == VoucherImageType.item
          ? 'item_image'
          : 'dispatch_receipt_image',
      // Camera capture path is usually temporary; clean it after app-local copy.
      deleteSourceAfterCopy: source == VoucherImageSource.camera,
    );
  }

  Future<void> deleteSavedImage(String? path) {
    return _storageService.deleteIfExists(path);
  }
}
