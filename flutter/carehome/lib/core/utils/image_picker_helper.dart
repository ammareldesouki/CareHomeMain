import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

/// Correct image/file-picking logic for iOS 14+ and Android.
///
/// Gallery  → NO manual permission check.
///            iOS 14+ uses PHPickerViewController which needs no permission.
///            Android: ImagePicker handles READ_MEDIA_IMAGES internally.
///
/// Camera   → Permission.camera is still required on both platforms.
///            Shows a dialog (not silent openAppSettings) when denied.
///
/// File     → Uses FilePicker (UIDocumentPickerViewController on iOS).
///            No permission required — user navigates the system file browser.
class ImagePickerHelper {
  static final _picker = ImagePicker();

  /// Pick an image from [source]. Returns the file path or null if cancelled.
  static Future<String?> pick(
      BuildContext context,
      ImageSource source, {
        int imageQuality = 80,
      }) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (context.mounted) _showCameraDenied(context, status.isPermanentlyDenied);
        return null;
      }
    }
    // Gallery: call directly — PHPickerViewController on iOS 14+ needs no
    // prior permission grant, so we never block the user.
    try {
      final file = await _picker.pickImage(
        source: source,
        imageQuality: imageQuality,
      );
      return file?.path;
    } catch (_) {
      return null;
    }
  }

  /// Pick any document file (PDF, DOC, DOCX, JPG, PNG).
  /// Opens the system file browser — no permission required.
  /// Returns the file path or null if cancelled.
  static Future<String?> pickFile(BuildContext context) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png', 'doc', 'docx'],
      );
      return result?.files.single.path;
    } catch (_) {
      return null;
    }
  }

  /// Show a bottom sheet offering Camera, Gallery, or File options.
  /// Returns the chosen file path or null if cancelled.
  static Future<String?> showPickerSheet(BuildContext context) async {
    // Use showModalBottomSheet<String?> so we can return the path via
    // Navigator.pop(sheetCtx, path) — this ensures the picked path is
    // available as soon as the sheet future resolves, avoiding the race
    // condition where pop() completes before the async pick() finishes.
    return showModalBottomSheet<String?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () async {
                // Pick FIRST, then close the sheet with the result.
                final path = await pick(context, ImageSource.camera);
                if (sheetCtx.mounted) Navigator.pop(sheetCtx, path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () async {
                final path = await pick(context, ImageSource.gallery);
                if (sheetCtx.mounted) Navigator.pop(sheetCtx, path);
              },
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file_outlined),
              title: const Text('Choose file (PDF, DOC)'),
              onTap: () async {
                final path = await pickFile(context);
                if (sheetCtx.mounted) Navigator.pop(sheetCtx, path);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  static void _showCameraDenied(BuildContext context, bool isPermanent) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.camera_alt, color: Colors.orange),
            SizedBox(width: 8),
            Text('Camera Access Required', style: TextStyle(fontSize: 16)),
          ],
        ),
        content: Text(
          isPermanent
              ? 'Camera access was permanently denied. Please enable it in Settings → Privacy → Camera.'
              : 'We need camera access to take a photo of your document.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          if (isPermanent)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A73E8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Open Settings'),
            ),
        ],
      ),
    );
  }
}