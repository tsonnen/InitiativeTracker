import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/helpers/keys.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/screens/character_screen.dart';
import 'package:initiative_tracker/widgets/form_widgets.dart';
import 'package:mockito/mockito.dart';

import '../testHelpers.dart';

void main() {
  group('Character Screen Form Tests', () {
    PartyBloc partyBloc;

    setUp(() {
      partyBloc = MockPartyBloc();
    });
    testWidgets('Test Validators-EMPTY', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(Encounter()));
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
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(Encounter()));
      when(partyBloc.add(argThat(MatchType<AddPartyCharacter>())))
          .thenReturn(null);

      await TestHelper.setMockPrefs({'pref_should_roll_init': false});

      var charToAdd = CharacterModel(
          characterName: 'Test Char', initiative: 12, hp: 12, notes: 'None');

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
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(Encounter()));
      when(partyBloc.add(argThat(MatchType<AddPartyCharacter>())))
          .thenReturn(null);
      var charToAdd = CharacterModel(characterName: 'Test Char', hp: 12);
      var numCharacters = 2;

      await TestHelper.setMockPrefs({'pref_should_roll_init': true});

      await tester.pumpWidget(createCharacterScreen(partyBloc));

      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Name'), charToAdd.characterName);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextField, 'HP'), charToAdd.hp.toString());
      await tester.pumpAndSettle();

      var spinner =
          tester.widget<SpinnerButton>(find.byKey(Key(Keys.numUnitKey)));

      await TestHelper.selectItemInSpinner(tester, spinner, numCharacters);

      await tapButton(tester);
      await tester.pumpAndSettle();

      verify(partyBloc.add(argThat(MatchType<AddPartyCharacter>())))
          .called(numCharacters);
    });
  });

  group('Character Screen Edit Tests', () {
    PartyBloc partyBloc;

    setUp(() {
      partyBloc = MockPartyBloc();
    });
    testWidgets('Test Edit', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(Encounter()));
      when(partyBloc.add(argThat(MatchType<AddPartyCharacter>())))
          .thenReturn(null);

      var charToEdit = CharacterModel(
          characterName: 'Test Char',
          initiative: 12,
          hp: 45,
          notes: 'My Notes');

      var editedChar = charToEdit.copyWith();
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
  var btnText = character == null ? 'Add Character' : 'Save Changes';
  await tester.tap(find.widgetWithText(ElevatedButton, btnText));
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
