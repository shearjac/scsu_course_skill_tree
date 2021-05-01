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

    workingList.add(new Course("test", "AHS", "160"));  //0
    workingList.add(new Course("test", "AHS", "260"));  //1
    workingList.add(new Course("test", "MATH", "221")); //2
    workingList.add(new Course("test", "MATH", "222")
      ..addPrerequisite(workingList[2]));               //3
    workingList.add(new Course("test", "MATH", "112")); //4
    workingList.add(new Course("test", "MATH", "113")); //5
    workingList.add(new Course("test", "MATH", "115")); //6
    workingList.add(new Course("test", "AHS", "230")
      ..addPrerequisite(workingList[2])
      ..addPrerequisite(workingList[3])
      ..addPrerequisite(workingList[4])
      ..addPrerequisite(workingList[5])
      ..addPrerequisite(workingList[6]));               //7
    workingList.add(new Course("test", "MATH", "320")); //8
    workingList.add(new Course("test", "PHYS", "234")
      ..addPrerequisite(workingList[6]));               //9
    workingList.add(new Course("test", "PHYS", "235")
      ..addPrerequisite(workingList[9]));               //10
    workingList.add(new Course("test", "PHYS", "346")
      ..addPrerequisite(workingList[10]));              //11
    workingList.add(new Course("test", "PHYS", "237")); //12

    return workingList;
  }
}