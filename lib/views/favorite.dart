import 'package:shared_preferences/shared_preferences.dart';

class FavoriteManager {
  static const String _keyFavoriteImages = 'favorite_images';

  static Future<List<String>> getFavoriteImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteImages = prefs.getStringList(_keyFavoriteImages);
    return favoriteImages ?? [];
  }

  static Future<void> addFavoriteImage(String imageId) async {
    List<String> favoriteImages = await getFavoriteImages();
    favoriteImages.add(imageId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_keyFavoriteImages, favoriteImages);
  }

  static Future<void> removeFavoriteImage(String imageId) async {
    List<String> favoriteImages = await getFavoriteImages();
    favoriteImages.remove(imageId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(_keyFavoriteImages, favoriteImages);
  }

  static Future<void> clearFavoriteImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyFavoriteImages);
  }
}
