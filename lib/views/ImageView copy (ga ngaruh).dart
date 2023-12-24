import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import '../views/favorite.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;

  const ImageView({Key? key, required this.imgUrl}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  Future<bool?> _isFavorite() async {
    List<String> favoriteImages = await FavoriteManager.getFavoriteImages();
    return favoriteImages.contains(widget.imgUrl);
  }

  Future<void> _toggleFavorite() async {
    if (await _isFavorite() ?? false) {
      await FavoriteManager.removeFavoriteImage(widget.imgUrl);
      _showToast('Removed from Favorites', Colors.red);
    } else {
      await FavoriteManager.addFavoriteImage(widget.imgUrl);
      _showToast('Added to Favorites', Colors.green);
    }
    setState(() {});
  }

  Widget _buildFavoriteIcon() {
    return FutureBuilder<bool?>(
      future: _isFavorite(),
      builder: (context, snapshot) {
        bool isFavorite = snapshot.data ?? false;
        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            size: 50,
            color: Colors.white,
          ),
          onPressed: _toggleFavorite,
        );
      },
    );
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }

  Future<void> _saveImage() async {
    await _requestStoragePermission();
    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    if (result == false) {
      Fluttertoast.showToast(
        msg: 'Fail to save image',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Image Saved to Gallery',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _requestStoragePermission() async {
    var status = await Permission.storage.request();
    if (status.isDenied) {
      Fluttertoast.showToast(
        msg: 'Storage permission is required to save the image.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _showApplyWallpaperDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Apply Wallpaper'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _setWallpaper(WallpaperManager.LOCK_SCREEN);
                  },
                  child: const Text('Set as Lock Screen Wallpaper'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  onTap: () {
                    _setWallpaper(WallpaperManager.HOME_SCREEN);
                  },
                  child: const Text('Set as Home Screen Wallpaper'),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  onTap: () {
                    _setWallpaper(WallpaperManager.BOTH_SCREEN);
                  },
                  child: const Text('Set as Both Screen Wallpaper'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _setWallpaper(int location) async {
    await _requestStoragePermission();
    var file = await DefaultCacheManager().getSingleFile(widget.imgUrl);
    final result =
        await WallpaperManager.setWallpaperFromFile(file.path, location);
    if (result) {
      Fluttertoast.showToast(
        msg: 'Wallpaper is Applied',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Fail to set image as wallpaper',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image View'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: CachedNetworkImage(
              imageUrl: widget.imgUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  color: Colors.black54,
                  child: _buildFavoriteIcon(),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 70,
                  width: 70,
                  color: Colors.black54,
                  child: IconButton(
                    onPressed: () {
                      _saveImage();
                    },
                    icon: const Icon(
                      Icons.download,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                  height: 70,
                  width: 70,
                  color: Colors.black54,
                  child: IconButton(
                    onPressed: () {
                      _showApplyWallpaperDialog();
                    },
                    icon: const Icon(
                      Icons.crop_free_rounded,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
