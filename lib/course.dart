
import 'dart:ui';

class Course {
  String name;
  String department;
  String number;
  List<Course> prerequisites;

  Course(
      String _name,
      String _department,
      String _number) {
    this.name = _name;
    this.department = _department;
    this.number = _number;
    this.prerequisites = [];
  }

  void addPrerequisite(Course _prereq) {
    this.prerequisites.add(_prereq);
  }

  Course getPrerequisiteAt(int _index) {
    try{
      return this.prerequisites.elementAt(_index);
    } catch (e) {
      print(e);
    }
  }

  void removePrerequisiteAt(int _index) {
    try{
      this.prerequisites.removeAt(_index);
    } catch (e) {
      print(e);
    }
  }

  List<Course> getPrerequisites() {
    return List.from(this.prerequisites);
  }
}