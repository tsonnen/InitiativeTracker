import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/widgets/color_picker_button.dart';
import 'package:initiative_tracker/widgets/dialogs.dart';
import '../test_helper.dart';

void main() {
  group('ColorPickerButton Tests', () {
    Color? color;

    setUp(() {
      color = Colors.green;
    });

    testWidgets('Check Content', (WidgetTester tester) async {
      await tester
          .pumpWidget(TestHelper.createDialogTestScreen(ConfirmationDialog(
        title: 'Color Check',
        body: ColorPickerButton(color, 'Color Test', (val) {
          color = val;
        }),
      )));
      await tester.pumpAndSettle();
    });
  });
}
