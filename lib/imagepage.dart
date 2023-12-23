import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../koneksi/api.dart';
import '../views/ImageView.dart';

class Display extends StatefulWidget {
  const Display({Key? key}) : super(key: key);

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  int currentPage = 1;
  List<WallpaperModel> wallpapers = [];
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadMore();
  }

  void _loadMore() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);

    HttpHelper helper = HttpHelper();
    List<WallpaperModel> newWallpapers = await helper.getpics(currentPage);

    if (newWallpapers.isEmpty) {
      setState(() => hasMore = false);
    } else {
      currentPage++;
      setState(() => wallpapers.addAll(newWallpapers));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            hasMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          _loadMore();
        }
        return true;
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: (isLoading && currentPage == 1)
                ? Shimmer.fromColors(
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
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: wallpapers.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.55,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final item = wallpapers[index];
                      return GridTile(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ImageView(
                                    imgUrl: item.imageUrl,
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: CachedNetworkImage(
                                imageUrl: item.imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )),
                      );
                    },
                  ),
          ),
          if (isLoading)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
