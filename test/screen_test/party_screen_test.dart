import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pref/pref.dart';

import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/models/character_list.dart';
import 'package:initiative_tracker/moor/database.dart';
import 'package:initiative_tracker/screens/party_management_screen.dart';
import 'package:initiative_tracker/screens/party_screen.dart';
import 'package:initiative_tracker/widgets/character_list.dart';
import 'package:initiative_tracker/widgets/party_screen_dialogs.dart';

import '../test_helper.dart';

void main() {
  setUpAll(() {
    TestHelper.registerFallbacks();
  });
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('plugins.flutter.io/path_provider');
  channel.setMockMethodCallHandler((MethodCall methodCall) async {
    return 'test_resources';
  });
  group('Home Screen Tests', () {
    late MockPartiesDao partiesDao;
    late List<Party> parties;
    late Encounter encounterModel;

    void partiesDaoMocks() {
      when(() => partiesDao.addParty(any(that: MatchType<Party>())))
          .thenAnswer((invocation) async {
        parties.add(invocation.positionalArguments.first);
        return parties.length;
      });
      when(() => partiesDao.allParties)
          .thenAnswer((invocation) async => parties);
      when(() => partiesDao.deleteParty(any(that: MatchType<Party>())))
          .thenAnswer((invocation) async {
        parties.remove(invocation.positionalArguments.first);
        return parties.length;
      });

      when(() => partiesDao.upsert(any(that: MatchType<Party>())))
          .thenAnswer((invocation) async {
        var party = invocation.positionalArguments.first as Party;
        var index = parties
            .indexWhere((element) => element.partyUUID == party.partyUUID);
        index != -1 ? parties[index] = party : parties.add(party);
      });
    }

    setUp(() {
      encounterModel = Encounter(
          characters: CharacterList(
              list: List<CharacterModel>.generate(
                  10,
                  (index) => CharacterModel(
                      characterName: 'Character $index',
                      hp: index,
                      initMod: index,
                      initiative: index,
                      notes: 'Notes for $index'))));

      parties = <Party>[];
      partiesDao = MockPartiesDao();

      partiesDaoMocks();
    });

    testWidgets('Should Route to Add Character Screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao), partyBloc: PartyBloc()));

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
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao),
          partyBloc: PartyBloc.load(encounterModel)));

      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(
              ListTile, encounterModel.characters!.first!.characterName!,
              skipOffstage: false),
          findsOneWidget);

      await tester.tap(find.descendant(
          of: find.widgetWithText(
              ExpansionTile, encounterModel.characters!.first!.characterName!),
          matching: find.byIcon(Icons.edit)));

      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Edit Character'), findsOneWidget);
    });

    testWidgets('Should Delete Character', (WidgetTester tester) async {
      var partyBloc = PartyBloc.load(encounterModel);
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao), partyBloc: partyBloc));

      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(
              ListTile, encounterModel.characters!.first!.characterName!,
              skipOffstage: false),
          findsOneWidget);

      await tester.tap(find.descendant(
          of: find.widgetWithText(
              ExpansionTile, encounterModel.characters!.first!.characterName!),
          matching: find.byIcon(Icons.delete)));

      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(
              ListTile, encounterModel.characters!.first!.characterName!,
              skipOffstage: false),
          findsNothing);
    });

    testWidgets('Test Round Counter', (WidgetTester tester) async {
      var partyBloc = PartyBloc.load(encounterModel);
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao), partyBloc: partyBloc));

      await tester.pumpAndSettle();

      expect(find.text('Round 1'), findsOneWidget);

      // Test round advance
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_next));
      await tester.pumpAndSettle();
      expect(find.text('Round 2'), findsOneWidget);

      // Test round advance
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_next));
      await tester.pumpAndSettle();
      expect(find.text('Round 3'), findsOneWidget);

      // Test going back a round
      await tester.tap(find.widgetWithIcon(IconButton, Icons.navigate_before));
      await tester.pumpAndSettle();
      expect(find.text('Round 2'), findsOneWidget);
    });

    testWidgets('Test Party Reset', (WidgetTester tester) async {
      var service = PrefServiceCache(cache: {'confirm_clear': false});
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao),
          partyBloc: PartyBloc.load(encounterModel),
          service: service));
      await tester.pumpAndSettle();

      expect(find.byType(CharacterCard, skipOffstage: false),
          findsNWidgets(encounterModel.characterCount));

      await tester.tap(find.widgetWithIcon(IconButton, Icons.clear));
      await tester.pumpAndSettle();
      expect(find.byType(CharacterCard, skipOffstage: false), findsNothing);
    });

    testWidgets('Test HP Changes', (WidgetTester tester) async {
      encounterModel = Encounter(
          characters: CharacterList(list: [
        CharacterModel(characterName: 'Joe', hp: 6, initiative: 7, notes: '')
      ]));

      var partyBloc = PartyBloc.load(encounterModel);
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao), partyBloc: partyBloc));

      await tester.pumpAndSettle();

      expect(
          find.widgetWithText(
              ListTile, encounterModel.characters!.first!.hp.toString(),
              skipOffstage: false),
          findsOneWidget);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.remove));
      await tester.pumpAndSettle();
      expect(
          find.widgetWithText(
              ListTile, encounterModel.characters!.first!.hp.toString(),
              skipOffstage: false),
          findsOneWidget);
      expect(encounterModel.characters!.first!.hp, 5);

      await tester.tap(find.widgetWithIcon(IconButton, Icons.add));
      await tester.pumpAndSettle();
      expect(
          find.widgetWithText(
              ListTile, encounterModel.characters!.first!.hp.toString(),
              skipOffstage: false),
          findsOneWidget);
      expect(encounterModel.characters!.first!.hp, 6);
    });

    testWidgets('Test Save Party', (WidgetTester tester) async {
      var partyBloc = PartyBloc.load(encounterModel);
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao), partyBloc: partyBloc));

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.save, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.byType(PartyNameDialog), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Saved Party');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(parties.length, 1);
    });

    testWidgets('Test Save Party -- Should not Overwrite',
        (WidgetTester tester) async {
      var service = PrefServiceCache(cache: {'confirm_overwrite': true});
      var partyBloc = PartyBloc.load(encounterModel);
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao),
          partyBloc: partyBloc,
          service: service));

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.save, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.byType(PartyNameDialog), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Saved Party');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(parties.length, 1);

      await tester.tap(find.byIcon(Icons.save, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.byType(PartyOverwriteDialog), findsOneWidget);
      await tester.tap(find.widgetWithText(TextButton, 'No'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Saved Party 2');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(parties.length, 2);
    });

    testWidgets('Test Party Management', (WidgetTester tester) async {
      var service = PrefServiceCache(cache: {'confirm_overwrite': true});
      var partyBloc = PartyBloc.load(encounterModel);
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao),
          partyBloc: partyBloc,
          service: service));

      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Saved Parties'));
      await tester.pumpAndSettle();

      expect(find.byType(PartyManagementScreen), findsOneWidget);
    });

    testWidgets('Test Help Route', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao), partyBloc: PartyBloc()));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.help, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Help'), findsOneWidget);
    });

    testWidgets('Test Settings Route', (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen(
          partiesBloc: PartiesBloc(partiesDao), partyBloc: PartyBloc()));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Open navigation menu'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.settings, skipOffstage: false));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Settings'), findsOneWidget);
    });
  });
}

Widget createHomeScreen(
    {required PartiesBloc partiesBloc,
    required PartyBloc partyBloc,
    BasePrefService? service}) {
  service ??= PrefServiceCache();
  return PrefService(
    service: service,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<PartyBloc>(create: (BuildContext context) => partyBloc),
        BlocProvider<PartiesBloc>(create: (BuildContext context) => partiesBloc)
      ],
      child: MaterialApp(
        home: PartyScreen(),
      ),
    ),
  );
}
