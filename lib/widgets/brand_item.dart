import 'package:flutter/material.dart';

class BrandItem extends StatelessWidget {
  const BrandItem(this.imagePath, this.name, {super.key});

  final String imagePath;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color.fromARGB(20, 0, 0, 0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imagePath,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 15),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(name, style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
