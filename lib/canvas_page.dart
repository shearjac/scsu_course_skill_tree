import 'dart:math';

import 'package:flutter/material.dart';

import 'course.dart';
import 'course_painter.dart';

class CanvasPage extends StatelessWidget {
  Map<Course,Flexible> _coursesToPaint;
  Map<Course,GlobalKey> globalKeys;

  @override
  Widget build(BuildContext context) {
    _coursesToPaint = buildCourseContainers( buildDemoCourses() );
    globalKeys = Map<Course,GlobalKey>();

    //Center widgetCenter = GridView.builder(gridDelegate: gridDelegate, itemBuilder: itemBuilder);
    //widgetCenter.child

    return Scaffold(
      appBar: AppBar(
        title: Text("Meteorology Skill Tree"),
      ),
      //body: CustomPaint(
      //  painter: CoursePainter(globalKeys),
      //  child: buildCourseGrid(_coursesToPaint)
      //),
      body: buildCourseGrid(_coursesToPaint)
    );
  }

  List<Course> buildDemoCourses() {
    List<Course> workingList = [];

    workingList.add(new Course("Professional Meteorology", "AHS", "160"));  //0
    workingList.add(new Course("Introductory Meteorology", "AHS", "260"));  //1
    workingList.add(new Course("Calculus I", "MATH", "221")); //2
    workingList.add(new Course("Calculus II", "MATH", "222")
      ..addPrerequisite(workingList[2]));               //3
    workingList.add(new Course("College Algebra", "MATH", "112")); //4
    workingList.add(new Course("Trigonometry", "MATH", "113")); //5
    workingList.add(new Course("Precalculus", "MATH", "115")); //6
    workingList.add(new Course("Introduction to Physical Hydrology", "AHS", "230")
      ..addPrerequisite(workingList[4]));               //7
    workingList.add(new Course("Multivariable Calculus for Engineers", "MATH", "320")); //8
    workingList.add(new Course("Classical Physics I", "PHYS", "234")
      ..addPrerequisite(workingList[6]));               //9
    workingList.add(new Course("Classical Physics II", "PHYS", "235")
      ..addPrerequisite(workingList[9]));               //10
    workingList.add(new Course("Mathematical Methods for Physics", "PHYS", "346")
      ..addPrerequisite(workingList[10]));              //11
    workingList.add(new Course("Classical Physics for Geosciences", "PHYS", "237")); //12

    return workingList;
  }

  Flexible createCourseContainer( Course _course ) {
    //GlobalKey newGlobalKey = new GlobalKey();
    //globalKeys[_course] = newGlobalKey;
    Flexible result = Flexible(
        child: Container (
          child: Column(
            children: [
              FittedBox( child: Text( _course.name,  textScaleFactor: 1.5,), fit: BoxFit.scaleDown),
              FittedBox( child: Text(_course.department + _course.number,  textScaleFactor: 1.0), fit: BoxFit.scaleDown)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          color: Colors.blueAccent,
          alignment: Alignment.center,
          padding: EdgeInsets.all(5.0),
          margin: EdgeInsets.fromLTRB(40.0, 5.0, 40.0, 5.0),
        ),
        flex: 1,
      //key: newGlobalKey
    );

    return result;
  }

  int getPrerequisiteDepth( Course _course ) {
    if (_course.prerequisites.isEmpty) {
      return 0;
    } else {
      int nestedDepth = 0;

      for (Course prereq in _course.prerequisites) {
        nestedDepth = max(nestedDepth, getPrerequisiteDepth(prereq));
      }

      return nestedDepth+1;
    }
  }

  int getMaxPrerequisiteDepth( List<Course> _courses) {
    int maxDepth = 0;

    for (Course course in _courses) {
      maxDepth = max(maxDepth, getPrerequisiteDepth(course));
    }

    return maxDepth;
  }

  Map<Course,Flexible> buildCourseContainers( List<Course> _courses ) {
    Map<Course,Flexible> resultMap = Map<Course,Flexible>();

    for (Course course in _courses ) {
      resultMap[ course ] = createCourseContainer( course );
    }

    return resultMap;
  }

  List<Course> getCourseAndAllPrerequisites( Course _course ) {
    List<Course> resultList = [];

    resultList.add(_course);

    if (_course.prerequisites.isNotEmpty) {
      for (Course prereq in _course.prerequisites) {
        resultList += getCourseAndAllPrerequisites(prereq);
      }
    }

    //print(resultList.toString());
    return resultList;
  }

  Row buildCourseGrid( Map<Course,Flexible> _courses ) {
    final int NUM_COLUMNS = getMaxPrerequisiteDepth(_courses.keys.toList())+1;

    List<Course> workingList = _courses.keys.toList();

    List<List<Flexible>> grid = [];
    for (int i=0; i<NUM_COLUMNS; i++) {
      grid.add(<Flexible>[]);
    }

    while( workingList.isNotEmpty ) {
      List<Course> coursesToAdd = getCourseAndAllPrerequisites(
        workingList[0]
      );

      for (Course workingCourse in coursesToAdd) {
        //print(getPrerequisiteDepth(workingCourse).toString());
        grid[ getPrerequisiteDepth(workingCourse) ].add(
          _courses[ workingCourse ]
        );
        //print(grid.elementAt(getPrerequisiteDepth(workingCourse)));
        //print(workingCourse.toString() + " removed from " + workingList.toString());
        //print("\tDepth for " + workingCourse.toString() + " was " + getPrerequisiteDepth(workingCourse).toString());
        workingList.remove(workingCourse);
      }
    }

    List<Flexible> actualColumns = [];

    for (int i=0; i<NUM_COLUMNS; i++) {
      List<Flexible> containerList = grid[i];
      actualColumns.add(
        Flexible(
          child: Column(
            children: containerList
          ),
          flex: 1,
        )
      );
    }

    return Row(
      children: actualColumns,

    );
  }
}