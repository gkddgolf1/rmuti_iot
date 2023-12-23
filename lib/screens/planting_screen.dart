import 'package:flutter/material.dart';

class MyImageWidget extends StatelessWidget {
  final String imageUrl;

  const MyImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
      ),
    );
  }
}
