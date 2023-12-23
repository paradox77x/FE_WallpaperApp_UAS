import 'package:flutter/material.dart';
import 'package:uas_pemweb/category.dart';
import 'package:uas_pemweb/imagepage.dart';
import 'package:uas_pemweb/koneksi/category_data.dart';
import 'package:uas_pemweb/views/aboutus.dart';
import 'package:uas_pemweb/views/category_list.dart';
import '../views/bottom_navigation.dart';
import '../views/favorite_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _totalPages = 10; // Jumlah total halaman wallpaper
  bool _pageHasChangedManually = false;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _selectedIndex = index;

        // Handle navigation based on the tapped index
        if (_selectedIndex == 0) {
          // Navigate to Home
        } else if (_selectedIndex == 1) {
          // Navigate to FavoriteView
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CategoryList()),
            (route) => false,
          );
        } else if (_selectedIndex == 2) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteView()),
            (route) => false,
          );
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
                    var _index;
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
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
