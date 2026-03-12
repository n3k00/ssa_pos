import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class LocalImageStorageService {
  static const int _maxImageWidth = 1280;
  static const int _jpegQuality = 78;

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

    final fileName = '${fileNamePrefix}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final savedPath = p.join(imagesDir.path, fileName);
    final savedFile = await _saveOptimizedJpeg(
      sourceFile: sourceFile,
      destinationPath: savedPath,
    );

    if (deleteSourceAfterCopy) {
      try {
        await sourceFile.delete();
      } catch (_) {
        // Best effort cleanup for temporary camera files.
      }
    }

    return savedFile.path;
  }

  Future<File> _saveOptimizedJpeg({
    required File sourceFile,
    required String destinationPath,
  }) async {
    try {
      final bytes = await sourceFile.readAsBytes();
      final decoded = img.decodeImage(bytes);
      if (decoded == null) {
        return sourceFile.copy(destinationPath);
      }

      final normalized = decoded.width > _maxImageWidth
          ? img.copyResize(decoded, width: _maxImageWidth)
          : decoded;
      final jpgBytes = img.encodeJpg(normalized, quality: _jpegQuality);
      final output = File(destinationPath);
      return output.writeAsBytes(jpgBytes, flush: true);
    } catch (_) {
      return sourceFile.copy(destinationPath);
    }
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
