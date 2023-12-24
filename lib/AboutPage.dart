import 'package:flutter/material.dart';
import '../homepage.dart';
import '../views/favorite_view.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Kita'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          },
        ),
      ),
      body: Center(
        child: Text('This is the About page.'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Sesuaikan dengan indeks yang benar
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
        onTap: (index) {
          // Handle navigation based on the tapped index
          if (index == 0) {
            // Navigate to Home
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            );
          } else if (index == 1) {
            // Navigate to FavoriteView
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => FavoriteView()),
              (route) => false,
            );
          } else if (index == 2) {
            // You are already on the 'AboutPage', no need to navigate.
          }
        },
      ),
    );
  }
}
