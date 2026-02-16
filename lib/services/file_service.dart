/// Service for file and image operations
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FileService {
  /// Pick a single image file
  static Future<String?> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: false,
      );

      if (result != null && result.files.isNotEmpty) {
        return result.files.single.path;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Check if image file exists
  static bool imageExists(String? path) {
    if (path == null || path.isEmpty) return false;
    try {
      return File(path).existsSync();
    } catch (_) {
      return false;
    }
  }

  /// Get image file size in MB
  static double getImageSizeInMB(String? path) {
    if (path == null || path.isEmpty) return 0;
    try {
      final bytes = File(path).lengthSync();
      return bytes / (1024 * 1024); // Convert to MB
    } catch (_) {
      return 0;
    }
  }

  /// Delete image file
  static bool deleteImage(String? path) {
    if (path == null || path.isEmpty) return false;
    try {
      File(path).deleteSync();
      return true;
    } catch (_) {
      return false;
    }
  }
}
