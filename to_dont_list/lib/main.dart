// Started with https://docs.flutter.dev/development/ui/widgets-intro
import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/course.dart';
import 'package:to_dont_list/objects/item.dart';
import 'package:to_dont_list/widgets/new_course_dialog.dart';
import 'package:to_dont_list/widgets/to_do_items.dart';
import 'package:to_dont_list/widgets/to_do_dialog.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  State createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<Course> courses = [const Course(name: "Course", color: Color.fromARGB(255, 42, 101, 42))];
  final List<Item> items = [const Item(name: "First Homework", course: Course(name: 'Course', color: Color.fromARGB(255, 42, 101, 42)))];
  final _itemSet = <Item>{};

  void _handleListChanged(Item item, bool completed) {
    setState(() {
      // When a user changes what's in the list, you need
      // to change _itemSet inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      items.remove(item);
      if (!completed) {
        print("Completing");
        _itemSet.add(item);
        items.add(item);
      } else {
        print("Making Undone");
        _itemSet.remove(item);
        items.insert(0, item);
      }
    });
  }

  void _handleDeleteItem(Item item) {
    setState(() {
      print("Deleting item");
      items.remove(item);
    });
  }

  void _handleNewItem(String itemText, TextEditingController textController, String courseName, TextEditingController textController2) {
    setState(() {
      int i = _checkCourseList(courseName);
      if(i != -1) {
        print("Adding new item");
        Item item = Item(name: itemText, course: courses[i]);
        items.insert(0, item);
        textController.clear();
      }else {
        print("Invalid Course Name");
      }
    });
  }

  void _handleNewCourse(String courseText, TextEditingController textController, Color color) {
    setState(() {
      print("Adding new course");
      Course course = Course(name: courseText, color: color);
      courses.insert(0, course);
      textController.clear();
    });
  }

  int _checkCourseList(String check) {
    for(int i=0; i < courses.length; i++) {
      if(courses[i].name == check) {
          return i;
      }
    }
    return -1;
  }

  Color _getColor(String r, String g, String b) {
    int rValue = 0;
    int gValue = 0;
    int bValue = 0;

    try {
      rValue = int.parse(r);
      gValue = int.parse(g);
      bValue = int.parse(b);
    }catch (e) {
      print('An rgb value was not an Integer - using basic color');
    }

    return Color.fromARGB(255, rValue, gValue, bValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Homework List'),
          actions: <Widget>[
             IconButton(
              icon: const Icon(Icons.add_box),
              tooltip: 'Add Course',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return NewCourseDialog(onListAdded: _handleNewCourse);
                  });
              },
            )

          ]
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          children: items.map((item) {
            return ToDoListItem(
              item: item,
              completed: _itemSet.contains(item),
              onListChanged: _handleListChanged,
              onDeleteItem: _handleDeleteItem,
            );
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return ToDoDialog(onListAdded: _handleNewItem, courses: courses,);
                  });
            }));
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'To Do List',
    home: ToDoList(),
  ));
}
