import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class NumberPickerDialog extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int initialIntegerValue;
  final double initialDoubleValue;
  final int decimalPlaces;
  final Widget? title;
  final EdgeInsets? titlePadding;
  final Widget confirmWidget;
  final Widget cancelWidget;
  final int step;
  final bool infiniteLoop;
  final bool zeroPad;
  final bool highlightSelectedValue;
  final Decoration? decoration;
  final TextMapper? textMapper;
  final bool haptics;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;

  ///constructor for integer values
  NumberPickerDialog({
    required this.minValue,
    required this.maxValue,
    required this.initialIntegerValue,
    this.title,
    this.titlePadding,
    this.step = 1,
    this.infiniteLoop = false,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
    this.textMapper,
    this.haptics = false,
    this.textStyle,
    this.selectedTextStyle,
    Widget? confirmWidget,
    Widget? cancelWidget,
  })  : confirmWidget = confirmWidget ?? Text('OK'),
        cancelWidget = cancelWidget ?? Text('CANCEL'),
        decimalPlaces = 0,
        initialDoubleValue = -1.0;

  @override
  State<NumberPickerDialog> createState() => _NumberPickerDialogControllerState(
      initialIntegerValue, initialDoubleValue);
}

class _NumberPickerDialogControllerState extends State<NumberPickerDialog> {
  int selectedIntValue;
  double selectedDoubleValue;

  _NumberPickerDialogControllerState(
      this.selectedIntValue, this.selectedDoubleValue);

  void _handleValueChanged(num value) {
    if (value is int) {
      setState(() => selectedIntValue = value);
    } else {
      setState(() => selectedDoubleValue = value as double);
    }
  }

  NumberPicker _buildNumberPicker() {
    return NumberPicker(
      value: selectedIntValue,
      minValue: widget.minValue,
      maxValue: widget.maxValue,
      step: widget.step,
      zeroPad: widget.zeroPad,
      decoration: widget.decoration,
      onChanged: _handleValueChanged,
      textMapper: widget.textMapper,
      haptics: widget.haptics,
      textStyle: widget.textStyle,
      selectedTextStyle: widget.selectedTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title,
      titlePadding: widget.titlePadding,
      content: _buildNumberPicker(),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: widget.cancelWidget,
        ),
        TextButton(
            onPressed: () => Navigator.of(context).pop(widget.decimalPlaces > 0
                ? selectedDoubleValue
                : selectedIntValue),
            child: widget.confirmWidget),
      ],
    );
  }
}
