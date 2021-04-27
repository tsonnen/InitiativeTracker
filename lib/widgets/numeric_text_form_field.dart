import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:initiative_tracker/widgets/styles.dart';

class NumericTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;

  NumericTextFormField({required this.label, controller})
      : controller = controller ?? TextEditingController();

  @override
  _NumericTextFormFieldState createState() => _NumericTextFormFieldState();
}

class _NumericTextFormFieldState extends State<NumericTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: Styles.textFieldDecoration(widget.label),
      keyboardType: TextInputType.number,
      controller: widget.controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
