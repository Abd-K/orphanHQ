import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  /// Select an existing photo from gallery/files
  static Future<File?> selectPhoto() async {
    print('DEBUG: ImageService.selectPhoto() started');
    try {
      print('DEBUG: Calling FilePicker.pickFiles');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      print('DEBUG: FilePicker returned: ${result?.files.first.path}');

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        print('DEBUG: Returning file: ${file.path}');
        return file;
      }
      print('DEBUG: No image selected, returning null');
      return null;
    } catch (e) {
      print('DEBUG: Error in selectPhoto: $e');
      print('Error selecting photo: $e');
      return null;
    }
  }

  /// Select multiple existing photos from gallery/files
  static Future<List<File>> selectMultiplePhotos() async {
    try {
      print('DEBUG: Calling FilePicker.pickFiles for multiple');
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      print('DEBUG: FilePicker returned ${result?.files.length ?? 0} files');

      if (result != null && result.files.isNotEmpty) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error selecting multiple photos: $e');
      return [];
    }
  }

  /// Save document photo to local storage and return the saved path
  static Future<String?> saveDocumentPhoto(
      File imageFile, String orphanId) async {
    try {
      // Get the application documents directory
      final Directory appDir = await getApplicationDocumentsDirectory();

      // Create orphan documents directory if it doesn't exist
      final Directory orphanDocsDir =
          Directory(path.join(appDir.path, 'orphan_documents'));
      if (!await orphanDocsDir.exists()) {
        await orphanDocsDir.create(recursive: true);
      }

      // Generate unique filename with timestamp
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String extension = path.extension(imageFile.path);
      final String fileName = '${orphanId}_doc_$timestamp$extension';
      final String savedPath = path.join(orphanDocsDir.path, fileName);

      // Copy the image to the new location
      final File savedFile = await imageFile.copy(savedPath);

      return savedFile.path;
    } catch (e) {
      print('Error saving document photo: $e');
      return null;
    }
  }

  /// Delete document photo from local storage
  static Future<bool> deleteDocumentPhoto(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      if (await imageFile.exists()) {
        await imageFile.delete();
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting document photo: $e');
      return false;
    }
  }

  /// Check if document photo exists at given path
  static Future<bool> documentPhotoExists(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      return await imageFile.exists();
    } catch (e) {
      return false;
    }
  }

  /// Get document photo file from path
  static File? getDocumentPhotoFile(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return null;
    return File(imagePath);
  }
}
