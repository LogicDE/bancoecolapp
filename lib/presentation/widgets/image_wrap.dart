import 'package:flutter/material.dart';

class ImageWrap extends StatelessWidget {
  final List<String> imagePaths;

  const ImageWrap({required this.imagePaths, super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 15,
      spacing: 15,
      children: imagePaths.map((path) {
        return Image.asset(
          path,
          width: 150,
          height: 150,
          fit: BoxFit.contain,
        );
      }).toList(),
    );
  }
}