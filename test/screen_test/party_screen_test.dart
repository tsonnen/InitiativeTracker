import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/party_model.dart';
import 'package:initiative_tracker/preference_manger.dart';

import 'package:initiative_tracker/screens/party_screen.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:mockito/mockito.dart';

import '../testHelpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return "test_resources";
  });
  group("Home Screen Tests", () {
    PartiesBloc partiesBloc;
    PartyBloc partyBloc;
    final String systemUUID = Uuid().generateV4();
    PartyModel partyModel;

    setUp(() {
      partiesBloc = MockPartiesBloc(systemUUID);
      partyBloc = MockPartyBloc();
      partyModel = PartyModel(characters: [
        CharacterModel(name: "Joe", hp: 6, initiative: 7, notes: "")
      ]);
    });

    testWidgets("Should Route to Add Character Screen",
        (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));
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
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));

      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(
              ListTile, partyModel.characters.first.characterName,
              skipOffstage: false),
          findsOneWidget);

      await tester.tap(find.widgetWithText(
          ListTile, partyModel.characters.first.characterName));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, "Edit Character"), findsOneWidget);
    });

    testWidgets("Should Delete Character", (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      when(partyBloc.add(argThat(MatchType<DeletePartyCharacter>())))
          .thenReturn(null);

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));

      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(
              ListTile, partyModel.characters.first.characterName,
              skipOffstage: false),
          findsOneWidget);

      await tester.longPress(find.widgetWithText(
          ListTile, partyModel.characters.first.characterName));

      await tester.pumpAndSettle();

      verify(partyBloc.add(argThat(MatchType<DeletePartyCharacter>())))
          .called(1);
    });

    testWidgets("Test Round Counter", (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      when(partyBloc.add(argThat(MatchType<ChangeRound>()))).thenReturn(null);

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));

      await tester.pumpAndSettle();

      // Test round advance
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_next));
      await tester.pumpAndSettle();
      verify(partyBloc.add(ChangeRound(roundForward: true))).called(1);

      // Test going back a round
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_before));
      await tester.pumpAndSettle();
      verify(partyBloc.add(ChangeRound(roundForward: false))).called(1);
    });

    testWidgets("Test Party Reset", (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      when(partyBloc.add(argThat(MatchType<GenerateParty>()))).thenReturn(null);

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithIcon(IconButton, Icons.refresh));
      await tester.pumpAndSettle();

      verify(partyBloc.add(argThat(MatchType<GenerateParty>()))).called(1);
    });

    testWidgets("Test HP Changes", (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));

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

// TODO: Split popup tests into seperate file
    testWidgets("Test Save Party", (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      when(partiesBloc.add(argThat(MatchType<AddParty>()))).thenReturn(null);

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));

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

      verify(partiesBloc.add(AddParty(partyModel))).called(1);
    });

    testWidgets("Test Party Management", (WidgetTester tester) async {
      partyModel.partyName = "SAVED PARTY";
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      when(partiesBloc.add(argThat(MatchType<DeleteParty>()))).thenReturn(null);

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));

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

      verify(partiesBloc.add(DeleteParty(partyModel.partyUUID))).called(1);
    });

    testWidgets("Test Help Route", (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));

      await tester.pumpAndSettle();

      await tester.tap(find.byType(PopupMenuButton));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.help_outline, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, "Help"), findsOneWidget);
    });

    testWidgets("Test Settings Route", (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));

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

Widget createHomeScreen(MockPartiesBloc partiesBloc, MockPartyBloc partyBloc) {
  return new MultiBlocProvider(providers: [
    BlocProvider<PartyBloc>(create: (BuildContext context) => partyBloc),
    BlocProvider<PartiesBloc>(create: (BuildContext context) => partiesBloc)
  ], child: MaterialApp(home: PartyScreen()));
}
