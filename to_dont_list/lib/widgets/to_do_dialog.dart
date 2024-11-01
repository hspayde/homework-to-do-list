import 'package:flutter/material.dart';
import 'package:to_dont_list/objects/course.dart';

typedef ToDoListAddedCallback = Function(
    String value, TextEditingController textController, String courseName, TextEditingController textController2);

class ToDoDialog extends StatefulWidget {
  const ToDoDialog({
    super.key,
    required this.onListAdded,
    required this.courses,
  });

  final ToDoListAddedCallback onListAdded;
  final List<Course> courses;

  @override
  State<ToDoDialog> createState() => _ToDoDialogState();
}

class _ToDoDialogState extends State<ToDoDialog> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  String? selectedCourse;

  final TextEditingController _inputController2 = TextEditingController();
  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  String valueText = "";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Item To Add'),
      content: 
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              onChanged: (value) {
                setState(() {
                  valueText = value;
                });
              },
              controller: _inputController,
              decoration: const InputDecoration(hintText: "Put HW name here"),
              key: const Key('HW'),
            ),
            DropdownButton<String>(
              value: selectedCourse,
              hint: const Text('Select a course'),
              items: widget.courses.map((Course course) {
                return DropdownMenuItem<String>(
                  value: course.name,
                  child: Text(course.name),
                );
              }).toList(), 
              onChanged: (String? newValue) {
                setState(() {
                  selectedCourse = newValue;
                });
              },
            )
          ],
        ),
        
      actions: <Widget>[
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _inputController,
          builder: (context, value, child) {
            return ElevatedButton(
              key: const Key("OKButton"),
              style: yesStyle,
              onPressed: (value.text.isNotEmpty && selectedCourse != null)
                  ? () {
                      setState(() {
                        widget.onListAdded(valueText, _inputController, selectedCourse!, _inputController2);
                        Navigator.pop(context);
                      });
                    }
                  : null,
                child: const Text('OK'),
            );
          },
        ),
        // https://stackoverflow.com/questions/52468987/how-to-turn-disabled-button-into-enabled-button-depending-on-conditions


        ElevatedButton(
          key: const Key("CancelButton"),
          style: noStyle,
          child: const Text('Cancel'),
          onPressed: () {
            setState(() {
              Navigator.pop(context);
            });
          },
        ),
      ],
    );
  }
}
