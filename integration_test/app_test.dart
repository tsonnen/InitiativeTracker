// @dart = 2.10
// Imports the Flutter Driver API.
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:initiative_tracker/helpers/keys.dart';
import 'package:initiative_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Initiative Tracker App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings yValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final nextRoundButtonFinder = find.byKey(Key(Keys.nextRoundButtonKey));
    final prevRoundButtonFinder = find.byKey(Key(Keys.prevRoundButtonKey));
    final welcomeDialogGetStartedFinder =
        find.byKey(Key(Keys.getStartedButtonKey));
    testWidgets('Test Round Counter', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(welcomeDialogGetStartedFinder);
      await tester.pumpAndSettle();
      expect(find.text('Round 1'), findsOneWidget);

      await tester.tap(nextRoundButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Round 2'), findsOneWidget);

      await tester.tap(prevRoundButtonFinder);
      await tester.pumpAndSettle();
      expect(find.text('Round 1'), findsOneWidget);
    });
  });
}
