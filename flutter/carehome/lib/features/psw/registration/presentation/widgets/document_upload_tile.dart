import 'package:flutter/material.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/image_picker_helper.dart';

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
  Future<void> _showPicker() async {
    final path = await ImagePickerHelper.showPickerSheet(context);
    if (path != null) widget.onFileSelected(path);
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
                : TColors.blue.withOpacity(0.1),
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
