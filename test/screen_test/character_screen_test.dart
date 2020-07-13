import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/screens/character_screen.dart';
import 'package:initiative_tracker/uuid.dart';

import '../testHelpers.dart';

void main() {
  group("Character Screen Form Tests", () {
    PartyModel partyModel;

    setUp(() {
      partyModel = null;
      partyModel = PartyModel();
    });
    testWidgets("Test Validators-EMPTY", (WidgetTester tester) async {
      await tester.pumpWidget(createCharacterScreen(partyModel));

      await tester.pumpAndSettle();

      await tapButton(tester);

      expect(find.text('Please enter a name'), findsOneWidget);
      expect(find.text('Please enter valid HP'), findsOneWidget);
    });
  });

  group("Character Screen-Add Character", () {
    PartyModel partyModel;

    setUp(() {
      partyModel = null;
      partyModel = PartyModel();
    });
    testWidgets("Add Character-No Gen", (WidgetTester tester) async {
      CharacterModel charToAdd = CharacterModel(
          name: "Test Char", initiative: 12, hp: 12, notes: "None");

      await tester.pumpWidget(createCharacterScreen(partyModel));

      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, "Name"), charToAdd.characterName);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, "HP"), charToAdd.hp.toString());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, "Initiative"),
          charToAdd.initiative.toString());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, "Notes"), charToAdd.notes);
      await tester.pumpAndSettle();

      await tapButton(tester);
      await tester.pumpAndSettle();

      expect(partyModel.characters.length, 1);
      expect(partyModel.characters.first.compare(charToAdd), true);
    });

    testWidgets("Add Character-Gen", (WidgetTester tester) async {
      CharacterModel charToAdd = CharacterModel(name: "Test Char", hp: 12);
      int numCharacters = 4;

      await tester.pumpWidget(createCharacterScreen(partyModel));

      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, "Name"), charToAdd.characterName);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, "HP"), charToAdd.hp.toString());
      await tester.pumpAndSettle();

      DropdownButton dropdown =
          (tester.widget<Visibility>(find.byType(Visibility)).child as Flexible)
              .child;

      await TestHelper.selectItemInDropdown(
          tester, dropdown, numCharacters.toString());

      await tapButton(tester);
      await tester.pumpAndSettle();

      expect(partyModel.characters.length, numCharacters);
    });
  });

  group("Character Screen Edit Tests", () {
    PartyModel partyModel;
    PartyBloc partyBloc;

    setUp(() {
      partyModel = null;
      partyModel = PartyModel();
      partyBloc = new PartyBloc();

      partyBloc.add(PartyGenerated());
    });
    testWidgets("Test Edit", (WidgetTester tester) async {
      CharacterModel charToEdit = CharacterModel(
          name: "Test Char", initiative: 12, hp: 45, notes: "My Notes");

      partyBloc.add(PartyCharacterAdded(charToEdit));

      CharacterModel editedChar = charToEdit.clone();
      editedChar.hp = 25;

      await tester.pumpWidget(BlocProvider<PartyBloc>(
          create: (context) => partyBloc,
          child: createCharacterScreen(partyModel, character: charToEdit)));

      await tester.pumpAndSettle();

      expect(find.text(charToEdit.characterName), findsOneWidget);
      expect(find.text(charToEdit.notes), findsOneWidget);
      expect(find.text(charToEdit.hp.toString()), findsOneWidget);
      expect(find.text(charToEdit.initiative.toString()), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextFormField, charToEdit.hp.toString()),
          editedChar.hp.toString());
      await tester.pumpAndSettle();

      await tapButton(tester, character: charToEdit);
      await tester.pumpAndSettle();

      expect(partyModel.characters.length, 1);
      expect(partyModel.characters.first.hp, editedChar.hp);
    });
  });
}

Future<void> tapButton(WidgetTester tester, {CharacterModel character}) async {
  String btnText = character == null ? 'Add Character' : 'Edit Character';
  await tester.tap(find.widgetWithText(RaisedButton, btnText));
  await tester.pumpAndSettle();
}

//TODO: Update for BLOC
BlocProvider createCharacterScreen(PartyModel partyModel,
    {CharacterModel character}) {
      return null;
  // return new BlocProvider(
  //     child: MaterialApp(
  //         home: CharacterScreen(
  //       character: character,
  //     )),
  //     bloc: new PartyBloc());
}
