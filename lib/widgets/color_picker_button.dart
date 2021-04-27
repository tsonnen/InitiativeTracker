import 'package:flutter/material.dart';

import 'dialogs.dart';

class ColorPickerButton extends StatefulWidget {
  final Color? color;
  final String label;
  final Function(Color) updateFunc;

  ColorPickerButton(this.color, this.label, this.updateFunc, {key})
      : super(key: key);

  @override
  ColorPickerButtonState createState() => ColorPickerButtonState();
}

class ColorPickerButtonState extends State<ColorPickerButton> {
  Color? color;

  @override
  void initState() {
    color = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<Color>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return ColorPickerDialog(color);
            }).then((value) {
          if (value != null) {
            setState(() {
              color = value;
              widget.updateFunc(value);
            });
          }
        });
      },
      child: Row(children: [
        Icon(
          Icons.color_lens,
          color: color,
        ),
        Text(
          widget.label,
          style: TextStyle(color: color),
        ),
      ]),
    );
  }
}
