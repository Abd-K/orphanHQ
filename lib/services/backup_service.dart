import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:file_picker/file_picker.dart';
import '../database.dart';

class BackupService {
  static final AppDb _database = AppDb();

  /// Creates a complete backup including database and all files
  /// Returns the path to the created backup file
  static Future<String?> createBackup({
    String? customPath,
    Function(String)? onProgress,
  }) async {
    try {
      onProgress?.call('Starting backup...');

      // Get application documents directory
      final appDir = await getApplicationDocumentsDirectory();
      final timestamp =
          DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0];

      // Determine backup location
      String backupPath;
      if (customPath != null) {
        backupPath = p.join(customPath, 'orphan_backup_$timestamp.obk');
      } else {
        final backupsDir = Directory(p.join(appDir.path, 'backups'));
        if (!await backupsDir.exists()) {
          await backupsDir.create(recursive: true);
        }
        backupPath = p.join(backupsDir.path, 'orphan_backup_$timestamp.obk');
      }

      onProgress?.call('Preparing backup archive...');

      // Create ZIP archive
      final archive = Archive();

      // 1. Add database file
      onProgress?.call('Backing up database...');
      final dbFile = File(p.join(appDir.path, 'db.sqlite'));
      if (await dbFile.exists()) {
        final dbBytes = await dbFile.readAsBytes();
        final dbArchiveFile = ArchiveFile('db.sqlite', dbBytes.length, dbBytes);
        archive.addFile(dbArchiveFile);
      } else {
        throw Exception('Database file not found');
      }

      // 2. Add orphan documents directory
      onProgress?.call('Backing up orphan documents...');
      final documentsDir = Directory(p.join(appDir.path, 'orphan_documents'));
      if (await documentsDir.exists()) {
        await _addDirectoryToArchive(archive, documentsDir, 'orphan_documents');
      }

      // 3. Add orphan photos directory
      onProgress?.call('Backing up orphan photos...');
      final photosDir = Directory(p.join(appDir.path, 'orphan_photos'));
      if (await photosDir.exists()) {
        await _addDirectoryToArchive(archive, photosDir, 'orphan_photos');
      }

      // 4. Add metadata file
      onProgress?.call('Adding backup metadata...');
      final metadata = {
        'backup_version': '1.0',
        'created_at': DateTime.now().toIso8601String(),
        'app_version': '1.0.0', // You can get this from pubspec.yaml
        'database_schema_version': '6',
        'total_files': archive.length,
      };

      final metadataJson = _mapToJsonString(metadata);
      final metadataFile = ArchiveFile(
          'backup_metadata.json', metadataJson.length, metadataJson.codeUnits);
      archive.addFile(metadataFile);

      // 5. Create the backup file
      onProgress?.call('Finalizing backup...');
      final zipEncoder = ZipEncoder();
      final zipBytes = zipEncoder.encode(archive);

      if (zipBytes != null) {
        final backupFile = File(backupPath);
        await backupFile.writeAsBytes(zipBytes);
        onProgress?.call('Backup completed successfully!');
        return backupPath;
      } else {
        throw Exception('Failed to create backup archive');
      }
    } catch (e) {
      onProgress?.call('Backup failed: $e');
      print('Backup error: $e');
      return null;
    }
  }

  /// Restores a backup from the specified file
  /// Returns true if successful
  static Future<bool> restoreBackup(
    String backupFilePath, {
    Function(String)? onProgress,
  }) async {
    try {
      onProgress?.call('Starting restore...');

      final backupFile = File(backupFilePath);
      if (!await backupFile.exists()) {
        throw Exception('Backup file not found');
      }

      // Get application documents directory
      final appDir = await getApplicationDocumentsDirectory();

      onProgress?.call('Reading backup file...');
      final zipBytes = await backupFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(zipBytes);

      // Create backup of current data before restore
      onProgress?.call('Creating safety backup of current data...');
      final currentBackupPath = await createBackup(
        customPath: p.join(appDir.path, 'safety_backups'),
      );

      if (currentBackupPath != null) {
        print('Created safety backup at: $currentBackupPath');
      }

      // Close database connection before replacing files
      onProgress?.call('Preparing database...');
      await _database.close();

      // Restore files from archive
      for (final file in archive) {
        if (file.isFile) {
          final filePath = p.join(appDir.path, file.name);

          onProgress?.call('Restoring ${file.name}...');

          // Create directory if needed
          final fileDir = Directory(p.dirname(filePath));
          if (!await fileDir.exists()) {
            await fileDir.create(recursive: true);
          }

          // Write file
          final outputFile = File(filePath);
          await outputFile.writeAsBytes(file.content as List<int>);
        }
      }

      onProgress?.call('Restore completed successfully!');
      return true;
    } catch (e) {
      onProgress?.call('Restore failed: $e');
      print('Restore error: $e');
      return false;
    }
  }

  /// Allows user to select backup location and creates backup
  static Future<String?> exportBackup({
    Function(String)? onProgress,
  }) async {
    try {
      // Let user choose save location
      final result = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup File',
        fileName:
            'orphan_backup_${DateTime.now().toIso8601String().replaceAll(':', '-').split('.')[0]}.obk',
        type: FileType.custom,
        allowedExtensions: ['obk'],
      );

      if (result != null) {
        return await createBackup(
          customPath: p.dirname(result),
          onProgress: onProgress,
        );
      }
      return null;
    } catch (e) {
      onProgress?.call('Export failed: $e');
      return null;
    }
  }

  /// Allows user to select backup file and restores it
  static Future<bool> importBackup({
    Function(String)? onProgress,
  }) async {
    try {
      // Let user choose backup file
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Select Backup File',
        type: FileType.custom,
        allowedExtensions: ['obk'],
      );

      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.first.path!;
        return await restoreBackup(filePath, onProgress: onProgress);
      }
      return false;
    } catch (e) {
      onProgress?.call('Import failed: $e');
      return false;
    }
  }

  /// Lists all automatic backups
  static Future<List<BackupInfo>> listBackups() async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final backupsDir = Directory(p.join(appDir.path, 'backups'));

      if (!await backupsDir.exists()) {
        return [];
      }

      final backupFiles = await backupsDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.obk'))
          .cast<File>()
          .toList();

      final backupInfos = <BackupInfo>[];
      for (final file in backupFiles) {
        final stat = await file.stat();
        final info = BackupInfo(
          path: file.path,
          name: p.basename(file.path),
          size: stat.size,
          createdAt: stat.modified,
        );
        backupInfos.add(info);
      }

      // Sort by creation date (newest first)
      backupInfos.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return backupInfos;
    } catch (e) {
      print('Error listing backups: $e');
      return [];
    }
  }

  /// Deletes a backup file
  static Future<bool> deleteBackup(String backupPath) async {
    try {
      final file = File(backupPath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting backup: $e');
      return false;
    }
  }

  /// Gets backup file information including metadata
  static Future<BackupMetadata?> getBackupMetadata(
      String backupFilePath) async {
    try {
      final backupFile = File(backupFilePath);
      if (!await backupFile.exists()) return null;

      final zipBytes = await backupFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(zipBytes);

      // Find metadata file
      final metadataFile = archive.files.firstWhere(
        (file) => file.name == 'backup_metadata.json',
        orElse: () => throw Exception('Metadata not found'),
      );

      final metadataJson =
          String.fromCharCodes(metadataFile.content as List<int>);
      final metadata = _parseJsonString(metadataJson);

      return BackupMetadata(
        version: metadata['backup_version'] ?? '1.0',
        createdAt: DateTime.parse(metadata['created_at']),
        appVersion: metadata['app_version'] ?? 'Unknown',
        schemaVersion: metadata['database_schema_version'] ?? 'Unknown',
        totalFiles: metadata['total_files'] ?? 0,
      );
    } catch (e) {
      print('Error reading backup metadata: $e');
      return null;
    }
  }

  // Helper method to add directory contents to archive
  static Future<void> _addDirectoryToArchive(
    Archive archive,
    Directory dir,
    String archivePath,
  ) async {
    await for (final entity in dir.list(recursive: true)) {
      if (entity is File) {
        final relativePath = p.relative(entity.path, from: dir.parent.path);
        final fileBytes = await entity.readAsBytes();
        final archiveFile =
            ArchiveFile(relativePath, fileBytes.length, fileBytes);
        archive.addFile(archiveFile);
      }
    }
  }

  // Simple JSON serialization for metadata
  static String _mapToJsonString(Map<String, dynamic> map) {
    final buffer = StringBuffer('{');
    final entries = map.entries.toList();
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      buffer.write('"${entry.key}":');
      if (entry.value is String) {
        buffer.write('"${entry.value}"');
      } else {
        buffer.write('${entry.value}');
      }
      if (i < entries.length - 1) buffer.write(',');
    }
    buffer.write('}');
    return buffer.toString();
  }

  // Simple JSON parsing for metadata
  static Map<String, dynamic> _parseJsonString(String json) {
    final result = <String, dynamic>{};
    final clean = json.replaceAll(RegExp(r'[{}]'), '');
    final pairs = clean.split(',');

    for (final pair in pairs) {
      final parts = pair.split(':');
      if (parts.length == 2) {
        final key = parts[0].replaceAll('"', '').trim();
        var value = parts[1].trim();

        if (value.startsWith('"') && value.endsWith('"')) {
          value = value.substring(1, value.length - 1);
        } else if (RegExp(r'^\d+$').hasMatch(value)) {
          result[key] = int.parse(value);
          continue;
        }

        result[key] = value;
      }
    }
    return result;
  }
}

/// Information about a backup file
class BackupInfo {
  final String path;
  final String name;
  final int size;
  final DateTime createdAt;

  BackupInfo({
    required this.path,
    required this.name,
    required this.size,
    required this.createdAt,
  });

  String get formattedSize {
    if (size < 1024) return '${size} B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    if (size < 1024 * 1024 * 1024)
      return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(size / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// Metadata about a backup
class BackupMetadata {
  final String version;
  final DateTime createdAt;
  final String appVersion;
  final String schemaVersion;
  final int totalFiles;

  BackupMetadata({
    required this.version,
    required this.createdAt,
    required this.appVersion,
    required this.schemaVersion,
    required this.totalFiles,
  });
}
