import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/utils/image_picker_helper.dart';
import '../../domain/entities/document_file_entity.dart';

class PswDocumentItemCard extends StatefulWidget {
  final String title;
  final String documentType;
  final bool isOptional;
  final DocumentFileEntity? document;
  final Function(String filePath, String documentType)? onUpload;
  final VoidCallback? onView;

  const PswDocumentItemCard({
    super.key,
    required this.title,
    required this.documentType,
    this.isOptional = false,
    this.document,
    this.onUpload,
    this.onView,
  });

  @override
  State<PswDocumentItemCard> createState() => _PswDocumentItemCardState();
}

class _PswDocumentItemCardState extends State<PswDocumentItemCard> {
  bool _isUploading = false;

  bool get _hasDocument => widget.document != null;

  Future<void> _pickAndUpload(ImageSource source) async {
    final path = await ImagePickerHelper.pick(context, source);
    if (path != null && widget.onUpload != null) {
      setState(() => _isUploading = true);
      await widget.onUpload!(path, widget.documentType);
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showPickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _hasDocument
                    ? 'Update ${widget.title}'
                    : 'Upload ${widget.title}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUpload(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndUpload(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _hasDocument ? Colors.green.shade200 : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: _hasDocument
                    ? Colors.green.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: _isUploading
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: TColors.primary,
                      ),
                    )
                  : Icon(
                      _hasDocument ? Icons.description : Icons.upload_file,
                      color: _hasDocument ? Colors.green : Colors.grey,
                      size: 22,
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Optional',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  if (_hasDocument)
                    Text(
                      widget.document!.fileName,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.green.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  else
                    Text(
                      'Not uploaded yet',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (_hasDocument) ...[
              InkWell(
                onTap: widget.onView,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: TColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.visibility,
                    size: 16,
                    color: TColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 6),
            ],
            InkWell(
              onTap: _isUploading ? null : _showPickerBottomSheet,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _hasDocument
                      ? Colors.orange.withOpacity(0.08)
                      : TColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _hasDocument ? Icons.edit : Icons.upload,
                  size: 16,
                  color: _hasDocument ? Colors.orange : TColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
