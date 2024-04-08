class Plante {
  final String nom;
  final String description;
  final String imageUrl; // Assurez-vous que c'est l'URL de l'image ou le chemin pour le récupérer.

  Plante({required this.nom, required this.description, required this.imageUrl});

  factory Plante.fromJson(Map<String, dynamic> json) {
    return Plante(
      nom: json['nom'],
      description: json['description'],
      imageUrl: json['imageUrl'], // Assurez-vous que ce champ correspond à votre structure JSON.
    );
  }
}
