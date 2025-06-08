class FileItem {
  final String id;
  final String name;
  final String owner;
  final String size;
  final String date;
  final String type;
  final String? downloadUrl;

  FileItem({
    required this.id,
    required this.name,
    required this.owner,
    required this.size,
    required this.date,
    required this.type,
    this.downloadUrl,
  });

  factory FileItem.fromJson(Map<String, dynamic> json) {
    return FileItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      owner: json['owner'] ?? '',
      size: json['size'] ?? '',
      date: json['date'] ?? '',
      type: json['type'] ?? '',
      downloadUrl: json['downloadUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'owner': owner,
      'size': size,
      'date': date,
      'type': type,
      'downloadUrl': downloadUrl,
    };
  }
}
