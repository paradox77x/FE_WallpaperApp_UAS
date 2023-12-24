import 'package:flutter/material.dart';
import '../imagepage.dart';
import '../views/favorite_view.dart';
import '../category.dart';
import '../AboutPage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _index = 0;
  int _totalPages = 7;
  late CarouselController _carouselController;
  static List<BoxData> boxes = [
    BoxData("Food", "food", "lib/wallpapers/alam.jpg"),
    BoxData("Car", "car", "lib/wallpapers/game.jpg"),
    BoxData("Hot", "hot", "lib/wallpapers/hot.jpg"),
    BoxData("Sexy", "sexy", "lib/wallpapers/sexy.jpg"),
  ];

  @override
  void initState() {
    super.initState();
    _carouselController = CarouselController();

    // Set nilai tengah dari jumlah total halaman
    _selectedIndex = _totalPages ~/ 2;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _carouselController.jumpToPage(_selectedIndex);
    });
  }

  void _updateIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _carouselController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation based on the tapped index
    if (_selectedIndex == 0) {
      // Navigate to Home
    } else if (_selectedIndex == 1) {
      // Navigate to FavoriteView
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FavoriteView()),
        (route) => false,
      );
    } else if (_selectedIndex == 2) {
      // Navigate to About (Settings) - Replace this with your actual settings page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AboutPage()),
        (route) => false,
      );
    }
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
            SliverAppBar(
              expandedHeight: 50,
              floating: false,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only( bottom: 20, left: 20),
                title: Text(
                  'Recommended For You',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 400,
                width: 300,
                child: CarouselSlider(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    viewportFraction:0.7,
                    // height: double,
                    aspectRatio: 9/16,
                    enlargeCenterPage: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      // Additional logic you want when the page changes
                    },
                  ),
                  items: List.generate(_totalPages, (index) {
                    double scaleFactor = 0.9;
                    if (index == _selectedIndex) {
                      scaleFactor = 1.0;
                    }
                    return AnimatedPadding(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.fastOutSlowIn,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: InkWell(
                        onTap: () {
                          _updateIndex(index);
                          print('Card di tekan pada indeks $index');
                        },
                        child: Container(
                          child: Transform.scale(
                            scale: scaleFactor,
                            child: Card(
                              elevation: 4,
                              child: Center(child: Text('Wallpaper $index')),
                              color: _selectedIndex == index
                                  ? Colors.pink
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 20.0, left: 8.0, right: 8.0, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 5),
                    AnimatedSmoothIndicator(
                      activeIndex: _selectedIndex % _totalPages,
                      count: _totalPages,
                      effect:
                          ExpandingDotsEffect(dotWidth: 7.5, dotHeight: 7.5),
                      onDotClicked: (index) {
                        _updateIndex(index);
                      },
                    ),
                  ],
                ),
              ),
            ),
            CategoryWidget(boxes: boxes),
          ];
        },
        body: const Padding(
          padding: EdgeInsets.only(top: 15.0, left: 8.0, right: 8.0),
          child: Display(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'About',
          ),
        ],
        onTap: _onItemTapped,
      ),
    );
  }
}
