import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/models/character_list.dart';
import 'package:initiative_tracker/screens/party_management_screen.dart';
import 'package:initiative_tracker/screens/party_screen.dart';
import 'package:initiative_tracker/widgets/party_screen_dialogs.dart';
import 'package:mockito/mockito.dart';

import '../testHelpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/path_provider');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return 'test_resources';
  });
  group('Home Screen Tests', () {
    PartiesBloc partiesBloc;
    PartyBloc partyBloc;
    Encounter partyModel;

    setUp(() {
      partiesBloc = MockPartiesBloc();
      partyBloc = MockPartyBloc();
      partyModel = Encounter(
          characters: CharacterList(list: [
        CharacterModel(characterName: 'Joe', hp: 6, initiative: 7, notes: '')
      ]));
    });

    testWidgets('Should Route to Add Character Screen',
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

      expect(find.widgetWithText(AppBar, 'Add Character'), findsOneWidget);
    });

    testWidgets('Should Route to Edit Character Screen',
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

      await tester.tap(find.descendant(
          of: find.widgetWithText(
              ExpansionTile, partyModel.characters.first.characterName),
          matching: find.byIcon(Icons.edit)));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Edit Character'), findsOneWidget);
    });

    testWidgets('Should Delete Character', (WidgetTester tester) async {
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

      await tester.tap(find.descendant(
          of: find.widgetWithText(
              ExpansionTile, partyModel.characters.first.characterName),
          matching: find.byIcon(Icons.delete)));

      await tester.pumpAndSettle();

      verify(partyBloc.add(argThat(MatchType<DeletePartyCharacter>())))
          .called(1);
    });

    testWidgets('Test Round Counter', (WidgetTester tester) async {
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

      // Test round advance
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_next));
      await tester.pumpAndSettle();
      verify(partyBloc.add(ChangeRound(roundForward: true))).called(1);

      // Test going back a round
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_before));
      await tester.pumpAndSettle();
      verify(partyBloc.add(ChangeRound(roundForward: false))).called(1);
    });

    testWidgets('Test Party Reset', (WidgetTester tester) async {
      await TestHelper.setMockPrefs({'pref_confirm_clear': false});
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      when(partyBloc.add(argThat(MatchType<GenerateParty>()))).thenReturn(null);
      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithIcon(IconButton, Icons.clear));
      await tester.pumpAndSettle();

      verify(partyBloc.add(argThat(MatchType<GenerateParty>()))).called(1);
    });

    //TODO: Work on this
    testWidgets('Test HP Changes', (WidgetTester tester) async {
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

    testWidgets('Test Save Party', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      when(partiesBloc.add(argThat(MatchType<AddParty>()))).thenReturn(null);

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.save, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.byType(PartyNameDialog), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Saved Party');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      verify(partiesBloc.add(argThat(MatchType<AddParty>()))).called(1);
    });

    testWidgets('Test Party Management', (WidgetTester tester) async {
      partyModel = partyModel.copyWith(partyName: 'SAVED PARTY');
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      when(partiesBloc.add(argThat(MatchType<DeleteParty>()))).thenReturn(null);

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saved Parties'));
      await tester.pumpAndSettle();

      expect(find.byType(PartyManagementScreen), findsOneWidget);
    });

    testWidgets('Test Help Route', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));
      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.help, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Help'), findsOneWidget);
    });

    testWidgets('Test Settings Route', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful([partyModel]));

      await tester.pumpWidget(createHomeScreen(partiesBloc, partyBloc));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Preferences'), findsOneWidget);
    });
  });
}

void checkTitleText(Encounter partyModel) {
  expect(find.widgetWithText(AppBar, 'Round ' + partyModel.round.toString()),
      findsOneWidget);
}

Widget createHomeScreen(MockPartiesBloc partiesBloc, MockPartyBloc partyBloc) {
  return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) => ThemeData(brightness: brightness),
      themedWidgetBuilder: (context, theme) {
        return MultiBlocProvider(providers: [
          BlocProvider<PartyBloc>(create: (BuildContext context) => partyBloc),
          BlocProvider<PartiesBloc>(
              create: (BuildContext context) => partiesBloc)
        ], child: MaterialApp(home: PartyScreen()));
      });
}
