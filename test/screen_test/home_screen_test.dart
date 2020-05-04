import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/party_list_model.dart';
import 'package:initiative_tracker/party_model.dart';

import 'package:initiative_tracker/screens/home_screen.dart';
import 'package:scoped_model/scoped_model.dart';

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
  });
}

ScopedModel createHomeScreen(
    PartyListModel partyListModel, PartyModel partyModel) {
  return new ScopedModel<PartyModel>(
      model: partyModel,
      child: ScopedModel<PartyListModel>(
          model: partyListModel, child: MaterialApp(home: HomeScreen())));
}
