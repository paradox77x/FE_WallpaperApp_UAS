import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../koneksi/api.dart';
import '../views/ImageView.dart';
import '../koneksi/category_data.dart';

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class CategoryImagePage extends StatefulWidget {
  final String category;

  const CategoryImagePage({Key? key, required this.category}) : super(key: key);

  @override
  State<CategoryImagePage> createState() => _CategoryImagePageState();
}

String findImagePathByParameter(String parameter) {
  BoxData? box = boxes.firstWhere(
    (element) => element.parameter.toLowerCase() == parameter.toLowerCase(),
  );

  return box.imagePath;
}

class imageBottom extends StatelessWidget {
  final Future<List<WallpaperModel>> future;

  imageBottom({required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder:
          (BuildContext context, AsyncSnapshot<List<WallpaperModel>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return buildLoadingGrid();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return buildErrorGrid();
          } else {
            return buildimageBottom(context, snapshot.data);
          }
        } else {
          return buildNoInternetConnection();
        }
      },
    );
  }

  Widget buildLoadingGrid() {
    return Shimmer.fromColors(
      enabled: true,
      baseColor: Colors.black54,
      highlightColor: Colors.black87,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 12,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.55,
          mainAxisSpacing: 6,
          crossAxisSpacing: 6,
        ),
        itemBuilder: (context, index) {
          return GridTile(
            child: Container(color: Colors.black38),
          );
        },
      ),
    );
  }

  Widget buildErrorGrid() {
    return const Center(
      child: Text(
        'Error loading images.',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black38,
        ),
      ),
    );
  }

  Widget buildimageBottom(BuildContext context, List<WallpaperModel>? data) {
    return GridView.builder(
      padding: EdgeInsets.only(left: 6, right: 6, top: 6),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: (data == null) ? 0 : data.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageView(
                    imgUrl: data![index].imageUrl,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: CachedNetworkImage(
                imageUrl: data![index].imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildNoInternetConnection() {
    return const Center(
      child: Text(
        'No Internet Connection',
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _CategoryImagePageState extends State<CategoryImagePage> {
  Future<List<WallpaperModel>> fetchCategoryImages() async {
    HttpHelper helper = HttpHelper();
    List<WallpaperModel> wallpapers =
        await helper.getCategoryPics(widget.category);
    return wallpapers;
  }

  @override
  Widget build(BuildContext context) {
    String imagePath = findImagePathByParameter(widget.category);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            snap: false,
            actionsIconTheme: IconThemeData(opacity: 0.0),
            flexibleSpace: Stack(
              children: <Widget>[
                Positioned.fill(
                    child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                )),
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Center(
                      child: Text(
                        '${widget.category.capitalize()} Images',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
              ],
            ),
            leading: BackButton(
              color: Colors.white.withOpacity(0.3), // Set the color you want
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                imageBottom(future: fetchCategoryImages()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
