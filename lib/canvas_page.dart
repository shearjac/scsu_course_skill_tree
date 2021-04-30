import 'package:flutter/material.dart';

import 'course.dart';
import 'course_painter.dart';

class CanvasPage extends StatelessWidget {
  List<Course> _coursesToPaint;

  @override
  Widget build(BuildContext context) {
    _coursesToPaint = buildDemoCourses();

    return Scaffold(
      appBar: AppBar(
        title: Text("Meteorology Skill Tree"),
      ),
      body: CustomPaint(
        painter: CoursePainter(_coursesToPaint),
        child: Center(),
      ),
    );
  }

  List<Course> buildDemoCourses() {
    List<Course> workingList = [];

    workingList.add(new Course("test", "AHS", "160"));
    workingList.add(new Course("test", "AHS", "260"));
    workingList.add(new Course("test", "AHS", "230"));
    workingList.add(new Course("test", "MATH", "221"));
    workingList.add(new Course("test", "MATH", "222"));
    workingList.add(new Course("test", "MATH", "320"));
    workingList.add(new Course("test", "PHYS", "346"));
    workingList.add(new Course("test", "PHYS", "234"));
    workingList.add(new Course("test", "PHYS", "237"));

    return workingList;
  }
}