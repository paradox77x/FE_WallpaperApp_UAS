import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../imagepage.dart';
import '../views/favorite_view.dart';
import '../category.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _index = 0;
  int index_size = 0;
  int myCurrentIndex = 2;
  static List<BoxData> boxes = [
    BoxData("Nature", "lib/wallpapers/alam.jpg"),
    BoxData("Game", "lib/wallpapers/game.jpg"),
    BoxData("Hot", "lib/wallpapers/hot.jpg"),
    BoxData("Sexy", "lib/wallpapers/sexy.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Wallpaper App',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteView()),
              );
            },
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(
              child: SizedBox(
                height: 320,
                child: PageView.builder(
                  itemCount: 10,
                  controller:
                      PageController(viewportFraction: 0.5, initialPage: 3),
                  // onPageChanged: (index) => setState(() => _index = index),
                  itemBuilder: (context, index) {
                    return AnimatedPadding(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      padding: _index == index
                          ? EdgeInsets.only()
                          : EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
                      child: InkWell(
                        onTap: () {
                          print('Card di tekan pada indeks $index');
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  child: Center(child: Text('Wallpaper')),
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Text at the bottom',
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            CategoryWidget(
                boxes: boxes), //Memanggil CategoryWidget dari categoryhp.dart
          ];
        },
        body: const Padding(
          padding: EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
          child: Display(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor:  Colors.white,
        unselectedLabelStyle: TextStyle(color: Colors.white),
        // currentIndex: myCurrentIndex,
        iconSize: 25,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline), label: 'Favorite'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'About'),
        ],
        onTap: (index) {
          setState(() {
            myCurrentIndex = index;
          });

          // Panggil fungsi untuk mengarahkan ke halaman yang sesuai
          switch (index) {
            case 0:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
              break;
            case 1:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavoriteView(),
                ),
              );
              break;
            case 2:
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FavoriteView(),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
