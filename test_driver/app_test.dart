// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import 'package:initiative_tracker/helpers/keys.dart';

void main() {
  group('Initiative Tracker App', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final nextRoundButtonFinder = find.byValueKey(Keys.nextRoundButtonKey);
    final prevRoundButtonFinder = find.byValueKey(Keys.prevRoundButtonKey);
    final roundTextFinder = find.byValueKey(Keys.roundCounterKey);
    final welcomeDialogFinder = find.byValueKey(Keys.welcomeDialogKey);
    final welcomeDialogGetStartedFinder =
        find.byValueKey(Keys.getStartedButtonKey);

    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Test Round Counter', () async {
      await driver.waitFor(welcomeDialogFinder);
      await driver.tap(welcomeDialogGetStartedFinder);

      expect(await driver.getText(roundTextFinder), 'Round 1');

      await driver.tap(nextRoundButtonFinder);
      expect(await driver.getText(roundTextFinder), 'Round 2');

      await driver.tap(prevRoundButtonFinder);
      expect(await driver.getText(roundTextFinder), 'Round 1');
    });
  });
}
