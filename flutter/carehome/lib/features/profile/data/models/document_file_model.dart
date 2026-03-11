import '../../domain/entities/document_file_entity.dart';

class DocumentFileModel extends DocumentFileEntity {
  const DocumentFileModel({
    required super.id,
    required super.fileName,
    required super.url,
  });

  factory DocumentFileModel.fromMap(Map<String, dynamic> map) {
    return DocumentFileModel(
      id: map['id'] ?? '',
      fileName: map['fileName'] ?? '',
      url: map['url'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'fileName': fileName, 'url': url};
  }
}
