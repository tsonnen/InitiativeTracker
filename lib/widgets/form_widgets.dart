import 'package:flutter/material.dart';
import 'package:initiative_tracker/helpers/helpers.dart';
import 'package:initiative_tracker/widgets/dialogs.dart';
import 'package:numberpicker/numberpicker.dart';

class Styles {
  static InputDecoration textFieldDecoration(String labelText,
      {Color? fillColor}) {
    return InputDecoration(
        border: InputBorder.none,
        labelText: labelText,
        fillColor: fillColor,
        filled: fillColor != null);
  }
}

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

class SpinnerButton extends StatefulWidget {
  final PrimitiveWrapper primWrap;
  final String label;
  final int max;
  final int min;

  SpinnerButton(this.min, this.max, this.primWrap, this.label, {Key? key})
      : super(key: key);

  @override
  SpinnerButtonState createState() => SpinnerButtonState();
}

class SpinnerButtonState extends State<SpinnerButton> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.primWrap.value != null) {
      controller.text = widget.primWrap.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: () {
        showDialog<int>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return NumberPickerDialog.integer(
                minValue: widget.min,
                maxValue: widget.max,
                initialIntegerValue: widget.primWrap.value ?? 0,
              );
            }).then((value) {
          if (value != null) {
            widget.primWrap.value = value;
            setState(() {
              controller.text = widget.primWrap.value.toString();
            });
          }
        });
      },
      controller: controller,
      decoration: Styles.textFieldDecoration(widget.label),
    );
  }
}
