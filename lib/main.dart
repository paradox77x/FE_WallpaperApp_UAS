import 'package:flutter/material.dart';
import 'package:uas_pemweb/homepage.dart';
import 'package:uas_pemweb/AboutPage.dart';
import 'package:uas_pemweb/views/favorite_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: const HomePage(),
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Atur rute inisial sesuai dengan yang Anda inginkan
      routes: {
        '/': (context) => HomePage(),
        '/favorite': (context) => FavoriteView(),
        '/about': (context) => AboutPage(),
      },
    );
  }
}
