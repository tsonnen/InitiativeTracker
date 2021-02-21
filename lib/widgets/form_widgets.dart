import 'package:flutter/material.dart';
import 'package:initiative_tracker/helpers/helpers.dart';
import 'package:numberpicker/numberpicker.dart';

class Styles {
  static InputDecoration textFieldDecoration(String labelText) {
    return InputDecoration(
      border: InputBorder.none,
      labelText: labelText,
    );
  }
}

class SpinnerButton extends StatefulWidget {
  final PrimitiveWrapper primWrap;
  final String label;
  final int max;
  final int min;

  SpinnerButton(this.min, this.max, this.primWrap, this.label, {key})
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
