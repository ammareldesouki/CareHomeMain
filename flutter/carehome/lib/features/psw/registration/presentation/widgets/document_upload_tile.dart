import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../core/constants/colors.dart';

class DocumentUploadTile extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool isOptional;
  final String? filePath;
  final ValueChanged<String> onFileSelected;
  final VoidCallback? onRemove;

  const DocumentUploadTile({
    super.key,
    required this.title,
    this.subtitle,
    this.isOptional = false,
    this.filePath,
    required this.onFileSelected,
    this.onRemove,
  });

  @override
  State<DocumentUploadTile> createState() => _DocumentUploadTileState();
}

class _DocumentUploadTileState extends State<DocumentUploadTile> {
  final ImagePicker _picker = ImagePicker();

  Future<bool> _requestPermission(ImageSource source) async {
    Permission permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final status = await permission.request();
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    return false;
  }

  Future<void> _pickFile(ImageSource source) async {
    final allowed = await _requestPermission(source);
    if (!allowed) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      widget.onFileSelected(image.path);
    }
  }

  void _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.pop(context);
                _pickFile(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickFile(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasFile = widget.filePath != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasFile ? Colors.green.shade300 : Colors.grey.shade300,
          width: 1.5,
        ),
        color: hasFile ? Colors.green.shade50 : Colors.white,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: hasFile
                ? Colors.green.withOpacity(0.1)
                : TColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            hasFile ? Icons.check_circle : Icons.upload_file,
            color: hasFile ? Colors.green : TColors.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            if (widget.isOptional)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Optional',
                  style: TextStyle(fontSize: 10, color: Colors.orange),
                ),
              ),
          ],
        ),
        subtitle: hasFile
            ? Text(
                widget.filePath!.split('/').last,
                style: TextStyle(color: Colors.green.shade700, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                widget.subtitle ?? 'Tap to upload',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
        trailing: hasFile
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.red, size: 20),
                onPressed: widget.onRemove,
              )
            : Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
        onTap: _showPicker,
      ),
    );
  }
}
