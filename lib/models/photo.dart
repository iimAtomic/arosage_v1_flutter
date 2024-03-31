class Photo {
  final String imageUrl;

  Photo({required this.imageUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      imageUrl: json['imageUrl'] as String,
    );
  }
}
