import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

enum BackupImportType { full, dataOnly }

class LocalBackupService {
  const LocalBackupService({
    this.appDirectoryProvider = getApplicationDocumentsDirectory,
    this.temporaryDirectoryProvider = getTemporaryDirectory,
    this.databaseFileName = 'ssa_pos.sqlite',
    this.imagesFolderName = 'voucher_images',
  });

  final Future<Directory> Function() appDirectoryProvider;
  final Future<Directory> Function() temporaryDirectoryProvider;
  final String databaseFileName;
  final String imagesFolderName;

  Future<Uint8List> exportDataOnlyBackupBytes() async {
    final appDir = await appDirectoryProvider();
    final dbFile = File(p.join(appDir.path, databaseFileName));
    if (!await dbFile.exists()) {
      throw FileSystemException('Database file not found', dbFile.path);
    }
    return Uint8List.fromList(await dbFile.readAsBytes());
  }

  Future<Uint8List> exportBackupZipBytes() async {
    final appDir = await appDirectoryProvider();
    final dbFile = File(p.join(appDir.path, databaseFileName));
    if (!await dbFile.exists()) {
      throw FileSystemException('Database file not found', dbFile.path);
    }

    final archive = Archive();
    archive.addFile(
      ArchiveFile(
        databaseFileName,
        await dbFile.length(),
        await dbFile.readAsBytes(),
      ),
    );

    final imagesDir = Directory(p.join(appDir.path, imagesFolderName));
    if (await imagesDir.exists()) {
      await for (final entity
          in imagesDir.list(recursive: true, followLinks: false)) {
        if (entity is! File) {
          continue;
        }
        final relativePath = p.relative(entity.path, from: appDir.path);
        archive.addFile(
          ArchiveFile(
            _normalizeEntryPath(relativePath),
            await entity.length(),
            await entity.readAsBytes(),
          ),
        );
      }
    }

    return Uint8List.fromList(ZipEncoder().encode(archive));
  }

  Future<File> exportBackupZipToTemporaryFile() async {
    final zipBytes = await exportBackupZipBytes();
    final tempDir = await temporaryDirectoryProvider();
    final exportsDir = Directory(p.join(tempDir.path, 'ssa_backups'));
    await exportsDir.create(recursive: true);
    final exportFile = File(
      p.join(exportsDir.path, backupFileName(DateTime.now())),
    );
    return exportFile.writeAsBytes(zipBytes, flush: true);
  }

  Future<void> restoreFromZip(
    String zipPath, {
    required Future<void> Function() closeDatabase,
  }) async {
    final zipFile = File(zipPath);
    if (!await zipFile.exists()) {
      throw FileSystemException('Backup zip not found', zipPath);
    }

    final archive = ZipDecoder().decodeBytes(await zipFile.readAsBytes());
    final dbEntry = archive.files.where((file) => file.name == databaseFileName);
    if (dbEntry.isEmpty) {
      throw StateError('Backup zip does not include database file');
    }

    final appDir = await appDirectoryProvider();
    final destinationDb = File(p.join(appDir.path, databaseFileName));
    final destinationImages = Directory(p.join(appDir.path, imagesFolderName));

    await closeDatabase();

    if (await destinationDb.exists()) {
      await destinationDb.delete();
    }
    if (await destinationImages.exists()) {
      await destinationImages.delete(recursive: true);
    }
    await destinationImages.create(recursive: true);

    for (final file in archive.files) {
      if (!file.isFile) {
        continue;
      }

      final normalizedName = _normalizeEntryPath(file.name);
      final data = _fileBytes(file);
      if (normalizedName == databaseFileName) {
        await destinationDb.writeAsBytes(data, flush: true);
        continue;
      }

      if (!normalizedName.startsWith('$imagesFolderName/')) {
        continue;
      }

      final relativePath = normalizedName.substring(imagesFolderName.length + 1);
      if (relativePath.isEmpty) {
        continue;
      }

      final outputFile = File(p.join(destinationImages.path, relativePath));
      await outputFile.parent.create(recursive: true);
      await outputFile.writeAsBytes(data, flush: true);
    }
  }

  Future<void> restoreFromSqlite(
    String sqlitePath, {
    required Future<void> Function() closeDatabase,
  }) async {
    final sqliteFile = File(sqlitePath);
    if (!await sqliteFile.exists()) {
      throw FileSystemException('Backup sqlite file not found', sqlitePath);
    }

    final appDir = await appDirectoryProvider();
    final destinationDb = File(p.join(appDir.path, databaseFileName));

    await closeDatabase();

    if (await destinationDb.exists()) {
      await destinationDb.delete();
    }
    await sqliteFile.copy(destinationDb.path);
  }

  BackupImportType detectImportType(String path) {
    final extension = p.extension(path).toLowerCase();
    if (extension == '.zip') {
      return BackupImportType.full;
    }
    if (extension == '.sqlite' || extension == '.db') {
      return BackupImportType.dataOnly;
    }
    throw StateError('Unsupported backup file type: $path');
  }

  Uint8List _fileBytes(ArchiveFile file) {
    final content = file.content as List<int>;
    return content is Uint8List ? content : Uint8List.fromList(content);
  }

  String _normalizeEntryPath(String input) {
    final normalized = p.posix.normalize(input.replaceAll('\\', '/'));
    if (normalized.startsWith('/') || normalized.startsWith('../')) {
      throw StateError('Unsafe backup entry path: $input');
    }
    return normalized;
  }

  String _timestamp(DateTime dateTime) {
    final year = dateTime.year.toString().padLeft(4, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$year$month${day}_$hour$minute$second';
  }

  String backupFileName(DateTime dateTime) {
    return 'ssa_backup_${_timestamp(dateTime)}.zip';
  }

  String dataOnlyBackupFileName(DateTime dateTime) {
    return 'ssa_data_only_${_timestamp(dateTime)}.sqlite';
  }
}
