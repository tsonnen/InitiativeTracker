import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color color;

  ColorPickerDialog(this.color);
  @override
  State<ColorPickerDialog> createState() => ColorPickerDialogState();
}

class ColorPickerDialogState extends State<ColorPickerDialog> {
  var color;

  @override
  void initState() {
    color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pick a Color'),
      content: SingleChildScrollView(
        child: CircleColorPicker(
          initialColor: color,
          onChanged: (color) => this.color,
          size: const Size(240, 240),
          strokeWidth: 4,
          thumbSize: 36,
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(color);
          },
          child: const Text('Ok!'),
        ),
      ],
    );
  }
}
