import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: const Color.fromARGB(255, 151, 150, 150),
      unselectedLabelStyle: const TextStyle(color: Colors.white),
      currentIndex: currentIndex,
      iconSize: 25,
      selectedFontSize: 12, // Ukuran font ikon terpilih
      unselectedFontSize: 12, // Ukuran font ikon tidak terpilih
      type: BottomNavigationBarType
          .fixed, // Tetap menggunakan ukuran yang sama untuk setiap ikon
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Category',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favorite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          label: 'About',
        ),
      ],
      onTap: onTap,
    );
  }
}
