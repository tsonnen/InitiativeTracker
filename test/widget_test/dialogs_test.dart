import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/widgets/dialogs.dart';
import 'package:mockito/mockito.dart';

import '../testHelpers.dart';
import '../testHelpers.mocks.dart';

void main() {
  group('Confirmation Dialog', () {
    final title = 'TITLE';
    final body = 'BODY';
    setUp(() {});

    testWidgets('Check Content', (WidgetTester tester) async {
      await tester.pumpWidget(TestHelper.createDialogTestScreen(
          ConfirmationDialog(title: title, body: body)));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.text(title), findsOneWidget);
      expect(find.text(body), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'Yes'), findsOneWidget);
      expect(find.widgetWithText(TextButton, 'No'), findsOneWidget);
    });

    testWidgets('Check Yes', (WidgetTester tester) async {
      var mockObserver = MockNavigatorObserver();

      when(mockObserver.didPop(any, any)).thenAnswer((realInvocation) async {
        var value =
            await (realInvocation.positionalArguments.first as Route).popped;
        expect(value, true);
      });
      await tester.pumpWidget(TestHelper.createDialogTestScreen(
          ConfirmationDialog(title: title, body: body),
          navigatorObservers: [mockObserver]));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Yes'));

      await tester.pumpAndSettle();
    });

    testWidgets('Check No', (WidgetTester tester) async {
      var mockObserver = MockNavigatorObserver();

      when(mockObserver.didPop(any, any)).thenAnswer((realInvocation) async {
        var value =
            await (realInvocation.positionalArguments.first as Route).popped;
        expect(value, false);
      });
      await tester.pumpWidget(TestHelper.createDialogTestScreen(
          ConfirmationDialog(title: title, body: body),
          navigatorObservers: [mockObserver]));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'No'));

      await tester.pumpAndSettle();
    });
  });
}
