import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/screens/character_screen.dart';
import 'package:mockito/mockito.dart';

import '../testHelpers.dart';

void main() {
  group('Character Screen Form Tests', () {
    PartyBloc partyBloc;

    setUp(() {
      partyBloc = MockPartyBloc();
    });
    testWidgets('Test Validators-EMPTY', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(PartyModel()));
      when(partyBloc.add(argThat(MatchType<AddPartyCharacter>())))
          .thenReturn(null);

      await tester.pumpWidget(createCharacterScreen(partyBloc));

      await tester.pumpAndSettle();

      await tapButton(tester);

      expect(find.text('Please enter a name'), findsOneWidget);

      verifyNever(partyBloc.add(argThat(MatchType<AddPartyCharacter>())));
    });
  });

  group('Character Screen-Add Character', () {
    PartyBloc partyBloc;

    setUp(() {
      partyBloc = MockPartyBloc();
    });
    testWidgets('Add Character-No Gen', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(PartyModel()));
      when(partyBloc.add(argThat(MatchType<AddPartyCharacter>())))
          .thenReturn(null);

      var charToAdd = CharacterModel(
          name: 'Test Char', initiative: 12, hp: 12, notes: 'None');

      await tester.pumpWidget(createCharacterScreen(partyBloc));

      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Name'), charToAdd.characterName);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextField, 'HP'), charToAdd.hp.toString());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Initiative'),
          charToAdd.initiative.toString());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Notes'), charToAdd.notes);
      await tester.pumpAndSettle();

      await tapButton(tester);
      await tester.pumpAndSettle();

      verify(partyBloc.add(argThat(MatchType<AddPartyCharacter>()))).called(1);
    });

    testWidgets('Add Character-Gen', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(PartyModel()));
      when(partyBloc.add(argThat(MatchType<AddPartyCharacter>())))
          .thenReturn(null);
      var charToAdd = CharacterModel(name: 'Test Char', hp: 12);
      var numCharacters = 4;

      await tester.pumpWidget(createCharacterScreen(partyBloc));

      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Name'), charToAdd.characterName);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextField, 'HP'), charToAdd.hp.toString());
      await tester.pumpAndSettle();

      DropdownButton dropdown =
          (tester.widget<Visibility>(find.byType(Visibility)).child as Flexible)
              .child;

      await TestHelper.selectItemInDropdown(
          tester, dropdown, numCharacters.toString());

      await tapButton(tester);
      await tester.pumpAndSettle();

      verify(partyBloc.add(argThat(MatchType<AddPartyCharacter>()))).called(4);
    });
  });

  group('Character Screen Edit Tests', () {
    PartyBloc partyBloc;

    setUp(() {
      partyBloc = MockPartyBloc();
    });
    testWidgets('Test Edit', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(PartyModel()));
      when(partyBloc.add(argThat(MatchType<AddPartyCharacter>())))
          .thenReturn(null);

      var charToEdit = CharacterModel(
          name: 'Test Char', initiative: 12, hp: 45, notes: 'My Notes');

      var editedChar = charToEdit.clone();
      editedChar.hp = 25;

      await tester.pumpWidget(BlocProvider<PartyBloc>(
          create: (context) => partyBloc,
          child: createCharacterScreen(partyBloc, character: charToEdit)));

      await tester.pumpAndSettle();

      expect(find.text(charToEdit.characterName), findsOneWidget);
      expect(find.text(charToEdit.notes), findsOneWidget);
      expect(find.text(charToEdit.hp.toString()), findsOneWidget);
      expect(find.text(charToEdit.initiative.toString()), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextField, charToEdit.hp.toString()),
          editedChar.hp.toString());
      await tester.pumpAndSettle();

      await tapButton(tester, character: charToEdit);
      await tester.pumpAndSettle();

      verify(partyBloc.add(AddPartyCharacter(editedChar))).called(1);
    });
  });
}

Future<void> tapButton(WidgetTester tester, {CharacterModel character}) async {
  var btnText = character == null ? 'Add Character' : 'Edit Character';
  await tester.tap(find.widgetWithText(RaisedButton, btnText));
  await tester.pumpAndSettle();
}

Widget createCharacterScreen(PartyBloc partyBloc, {CharacterModel character}) {
  return BlocProvider(
      create: (BuildContext context) => partyBloc,
      child: MaterialApp(
          home: CharacterScreen(
        character: character,
      )));
}
