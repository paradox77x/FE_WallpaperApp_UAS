import 'package:flutter/material.dart';
import 'package:uas_pemweb/homepage.dart';
import 'package:uas_pemweb/views/bottom_navigation.dart';
import 'package:uas_pemweb/views/category_list.dart';
import 'package:uas_pemweb/views/favorite_view.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  AboutPageState createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  int _selectedIndex = 3;

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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const FavoriteView()),
            (route) => false,
          );
        } else if (_selectedIndex == 3) {
          // No need to navigate to AboutPage again
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: Center(
        child: Text('This is the About page.'), // Edit bagian ini (PENTING)
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
