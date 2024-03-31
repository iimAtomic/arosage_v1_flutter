class Plante {
  final int id;
  final String nom;
  final String description;

  Plante({required this.id, required this.nom, required this.description});

  factory Plante.fromJson(Map<String, dynamic> json) {
    return Plante(
      id: json['id'] as int,
      nom: json['nom'] as String,
      description: json['description'] as String,
    );
  }
}
