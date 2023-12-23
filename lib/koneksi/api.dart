import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpHelper {
  Future<List<WallpaperModel>> getpics(int page) async {
    try {
      final response = await http.get(
        Uri.parse('https://uas.medeon.my.id/api/get?page=$page'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => WallpaperModel.fromJson(json)).toList();
      } else {
        // Tangani situasi ketika tidak ada data atau kesalahan lain
        return [];
      }
    } catch (e) {
      // Tangani exception jaringan atau lainnya
      return [];
    }
  }

  Future<List<WallpaperModel>> getCategoryPics(String category) async {
    try {
      final response = await http.get(
        Uri.parse('https://uas.medeon.my.id/api/get?category=$category'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        List<WallpaperModel> wallpapers = data
            .map((json) => WallpaperModel.fromJson(json))
            .where((wallpaper) {
          return wallpaper.category == category;
        }).toList();
        return wallpapers;
      } else {
        throw Exception('Failed to load category images');
      }
    } catch (e) {
      throw e;
    }
  }
}

class WallpaperModel {
  final String id;
  final String category;
  final String imageFileName;
  final String imageUrl;
  final String imageDown;
  final String createdAt;
  final String updatedAt;

  WallpaperModel({
    required this.id,
    required this.category,
    required this.imageFileName,
    required this.imageUrl,
    required this.imageDown,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'],
      category: json['category'],
      imageFileName: json['image_file_name'],
      imageUrl: json['image_url'],
      imageDown: json['image_download'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
