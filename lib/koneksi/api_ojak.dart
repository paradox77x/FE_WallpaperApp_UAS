// api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHelper {
  Future<List<WallpaperModel>> getpics() async {
    final response = await http.get(Uri.parse('http://206.189.47.152/api/get'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      print(data[0]);
      List<WallpaperModel> wallpapers =
          data.map((json) => WallpaperModel.fromJson(json)).toList();
      return wallpapers;
    } else {
      throw Exception('Failed to load data');
    }
  }
}

class WallpaperModel {
  final int id;
  final String category;
  final String imageFileName;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  WallpaperModel({
    required this.id,
    required this.category,
    required this.imageFileName,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'],
      category: json['category'],
      imageFileName: json['image_file_name'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
