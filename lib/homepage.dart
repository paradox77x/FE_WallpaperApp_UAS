import 'package:flutter/material.dart';
import '../imagepage.dart';
import '../views/favorite_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _index = 0;
  int index_size = 0;
  final _kategory = ['Alam', 'Hot', 'Game', 'Sexy'];

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
                          ? const EdgeInsets.only()
                          : const EdgeInsets.only(
                              top: 8.0, bottom: 8.0, left: 10.0, right: 10.0),
                      child: InkWell(
                        onTap: () {
                          print('Card di tekan pada indeks $index');
                        },
                        child: Container(
                          child: const Column(
                            children: [
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  color: Colors.green,
                                  child: Center(child: Text('Wallpaper')),
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
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: PageView.builder(
                  itemCount: _kategory.length,
                  controller:
                      PageController(viewportFraction: 0.3, initialPage: 2),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print('Category di tekan pada indeks $index');
                      },
                      child: Card(
                        elevation: 4,
                        child: Center(child: Text(_kategory[index])),
                      ),
                    );
                  },
                ),
              ),
            ),
          ];
        },
        body: const Padding(
          padding: EdgeInsets.only(top: 25.0),
          child: Display(),
        ),
      ),
    );
  }
}
