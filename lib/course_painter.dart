import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:course_skill_tree/course.dart';

class CoursePainter extends CustomPainter{
  List<Course> coursesToPaint;

  CoursePainter(List<Course> _courses) :
      this.coursesToPaint = _courses,
      super();

  @override
  void paint(Canvas canvas, Size size) {
    var rectPaint = Paint();
    rectPaint.color = Colors.blue;
    rectPaint.strokeWidth = 5;

    var textPaint = Paint();
    textPaint.color = Colors.black;

    final double TOP_PADDING = size.height/6.0;
    final double SIDE_PADDING = size.width/6.0;
    final int LEVELS = 3;
    final List<double> LEVEL_DEPTHS = List.filled(LEVELS, 0.00, growable: false);
    final double COLUMN_WIDTH = (size.width - 2.0 * SIDE_PADDING) / LEVELS;
    final double INTER_PADDING = COLUMN_WIDTH/20.0;



    for (Course course in coursesToPaint) {
      var courseText = "${course.name}\n${course.department + course.number}";
      int courseLevel = int.parse(course.number[0]);
      var rectangleWidth = COLUMN_WIDTH - 10.0*INTER_PADDING;
      var rectangleHeight = rectangleWidth/2.0;
      Offset topleft = Offset(
          SIDE_PADDING + (courseLevel-1)*COLUMN_WIDTH,
          TOP_PADDING + LEVEL_DEPTHS[courseLevel-1] + INTER_PADDING
      );
      var rect = Rect.fromLTRB(
          topleft.dx,
          topleft.dy,
          topleft.dx+rectangleWidth,
          topleft.dy+rectangleHeight);
      canvas.drawRect(rect, rectPaint);
      LEVEL_DEPTHS[courseLevel-1] += rectangleHeight+2.0*INTER_PADDING;

      var paragraphStyle = ParagraphStyle(
        textAlign: TextAlign.center,
        maxLines: 2,
        fontSize: rectangleHeight/2.5
      );
      var paragraphBuilder = ParagraphBuilder(paragraphStyle)
      ..addText(courseText);
      var paragraph = paragraphBuilder.build()
      ..layout(ParagraphConstraints(width: rectangleWidth));
      
      canvas.drawParagraph(paragraph, topleft);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}