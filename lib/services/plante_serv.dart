// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../models/plante.dart';
// import '../models/photo.dart';
// import '../models/conseil.dart';

// class ApiService {
//   final String baseUrl = 'http://votre-backend.com/api/plante/v2';

//   Future<List<Plante>> fetchPlantes() async {
//     final response = await http.get(Uri.parse('$baseUrl/plantes'));

//     if (response.statusCode == 200) {
//       List<dynamic> body = jsonDecode(response.body);
//       List<Plante> plantes = body.map((dynamic item) => Plante.fromJson(item)).toList();
//       return plantes;
//     } else {
//       throw Exception('Failed to load plantes');
//     }
//   }

//   Future<bool> addPlante(String pseudo, String userPwd, String nom, String desc, String filePath) async {
//     var uri = Uri.parse('$baseUrl/add');
//     var request = http.MultipartRequest('POST', uri)
//       ..fields['pseudo'] = pseudo
//       ..fields['userPwd'] = userPwd
//       ..fields['nom'] = nom
//       ..fields['desc'] = desc
//       ..files.add(await http.MultipartFile.fromPath('file', filePath));

//     var response = await request.send();

//     return response.statusCode == 200;
//   }

//   Future<List<Photo>> fetchPhotos(int planteId) async {
//     final response = await http.get(Uri.parse('$baseUrl/images?planteId=$planteId'));

//     if (response.statusCode == 200) {
//       List<dynamic> body = jsonDecode(response.body);
//       List<Photo> photos = body.map((dynamic item) => Photo.fromJson(item)).toList();
//       return photos;
//     } else {
//       throw Exception('Failed to load photos');
//     }
//   }

//   Future<List<Conseil>> fetchConseils(int planteId) async {
//     final response = await http.get(Uri.parse('$baseUrl/conseils?planteId=$planteId'));

//     if (response.statusCode == 200) {
//       List<dynamic> body = jsonDecode(response.body);
//       List<Conseil> conseils = body.map((dynamic item) => Conseil.fromJson(item)).toList();
//       return conseils;
//     } else {
//       throw Exception('Failed to load conseils');
//     }
//   }
// }
