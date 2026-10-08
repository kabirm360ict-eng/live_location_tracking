class SendFileModel {
  final String filePath;
  final String key;

  const SendFileModel({required this.filePath, required this.key});

  @override
  String toString() {
    return 'SendFileModel{filePath: $filePath, key: $key}';
  }
}
