import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:initiative_tracker/widgets/styles.dart';

class NumericTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool allowNegative;
  final Function(String?)? onChanged;

  NumericTextFormField(
      {Key? key,
      required this.label,
      this.controller,
      this.onChanged,
      this.allowNegative = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatters = <TextInputFormatter>[];
    formatters.add(FilteringTextInputFormatter.allow(
      RegExp('${allowNegative ? '^-?' : ''}\\d*'),
    ));

    return TextFormField(
      decoration: Styles.textFieldDecoration(label),
      keyboardType: TextInputType.number,
      controller: controller,
      onChanged: onChanged,
      inputFormatters: formatters,
    );
  }
}
