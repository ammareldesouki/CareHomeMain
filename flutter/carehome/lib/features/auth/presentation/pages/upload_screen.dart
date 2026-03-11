import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../layout/bottom_navegation_bar.dart';
import '../../../../core/utils/image_picker_helper.dart';

class UploadIdScreen extends StatefulWidget {
  const UploadIdScreen({super.key});

  @override
  State<UploadIdScreen> createState() => _UploadIdScreenState();
}

class _UploadIdScreenState extends State<UploadIdScreen> {
  File? frontId;
  File? backId;

  Future<void> _pickImage(bool isFront, ImageSource source) async {
    final path = await ImagePickerHelper.pick(context, source);
    if (path != null) {
      setState(() {
        isFront ? frontId = File(path) : backId = File(path);
      });
    }
  }

  /// ⬆ Upload box UI
  Widget _uploadBox({
    required String title,
    required File? file,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: file == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.upload, size: 32, color: Colors.blue),
                        SizedBox(height: 8),
                        Text('Drop file here or'),
                        Text('browse', style: TextStyle(color: Colors.blue)),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.image, size: 32, color: Colors.green),
                        const SizedBox(height: 8),
                        Text(
                          file.path.split('/').last,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }

  /// 📂 Bottom sheet
  void _showPicker(bool isFront) {
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
                _pickImage(isFront, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(isFront, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: const Text('Relief')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Your ID',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please upload clear photos of both sides of your government-issued ID',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            _uploadBox(
              title: 'Front of ID',
              file: frontId,
              onTap: () => _showPicker(true),
            ),

            const SizedBox(height: 20),

            _uploadBox(
              title: 'Back of ID',
              file: backId,
              onTap: () => _showPicker(false),
            ),

            const SizedBox(height: 12),

            const Text(
              'Supports: JPG, PNG (Max 5MB per file)',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: frontId != null && backId != null
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const CBottomNavigationBar(role: 'PSW'),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Continue'),
            ),

            const SizedBox(height: 12),

            const Center(
              child: Text(
                'Step 1 of 2 - PSW Verification',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
