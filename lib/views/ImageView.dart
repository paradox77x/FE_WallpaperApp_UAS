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
import 'dart:ui';

class ImageView extends StatefulWidget {
  final String imgUrl;

  const ImageView({Key? key, required this.imgUrl}) : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _BlurredImage extends StatelessWidget {
  final String imgUrl;

  const _BlurredImage({Key? key, required this.imgUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: imgUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmolImage extends StatelessWidget {
  final String imgUrl;

  _SmolImage({required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          // BorderRadius.circular(10), // Set the border radius
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height / 1.35,
          width: MediaQuery.of(context).size.width / 1.35,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 2.0,
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: imgUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
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
    return GestureDetector(
      onTap: () {
        _toggleFavorite();
      },
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
          border: Border.all(
            color: Colors.white,
            width: 1.0,
          ),
          // color: Colors.black54.withOpacity(0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<bool?>(
              future: _isFavorite(),
              builder: (context, snapshot) {
                bool isFavorite = snapshot.data ?? false;
                return Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                  color: Colors.white,
                );
              },
            ),
            const SizedBox(width: 8),
            Text(
              "Favorite",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadIcon() {
    return GestureDetector(
      onTap: () {
        _saveImage();
      },
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(5),
              topRight: Radius.circular(5),
              bottomLeft: Radius.circular(5),
              topLeft: Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.download,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              "Download",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetAsIcon() {
    return GestureDetector(
      onTap: () {
        _showApplyWallpaperDialog();
      },
      child: Container(
        height: 40,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40),
            topRight: Radius.circular(40),
            bottomLeft: Radius.circular(9),
            topLeft: Radius.circular(9),
          ),
          border: Border.all(color: Colors.white, width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.crop_free_rounded,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(width: 8),
            Text(
              "Set As",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // title: const Text('Image View'),
        backgroundColor: Colors.black.withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
      ),
      body: Container(
        child: Stack(
          children: <Widget>[
            _BlurredImage(imgUrl: widget.imgUrl),
            _SmolImage(imgUrl: widget.imgUrl),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 85,
                color: Colors.black.withOpacity(
                    0.3), // Set the background color for the entire row
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: _buildFavoriteIcon(),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: _buildDownloadIcon(),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(child: _buildSetAsIcon()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
