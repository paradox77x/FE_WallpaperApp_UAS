import 'package:flutter/material.dart';
import '../views/categoryimagepage.dart'; // Import your CategoryImagePage

class BoxData {
  final String text;
  final String imagePath;
  final String parameter;

  BoxData(this.text, this.parameter, this.imagePath);
}

class CategoryWidget extends StatelessWidget {
  final List<BoxData> boxes;

  const CategoryWidget({Key? key, required this.boxes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 10.0),
          scrollDirection: Axis.horizontal,
          itemCount: boxes.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                // Navigate to the CategoryImagePage with the selected category
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
                padding: const EdgeInsets.only(right: 10.0),
                child: SizedBox(
                  width: 210,
                  height: 75,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          boxes[index].imagePath,
                          width: 210,
                          height: 75,
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
                            color: Colors.white.withOpacity(0.1),
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
                    ],
                  ),
                ),
              ),
            );
          },
          itemExtent: 210,
        ),
      ),
    );
  }
}
