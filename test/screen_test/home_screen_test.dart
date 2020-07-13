import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/preference_manger.dart';

import 'package:initiative_tracker/screens/party_screen.dart';

void main() {
  group("Home Screen Tests", () {
    PartyListModel partyListModel;
    PartyModel partyModel;

    setUp(() {
      partyModel = partyListModel = null;
      partyListModel = PartyListModel();
      partyModel = PartyModel();
    });

    testWidgets("Should Route to Add Character Screen",
        (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      expect(
          find.widgetWithIcon(FloatingActionButton, Icons.add,
              skipOffstage: false),
          findsOneWidget);

      await tester.tap(find.widgetWithIcon(FloatingActionButton, Icons.add));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, "Add Character"), findsOneWidget);
    });

    testWidgets("Should Route to Edit Character Screen",
        (WidgetTester tester) async {
      partyModel.addCharacter(
          CharacterModel(name: "Joe", hp: 6, initiative: 7, notes: ""));
      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, "Joe", skipOffstage: false),
          findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, "Joe"));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, "Edit Character"), findsOneWidget);
    });

    testWidgets("Should Delete Character", (WidgetTester tester) async {
      partyModel.addCharacter(
          CharacterModel(name: "Joe", hp: 6, initiative: 7, notes: ""));
      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, "Joe", skipOffstage: false),
          findsOneWidget);

      await tester.longPress(find.widgetWithText(ListTile, "Joe"));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(ListTile, "Joe", skipOffstage: false),
          findsNothing);
    });

    testWidgets("Test Round Counter", (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      expect(partyModel.round, 1);
      checkTitleText(partyModel);

      // Test that we do not go to round 0
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_before));
      await tester.pumpAndSettle();
      expect(partyModel.round, 1);
      checkTitleText(partyModel);

      // Test round advance
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_next));
      await tester.pumpAndSettle();
      expect(partyModel.round, 2);
      checkTitleText(partyModel);

      // Test going back a round
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_before));
      await tester.pumpAndSettle();
      expect(partyModel.round, 1);
      checkTitleText(partyModel);
    });

    testWidgets("Test Party Reset", (WidgetTester tester) async {
      partyModel.addCharacter(
          CharacterModel(name: "Joe", hp: 6, initiative: 7, notes: ""));
      partyModel.round = 100;

      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      checkTitleText(partyModel);
      expect(find.widgetWithText(ListTile, "Joe", skipOffstage: false),
          findsOneWidget);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.refresh));
      await tester.pumpAndSettle();

      expect(partyModel.round, 1);
      checkTitleText(partyModel);
      expect(find.widgetWithText(ListTile, "Joe", skipOffstage: false),
          findsNothing);
    });

    testWidgets("Test HP Changes", (WidgetTester tester) async {
      partyModel.addCharacter(
          CharacterModel(name: "Joe", hp: 6, initiative: 7, notes: ""));
      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      checkTitleText(partyModel);
      expect(
          find.widgetWithText(
              ListTile, partyModel.characters.first.hp.toString(),
              skipOffstage: false),
          findsOneWidget);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.remove));
      await tester.pumpAndSettle();
      expect(
          find.widgetWithText(
              ListTile, partyModel.characters.first.hp.toString(),
              skipOffstage: false),
          findsOneWidget);
      expect(partyModel.characters.first.hp, 5);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
      await tester.pumpAndSettle();
      expect(
          find.widgetWithText(
              ListTile, partyModel.characters.first.hp.toString(),
              skipOffstage: false),
          findsOneWidget);
      expect(partyModel.characters.first.hp, 6);
    });

    testWidgets("Test Save Party", (WidgetTester tester) async {
      partyModel.addCharacter(
          CharacterModel(name: "Joe", hp: 6, initiative: 7, notes: ""));

      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.save, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.enterText(find.byType(TextField), "Saved Party");
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FlatButton, "Save"));
      await tester.pumpAndSettle();

      expect(partyListModel.parties.length, 1);
    });

    testWidgets("Test Party Management", (WidgetTester tester) async {
      partyModel.addCharacter(
          CharacterModel(name: "Joe", hp: 6, initiative: 7, notes: ""));
      partyModel.setName("Saved Party");

      partyListModel.addParty(partyModel);

      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.view_list, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text(partyModel.partyName), findsOneWidget);

      await tester.longPress(find.text(partyModel.partyName));
      await tester.pumpAndSettle();

      if (PreferenceManger.getConfirmDelete()) {
        expect(
            find.widgetWithText(AlertDialog,
                "Would you like to delete ${partyModel.partyName}?"),
            findsOneWidget);
        await tester.tap(find.text("Yes"));
        await tester.pumpAndSettle();
      }

      expect(find.text(partyModel.partyName), findsNothing);
      expect(find.text("No Saved Parties"), findsOneWidget);

      await tester.tap(find.widgetWithText(FlatButton, "Done"));
      await tester.pumpAndSettle();

      expect(partyListModel.parties.length, 0);
    });

    testWidgets("Test Help Route", (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.help_outline, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, "Help"), findsOneWidget);
    });

    testWidgets("Test Settings Route", (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen(partyListModel, partyModel));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, "Preferences"), findsOneWidget);
    });
  });
}

void checkTitleText(PartyModel partyModel) {
  expect(find.widgetWithText(AppBar, "Round " + partyModel.round.toString()),
      findsOneWidget);
}

// TODO: Update for BlocProvider
Widget createHomeScreen(
    PartyListModel partyListModel, PartyModel partyModel) {
      return null;
  // return new MultiBlocProvider(
  //     model: partyModel,
  //     child: ScopedModel<PartyListModel>(
  //         model: partyListModel, child: MaterialApp(home: PartyScreen())));
}
