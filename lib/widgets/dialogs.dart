import 'package:flutter/material.dart';

import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';

import '../helpers/keys.dart';

class ConfirmationDialog extends StatelessWidget {
  final body;
  final title;

  ConfirmationDialog({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('No'),
        ),
      ],
    );
  }
}

class ColorPickerDialog extends StatefulWidget {
  final Color? color;

  ColorPickerDialog(this.color);
  @override
  State<ColorPickerDialog> createState() => ColorPickerDialogState();
}

class ColorPickerDialogState extends State<ColorPickerDialog> {
  Color? color;

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
          initialColor: color!,
          onChanged: (val) {
            color = val;
          },
          size: const Size(240, 240),
          strokeWidth: 4,
          thumbSize: 36,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(color);
          },
          child: const Text('Ok!'),
        ),
      ],
    );
  }
}

class IntroDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: Key(Keys.welcomeDialogKey),
      title: Text('Welcome'),
      content: Text('Thank you for donwloading the Initiative '
          'Tracker App! To get started, tap the plus sign to add a '
          'character. To control what is displayed, or if intiative '
          'should be generated, check the settings'),
      actions: [
        TextButton(
          key: Key(Keys.getStartedButtonKey),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Get Started'),
        )
      ],
    );
  }
}
