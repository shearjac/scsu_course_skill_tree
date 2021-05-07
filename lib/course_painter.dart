import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:course_skill_tree/course.dart';

class CoursePainter extends CustomPainter{
  Map<Course,GlobalKey> coursesToPaint;

  CoursePainter(Map<Course,GlobalKey> _globalKeys) :
      this.coursesToPaint = _globalKeys,
      super();

  int getCourseLevel(Course _course) {
    int result = 0;

    try {
      result = int.parse(_course.number[0]);
    } catch (e) {
      print(e);
    }

    return result;
  }

  void paintLine(Canvas canvas, Paint paint, GlobalKey from, GlobalKey to) {
    RenderBox fromBox = from.currentContext.findRenderObject();
    RenderBox toBox = from.currentContext.findRenderObject();

    Offset fromOffset = Offset(
        fromBox.constraints.maxWidth/2,
        fromBox.constraints.maxHeight/2
    ) + fromBox.localToGlobal(Offset.zero);

    Offset toOffset = Offset(
        toBox.constraints.maxWidth/2,
        toBox.constraints.maxHeight/2
    ) + toBox.localToGlobal(Offset.zero);

    canvas.drawLine(fromOffset, toOffset, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint();
    linePaint.color = Colors.amberAccent;
    linePaint.strokeWidth = 5;

    for (Course course in coursesToPaint.keys) {
      for (Course prereq in course.prerequisites) {
        paintLine(canvas, linePaint, coursesToPaint[course], coursesToPaint[prereq]);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}