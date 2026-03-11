class DocumentFileEntity {
  final String id;
  final String fileName;
  final String url;

  const DocumentFileEntity({
    required this.id,
    required this.fileName,
    required this.url,
  });

  String get fullUrl => 'http://3.99.158.214:5000/$url';
}
