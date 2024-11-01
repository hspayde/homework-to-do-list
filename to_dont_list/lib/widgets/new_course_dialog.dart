import 'package:flutter/material.dart';

typedef CourseAddedCallback = Function(String value, TextEditingController textController, Color courseColor);

class NewCourseDialog extends StatefulWidget {
  const NewCourseDialog({
    super.key,
    required this.onListAdded,
  });

  final CourseAddedCallback onListAdded;

  @override
  State<NewCourseDialog> createState() => _NewCourseDialogState();
}

class _NewCourseDialogState extends State<NewCourseDialog> {
  // Dialog with text from https://www.appsdeveloperblog.com/alert-dialog-with-a-text-field-in-flutter/
  final TextEditingController _inputController = TextEditingController();
  // Color selectedColor = Colors.blue;

  double _colorValue = 0.0;

  final ButtonStyle yesStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.green);
  final ButtonStyle noStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20), backgroundColor: Colors.red);

  String valueText = "";

  Color get currentColor {
    // Converts slider value from 0-255 to HSV
    return HSVColor.fromAHSV(1.0, _colorValue / 255 * 360, 1.0, 1.0).toColor();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Course to add:'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                valueText = value;
              });
            },
            controller: _inputController,
            decoration: const InputDecoration(hintText: "type the course name here"),
            key: const Key('CN'),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: currentColor,
              border: Border.all(color: Colors.black),
            ),
          ),
          Slider(
            value: _colorValue,
            min: 0,
            max: 255,
            onChanged: (value) {
              setState(() {
                _colorValue = value;
              });
            },
          )
        ]
      ),
      actions: <Widget>[
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _inputController,
          builder: (context, value, child) {
            return ElevatedButton(
              key: const Key("OKButton"),
              style: yesStyle,
              onPressed: value.text.isNotEmpty
                  ? () {
                      setState(() {
                        widget.onListAdded(valueText, _inputController, currentColor) ;
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
