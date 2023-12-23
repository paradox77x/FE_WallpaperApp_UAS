import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:uas_pemweb/homepage.dart';
import 'package:uas_pemweb/views/aboutus.dart';
import 'package:uas_pemweb/views/category_list.dart';
import 'favorite.dart';
import 'ImageView.dart';
import '../views/bottom_navigation.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  _FavoriteViewState createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  late Future<List<String>> _favoriteImages;
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;

        // Handle navigation based on the tapped index
        if (_selectedIndex == 0) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false,
          );
        } else if (_selectedIndex == 1) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CategoryList()),
            (route) => false,
          );
        } else if (_selectedIndex == 2) {
          // Favorite View
        } else if (_selectedIndex == 3) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AboutPage()),
            (route) => false,
          );
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _favoriteImages = FavoriteManager.getFavoriteImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Wallpapers'),
      ),
      body: FutureBuilder<List<String>>(
        future: _favoriteImages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No favorite wallpapers.'),
            );
          } else {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return _buildFavoriteImageCard(snapshot.data![index]);
              },
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildFavoriteImageCard(String imageUrl) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ImageView(
                imgUrl: imageUrl,
              ),
            ),
          );
        },
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
