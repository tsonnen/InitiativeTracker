import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:initiative_tracker/widgets/dialogs.dart';
import 'package:initiative_tracker/widgets/form_widgets.dart';
import 'package:initiative_tracker/widgets/party_screen_dialogs.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../testHelpers.dart';

void main() {
  group('ColorPickerButton Tests', () {
    Color color;

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
