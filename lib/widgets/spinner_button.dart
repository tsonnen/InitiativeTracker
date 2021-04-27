import 'package:flutter/material.dart';
import 'package:initiative_tracker/helpers/primitive_wrapper.dart';
import 'package:initiative_tracker/widgets/numberpicker_dialog.dart';
import 'package:initiative_tracker/widgets/styles.dart';

class SpinnerButton extends StatefulWidget {
  final PrimitiveWrapper<int> primWrap;
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

    controller.text = widget.primWrap.value.toString();
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
              return NumberPickerDialog(
                minValue: widget.min,
                maxValue: widget.max,
                initialIntegerValue: widget.primWrap.value,
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
