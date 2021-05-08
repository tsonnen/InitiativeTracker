import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:initiative_tracker/widgets/styles.dart';

class NumericTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final bool allowNegative;
  final Function(String?)? onChanged;
  final Function(bool)? onFocusChange;

  final _focus = FocusNode();
  NumericTextFormField(
      {Key? key,
      required this.label,
      this.controller,
      this.onChanged,
      this.onFocusChange,
      this.allowNegative = false})
      : super(key: key) {
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (onFocusChange == null) {
      return;
    }
    onFocusChange!(_focus.hasFocus);
  }

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
      focusNode: _focus,
    );
  }
}
