// photo.dart
class Photo {
  final String name;
  final String type;
  final int size;
  final String data; 

  Photo({required this.name, required this.type, required this.size, required this.data});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      name: json['name'],
      type: json['type'],
      size: json['size'],
      data: json['data'],
    );
  }
}
