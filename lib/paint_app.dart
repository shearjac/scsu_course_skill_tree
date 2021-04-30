import 'package:course_skill_tree/canvas_page.dart';
import 'package:flutter/material.dart';


class CustomPaintingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Painter",
      home: CanvasPage(),
    );
  }
}