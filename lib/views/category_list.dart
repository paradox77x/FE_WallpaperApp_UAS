import 'package:flutter/material.dart';
import 'package:uas_pemweb/homepage.dart';
import 'package:uas_pemweb/views/aboutus.dart';
import 'package:uas_pemweb/views/categoryimagepage.dart';
import '../views/favorite_view.dart';
import '../views/bottom_navigation.dart';
import '../koneksi/category_data.dart';

class BoxData {
  final String text;
  final String imagePath;
  final String parameter;

  BoxData(this.text, this.parameter, this.imagePath);
}

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int index_size = 0;
  int _selectedIndex = 1;

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
          // Category
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
          'Category List',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1.1,
            mainAxisSpacing: 1.1,
            childAspectRatio: 7 / 3, //Mengatur size setiap Box
          ),
          itemCount: boxes.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryImagePage(
                      category: boxes[index].parameter,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(3.5),
                child: SizedBox(
                  child: Stack(fit: StackFit.expand, children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        boxes[index].imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.0),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              boxes[index].text,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
