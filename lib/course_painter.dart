import 'dart:core';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:course_skill_tree/course.dart';

class CoursePainter extends CustomPainter{
  List<Course> coursesToPaint;

  CoursePainter(List<Course> _courses) :
      this.coursesToPaint = _courses,
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

  int getHighestCourseLevel(List<Course> _courses) {
    int result = 0;

    for (Course course in _courses) {
      result = max(result, getCourseLevel(course));
    }

    return result;
  }

  int getHighestCourseLevelFrequency(List<Course> _courses) {
    int result = 0;
    List<int> frequencies = List.filled(getHighestCourseLevel(_courses), 0);

    for (Course course in _courses) {
      frequencies[ getCourseLevel(course)-1 ]++;
    }

    for (int freq in frequencies) {
      result = max(result, freq);
    }

    return result;
  }

  @override
  void paint(Canvas canvas, Size size) {
    var rectPaint = Paint();
    rectPaint.color = Colors.blue;
    rectPaint.strokeWidth = 5;

    var textPaint = Paint();
    textPaint.color = Colors.black;

    var linePaint = Paint();
    linePaint.color = Colors.amberAccent;
    linePaint.strokeWidth = 5;

    final double TOP_PADDING = size.height/10.0;
    final double SIDE_PADDING = size.width/10.0;
    final int LEVELS = getHighestCourseLevel(coursesToPaint);
    final List<double> LEVEL_DEPTHS = List.filled(LEVELS, 0.00, growable: false);
    final double COLUMN_WIDTH = (size.width - 2.0 * SIDE_PADDING) / LEVELS;
    final double INTER_PADDING = COLUMN_WIDTH/20.0;
    final double MAX_HEIGHT = (size.height - 2.0*TOP_PADDING);
    final int MAX_DEPTH = getHighestCourseLevelFrequency(coursesToPaint);
    final double MAX_RECT_HEIGHT = (MAX_HEIGHT - (MAX_DEPTH-1)*INTER_PADDING)/MAX_DEPTH;

    final double rectangleWidth = COLUMN_WIDTH - 10.0 * INTER_PADDING;
    final double rectangleHeight = min(rectangleWidth / 2.0, MAX_RECT_HEIGHT);

    Map<Course,Offset> courseCenters = new Map<Course,Offset>();

    for (Course course in coursesToPaint) {
      int courseLevel = getCourseLevel(course);
      Offset topleft = Offset(
          SIDE_PADDING + (courseLevel - 1) * COLUMN_WIDTH,
          TOP_PADDING + LEVEL_DEPTHS[courseLevel - 1] + INTER_PADDING
      );

      courseCenters[course] = Offset(
          topleft.dx + rectangleWidth / 2.0,
          topleft.dy + rectangleHeight / 2.0);

      LEVEL_DEPTHS[courseLevel-1] += rectangleHeight+INTER_PADDING;
    }

    for (Course course in coursesToPaint) {
      for (Course prereq in course.prerequisites) {
        canvas.drawLine(
            courseCenters[course],
            courseCenters[prereq],
            linePaint);
      }
    }

    for (Course course in coursesToPaint) {
      var courseText = "${course.name}\n${course.department +" "+ course.number}";
      Offset topleft = Offset(
          courseCenters[course].dx - rectangleWidth/2.0,
          courseCenters[course].dy - rectangleHeight/2.0
      );

      var rect = Rect.fromLTRB(
          topleft.dx,
          topleft.dy,
          topleft.dx+rectangleWidth,
          topleft.dy+rectangleHeight);
      canvas.drawRect(rect, rectPaint);
      //LEVEL_DEPTHS[courseLevel-1] += rectangleHeight+INTER_PADDING;

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