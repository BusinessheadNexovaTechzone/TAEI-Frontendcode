import 'package:flutter/material.dart';

class Space extends StatelessWidget {
  const Space({super.key, this.height = 10});
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: height,);
  }
}