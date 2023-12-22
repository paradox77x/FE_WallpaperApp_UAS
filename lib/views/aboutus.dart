import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
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
            Navigator.pushNamed(context, '/');
          } else if (index == 1) {
            // Navigate to FavoriteView
            Navigator.pushNamed(context, '/favorite');
          } else if (index == 2) {
            // You are already on the 'AboutPage', no need to navigate.
          }
        },
      ),
    );
  }
}
