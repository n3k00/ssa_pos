import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:ssa/core/backup/local_backup_service.dart';

void main() {
  test('exports zip and restores database with images', () async {
    final appDir = await Directory.systemTemp.createTemp('ssa_backup_test_app_');
    final tempDir = await Directory.systemTemp.createTemp('ssa_backup_test_tmp_');
    addTearDown(() => appDir.delete(recursive: true));
    addTearDown(() => tempDir.delete(recursive: true));

    final dbFile = File(p.join(appDir.path, 'ssa_pos.sqlite'));
    await dbFile.writeAsString('db-v1');

    final imagesDir = Directory(p.join(appDir.path, 'voucher_images'));
    await imagesDir.create(recursive: true);
    final imageFile = File(p.join(imagesDir.path, 'img.txt'));
    await imageFile.writeAsString('image-v1');

    final service = LocalBackupService(
      appDirectoryProvider: () async => appDir,
      temporaryDirectoryProvider: () async => tempDir,
    );

    final zipBytes = await service.exportBackupZipBytes();
    final archive = ZipDecoder().decodeBytes(zipBytes);
    final entryNames = archive.files.map((file) => file.name).toSet();
    expect(entryNames, contains('ssa_pos.sqlite'));
    expect(entryNames, contains('voucher_images/img.txt'));

    final exportFile = File(p.join(tempDir.path, 'backup.zip'));
    await exportFile.writeAsBytes(zipBytes, flush: true);

    await dbFile.writeAsString('db-v2');
    await imageFile.writeAsString('image-v2');

    var closeCalled = false;
    await service.restoreFromZip(
      exportFile.path,
      closeDatabase: () async {
        closeCalled = true;
      },
    );

    expect(closeCalled, isTrue);
    expect(await dbFile.readAsString(), 'db-v1');
    expect(await imageFile.readAsString(), 'image-v1');
  });

  test('exports and restores data-only sqlite without replacing images', () async {
    final appDir = await Directory.systemTemp.createTemp(
      'ssa_backup_sqlite_test_app_',
    );
    final tempDir = await Directory.systemTemp.createTemp(
      'ssa_backup_sqlite_test_tmp_',
    );
    addTearDown(() => appDir.delete(recursive: true));
    addTearDown(() => tempDir.delete(recursive: true));

    final dbFile = File(p.join(appDir.path, 'ssa_pos.sqlite'));
    await dbFile.writeAsString('db-v1');

    final imagesDir = Directory(p.join(appDir.path, 'voucher_images'));
    await imagesDir.create(recursive: true);
    final imageFile = File(p.join(imagesDir.path, 'img.txt'));
    await imageFile.writeAsString('image-v1');

    final service = LocalBackupService(
      appDirectoryProvider: () async => appDir,
      temporaryDirectoryProvider: () async => tempDir,
    );

    final sqliteBytes = await service.exportDataOnlyBackupBytes();
    final exportFile = File(p.join(tempDir.path, 'backup.sqlite'));
    await exportFile.writeAsBytes(sqliteBytes, flush: true);

    await dbFile.writeAsString('db-v2');
    await imageFile.writeAsString('image-v2');

    var closeCalled = false;
    await service.restoreFromSqlite(
      exportFile.path,
      closeDatabase: () async {
        closeCalled = true;
      },
    );

    expect(closeCalled, isTrue);
    expect(await dbFile.readAsString(), 'db-v1');
    expect(await imageFile.readAsString(), 'image-v2');
    expect(service.detectImportType(exportFile.path), BackupImportType.dataOnly);
  });
}
