import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class WallpaperModel {
  final String arturl;
  final int sensitivity;

  WallpaperModel({
    required this.arturl,
    required this.sensitivity,
  });

  factory WallpaperModel.fromMap(Map<String, dynamic> json) {
    return WallpaperModel(
      arturl: json["arturl"],
      sensitivity: json["sensitivity"],
    );
  }
}

class HttpHelper {
  Future<List<WallpaperModel>> getpics() async {
    int page = 20;

    final result = await http.get(
      Uri.https(
          'premium-anime-mobile-wallpapers-illustrations.p.rapidapi.com',
          '/rapidHandler/boy',
          {'page': '$page', 'sensitivity': '0', 'quality': '1'}),
      headers: {
        'X-RapidAPI-Key': '83e2da651dmsh599416407f986b6p1bd989jsn8fbd6568aac5',
        'X-RapidAPI-Host':
            'premium-anime-mobile-wallpapers-illustrations.p.rapidapi.com'
      },
    );
    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      List<WallpaperModel> callimage = jsonResponse
          .map<WallpaperModel>((i) => WallpaperModel.fromMap(i))
          .toList();
      return callimage;
    } else {
      return [];
    }
  }
}
