// Data class to keep the string and have an abbreviation function

import 'package:to_dont_list/objects/course.dart';

class Item {
  const Item({required this.name, required this.course, required this.dueDate});

  final String name;
  final Course course;
  final DateTime dueDate;

  String abbrev() {
    return name.substring(0, 1);
  }
}
