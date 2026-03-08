import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalImageStorageService {
  Future<String> saveFromSourcePath({
    required String sourcePath,
    required String folderName,
    required String fileNamePrefix,
    bool deleteSourceAfterCopy = false,
  }) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw FileSystemException('Source image not found', sourcePath);
    }

    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory(p.join(appDir.path, folderName));
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final extension = p.extension(sourcePath).toLowerCase();
    final safeExtension = extension.isEmpty ? '.jpg' : extension;
    final fileName =
        '${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}$safeExtension';
    final savedFile = await sourceFile.copy(p.join(imagesDir.path, fileName));

    if (deleteSourceAfterCopy) {
      try {
        await sourceFile.delete();
      } catch (_) {
        // Best effort cleanup for temporary camera files.
      }
    }

    return savedFile.path;
  }

  Future<void> deleteIfExists(String? path) async {
    if (path == null || path.isEmpty) {
      return;
    }

    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
