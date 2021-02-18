import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class SpinnerButton extends StatefulWidget {
  final TextEditingController controller;
  final int initVal;
  final String label;
  final int max;
  final int min;

  SpinnerButton(this.min, this.max, this.initVal, this.label, this.controller);

  @override
  SpinnerButtonState createState() => SpinnerButtonState();
}

class SpinnerButtonState extends State<SpinnerButton> {
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
                initialIntegerValue: int.tryParse(widget.controller.text) ?? 0,
              );
            }).then((value) {
          setState(() {
            widget.controller.text =
                (value ?? (widget.controller.text ?? 0)).toString();
          });
        });
      },
      controller: widget.controller,
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: widget.label,
      ),
    );
  }
}
