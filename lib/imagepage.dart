import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../koneksi/api_ojak.dart';
import '../views/ImageView.dart';

class Display extends StatefulWidget {
  const Display({Key? key}) : super(key: key);

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  Future<List<WallpaperModel>> callPizzas() async {
    HttpHelper helper = HttpHelper();
    List<WallpaperModel> wallpapers = await helper.getpics();
    return wallpapers;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: FutureBuilder(
            future: callPizzas(),
            builder: (BuildContext context,
                AsyncSnapshot<List<WallpaperModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Shimmer.fromColors(
                  enabled: true,
                  baseColor: Colors.black54,
                  highlightColor: Colors.black87,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 12,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Server is down.',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                    ),
                  );
                } else {
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        (snapshot.data == null) ? 0 : snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                                    imgUrl: snapshot.data![index].imageUrl,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data![index].imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )),
                      );
                    },
                  );
                }
              } else {
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
            },
          ),
        ),
      ],
    );
  }
}
