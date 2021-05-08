import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pref/pref.dart';

import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/helpers/keys.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/screens/character_screen.dart';

import '../test_helper.dart';

void main() {
  setUpAll(() {
    TestHelper.registerFallbacks();
  });

  group('Character Screen Form Tests', () {
    late PartyBloc partyBloc;

    setUp(() {
      partyBloc = MockPartyBloc();
    });
    testWidgets('Test Validators-EMPTY', (WidgetTester tester) async {
      when(() => partyBloc.state)
          .thenAnswer((_) => PartyLoadedSucess(Encounter()));
      when(() => partyBloc.add(any(that: MatchType<AddPartyCharacter>())))
          .thenReturn(null);

      await tester.pumpWidget(createCharacterScreen(partyBloc));

      await tester.pumpAndSettle();

      await tapButton(tester);

      expect(find.text('Please enter a name'), findsOneWidget);

      verifyNever(
          () => partyBloc.add(any(that: MatchType<AddPartyCharacter>())));
    });
  });

  group('Character Screen-Add Character', () {
    MockPartyBloc? partyBloc;

    setUp(() {
      partyBloc = MockPartyBloc();
    });
    testWidgets('Add Character-No Gen', (WidgetTester tester) async {
      when(() => partyBloc!.state)
          .thenAnswer((_) => PartyLoadedSucess(Encounter()));
      when(() => partyBloc!.add(any(that: MatchType<AddPartyCharacter>())))
          .thenReturn(null);

      var service = PrefServiceCache(cache: {'should_roll_init': false});

      var charToAdd = CharacterModel(
          characterName: 'Test Char', initiative: 12, hp: 12, notes: 'None');

      await tester
          .pumpWidget(createCharacterScreen(partyBloc, service: service));

      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Name'), charToAdd.characterName!);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextField, 'HP'), charToAdd.hp.toString());
      await tester.pumpAndSettle();

      await tester.enterText(find.widgetWithText(TextFormField, 'Initiative'),
          charToAdd.initiative.toString());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Notes'), charToAdd.notes!);
      await tester.pumpAndSettle();

      await tapButton(tester);
      await tester.pumpAndSettle();

      verify(() => partyBloc!.add(any(that: MatchType<AddPartyCharacter>())))
          .called(1);
    });

    testWidgets('Add Character-Gen', (WidgetTester tester) async {
      when(() => partyBloc!.state)
          .thenAnswer((_) => PartyLoadedSucess(Encounter()));
      when(() => partyBloc!.add(any(that: MatchType<AddPartyCharacter>())))
          .thenReturn(null);
      var charToAdd = CharacterModel(characterName: 'Test Char', hp: 12);
      var numCharacters = 2;

      var service = PrefServiceCache(cache: ({'should_roll_init': true}));

      await tester
          .pumpWidget(createCharacterScreen(partyBloc, service: service));

      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Name'), charToAdd.characterName!);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextField, 'HP'), charToAdd.hp.toString());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(Key(Keys.numUnitKey)), numCharacters.toString());

      await tapButton(tester);
      await tester.pumpAndSettle();

      verify(() => partyBloc!.add(any(that: MatchType<AddPartyCharacter>())))
          .called(numCharacters);
    });
  });

  group('Character Screen Edit Tests', () {
    MockPartyBloc? partyBloc;

    setUp(() {
      partyBloc = MockPartyBloc();
    });
    testWidgets('Test Edit', (WidgetTester tester) async {
      var service = PrefServiceCache(cache: {'should_roll_init': true});

      when(() => partyBloc!.state)
          .thenAnswer((_) => PartyLoadedSucess(Encounter()));
      when(() => partyBloc!.add(any(that: MatchType<AddPartyCharacter>())))
          .thenReturn(null);

      var charToEdit = CharacterModel(
          characterName: 'Test Char',
          initiative: 12,
          hp: 45,
          notes: 'My Notes');

      var editedChar = charToEdit.copyWith(hp: 25, initMod: 12);

      await tester.pumpWidget(BlocProvider<PartyBloc>(
          create: (context) => partyBloc!,
          child: createCharacterScreen(partyBloc,
              character: charToEdit, service: service)));

      await tester.pumpAndSettle();

      expect(find.text(charToEdit.characterName!), findsOneWidget);
      expect(find.text(charToEdit.notes!), findsOneWidget);
      expect(find.text(charToEdit.hp.toString()), findsOneWidget);
      expect(find.text(charToEdit.initiative.toString()), findsOneWidget);

      await tester.enterText(
          find.widgetWithText(TextField, charToEdit.hp.toString()),
          editedChar.hp.toString());
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(Key(Keys.initModKey)), editedChar.initMod.toString());

      await tester.pumpAndSettle();

      await tapButton(tester, character: charToEdit);
      await tester.pumpAndSettle();

      verify(() => partyBloc!.add(AddPartyCharacter(editedChar))).called(1);
    });
  });
}

Future<void> tapButton(WidgetTester tester, {CharacterModel? character}) async {
  var btnText = character == null ? 'Add Character' : 'Save Changes';
  await tester.tap(find.widgetWithText(ElevatedButton, btnText));
  await tester.pumpAndSettle();
}

Widget createCharacterScreen(PartyBloc? partyBloc,
    {CharacterModel? character, BasePrefService? service}) {
  service ??= PrefServiceCache();
  return PrefService(
    service: service,
    child: BlocProvider<PartyBloc>(
      create: (BuildContext context) => partyBloc!,
      child: MaterialApp(
        home: CharacterScreen(
          character: character,
        ),
      ),
    ),
  );
}
