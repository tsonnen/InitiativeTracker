import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/models/encounter.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:initiative_tracker/widgets/dialogs.dart';
import 'package:initiative_tracker/widgets/party_screen_dialogs.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../testHelpers.dart';

void main() {
  group('PartyName Dialog', () {
    final name = 'coolParty';
    setUp(() {});

    testWidgets('Check Content', (WidgetTester tester) async {
      await tester
          .pumpWidget(TestHelper.createDialogTestScreen(PartyNameDialog()));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.text('Enter a Name'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'Cancel'), findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'Save'), findsOneWidget);
    });

    testWidgets('Check Save', (WidgetTester tester) async {
      var mockObserver = MockNavigatorObserver();

      when(mockObserver.didPop(any, any)).thenAnswer((realInvocation) async {
        var value =
            await (realInvocation.positionalArguments.first as Route).popped;
        expect(value, name);
      });
      await tester
          .pumpWidget(TestHelper.createDialogTestScreen(PartyNameDialog()));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), name);

      await tester.tap(find.widgetWithText(FlatButton, 'Save'));

      await tester.pumpAndSettle();
    });

    testWidgets('Check Cancel', (WidgetTester tester) async {
      var mockObserver = MockNavigatorObserver();

      when(mockObserver.didPop(any, any)).thenAnswer((realInvocation) async {
        var value =
            await (realInvocation.positionalArguments.first as Route).popped;
        expect(value, null);
      });
      await tester
          .pumpWidget(TestHelper.createDialogTestScreen(PartyNameDialog()));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), name);

      await tester.tap(find.widgetWithText(FlatButton, 'Cancel'));

      await tester.pumpAndSettle();
    });
  });

  group('PartyLoad Dialog', () {
    final name = 'coolParty';
    setUp(() {});

    testWidgets('Check Content', (WidgetTester tester) async {
      await tester.pumpWidget(
          TestHelper.createDialogTestScreen(PartyLoadDialog(name: name)));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationDialog), findsOneWidget);
      expect(find.text('Load'), findsOneWidget);
      expect(find.text('Would you like to load $name?'), findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'Yes'), findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'No'), findsOneWidget);
    });
  });

  group('PartyDelete Dialog', () {
    final name = 'coolParty';
    setUp(() {});

    testWidgets('Check Content', (WidgetTester tester) async {
      await tester.pumpWidget(
          TestHelper.createDialogTestScreen(PartyDeleteDialog(name: name)));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationDialog), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
      expect(find.text('Do you want to delete $name'), findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'Yes'), findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'No'), findsOneWidget);
    });
  });

  group('PartyOverwrite Dialog', () {
    final name = 'coolParty';
    setUp(() {});

    testWidgets('Check Content', (WidgetTester tester) async {
      await tester.pumpWidget(
          TestHelper.createDialogTestScreen(PartyOverwriteDialog(name: name)));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationDialog), findsOneWidget);
      expect(find.text('Overwrite'), findsOneWidget);
      expect(
          find.text(
              'This party is already saved as $name\nWould you like to overwrite it?'),
          findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'Yes'), findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'No'), findsOneWidget);
    });
  });

  group('Parties Dialog', () {
    PartyBloc partyBloc;
    PartiesBloc partiesBloc;
    Encounter partyModel;
    List<Encounter> partyList;
    SharedPreferences.setMockInitialValues({});

    setUp(() {
      partyBloc = MockPartyBloc();
      partiesBloc = MockPartiesBloc();

      partyModel = Encounter(partyName: 'CoolParty');
      partyList = [partyModel];
    });

    testWidgets('Check Content - PartiesInitial', (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state).thenAnswer((_) => PartiesInitial());
      when(partiesBloc.add(argThat(MatchType<LoadParties>()))).thenReturn(null);

      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<PartyBloc>(create: (BuildContext context) => partyBloc),
        BlocProvider<PartiesBloc>(create: (BuildContext context) => partiesBloc)
      ], child: TestHelper.createDialogTestScreen(PartiesDialog())));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.byType(PartiesDialog), findsOneWidget);
      expect(find.text('Manage Parties'), findsOneWidget);
      expect(find.text('Loading'), findsOneWidget);
      expect(find.widgetWithText(FlatButton, 'Done'), findsOneWidget);

      verify(partiesBloc.add(LoadParties())).called(1);
    });

    testWidgets('Check Content - PartiesLoadedSuccessful',
        (WidgetTester tester) async {
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful(partyList));
      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<PartyBloc>(create: (BuildContext context) => partyBloc),
        BlocProvider<PartiesBloc>(create: (BuildContext context) => partiesBloc)
      ], child: TestHelper.createDialogTestScreen(PartiesDialog())));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.byType(PartiesDialog), findsOneWidget);
      expect(find.text('Manage Parties'), findsOneWidget);
      partyList.forEach((element) {
        expect(
            find.widgetWithText(ListTile, element.partyName), findsOneWidget);
      });
      expect(find.widgetWithText(FlatButton, 'Done'), findsOneWidget);
    });

    testWidgets('Check Delete - No Confirm', (WidgetTester tester) async {
      await PreferenceManger.setConfirmDelete(false);
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful(partyList));
      when(partiesBloc.add(DeleteParty(partyModel))).thenReturn(null);
      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<PartyBloc>(create: (BuildContext context) => partyBloc),
        BlocProvider<PartiesBloc>(create: (BuildContext context) => partiesBloc)
      ], child: TestHelper.createDialogTestScreen(PartiesDialog())));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.byType(PartiesDialog), findsOneWidget);
      await tester
          .longPress(find.widgetWithText(ListTile, partyModel.partyName));

      await tester.pumpAndSettle();

      verify(partiesBloc.add(DeleteParty(partyModel))).called(1);
    });

    testWidgets('Check Delete - Confirm', (WidgetTester tester) async {
      await PreferenceManger.setConfirmDelete(true);
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful(partyList));
      when(partiesBloc.add(DeleteParty(partyModel))).thenReturn(null);

      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<PartyBloc>(create: (BuildContext context) => partyBloc),
        BlocProvider<PartiesBloc>(create: (BuildContext context) => partiesBloc)
      ], child: TestHelper.createDialogTestScreen(PartiesDialog())));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.byType(PartiesDialog), findsOneWidget);
      await tester
          .longPress(find.widgetWithText(ListTile, partyModel.partyName));

      await tester.pumpAndSettle();

      verifyNever(partiesBloc.add(DeleteParty(partyModel)));

      expect(find.byType(PartyDeleteDialog), findsOneWidget);

      await tester.tap(find.descendant(
          of: find.byType(PartyDeleteDialog),
          matching: find.widgetWithText(FlatButton, 'Yes')));

      verify(partiesBloc.add(DeleteParty(partyModel))).called(1);
    });

    testWidgets('Check Load - No Confirm', (WidgetTester tester) async {
      await PreferenceManger.setConfirmLoad(false);
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful(partyList));
      when(partyBloc.add(LoadParty(partyModel))).thenReturn(null);

      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<PartyBloc>(create: (BuildContext context) => partyBloc),
        BlocProvider<PartiesBloc>(create: (BuildContext context) => partiesBloc)
      ], child: TestHelper.createDialogTestScreen(PartiesDialog())));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.byType(PartiesDialog), findsOneWidget);
      await tester.tap(find.widgetWithText(ListTile, partyModel.partyName));

      await tester.pumpAndSettle();

      verify(partyBloc.add(LoadParty(partyModel))).called(1);
    });

    testWidgets('Check Load - Confirm', (WidgetTester tester) async {
      await PreferenceManger.setConfirmLoad(true);
      when(partyBloc.state).thenAnswer((_) => PartyLoadedSucess(partyModel));
      when(partiesBloc.state)
          .thenAnswer((_) => PartiesLoadedSuccessful(partyList));
      when(partyBloc.add(LoadParty(partyModel))).thenReturn(null);

      await tester.pumpWidget(MultiBlocProvider(providers: [
        BlocProvider<PartyBloc>(create: (BuildContext context) => partyBloc),
        BlocProvider<PartiesBloc>(create: (BuildContext context) => partiesBloc)
      ], child: TestHelper.createDialogTestScreen(PartiesDialog())));
      await tester.pumpAndSettle();
      await TestHelper.openDialog(tester);
      await tester.pumpAndSettle();

      expect(find.byType(PartiesDialog), findsOneWidget);
      await tester.tap(find.widgetWithText(ListTile, partyModel.partyName));

      await tester.pumpAndSettle();

      verifyNever(partyBloc.add(LoadParty(partyModel)));

      expect(find.byType(PartyLoadDialog), findsOneWidget);

      await tester.tap(find.descendant(
          of: find.byType(PartyLoadDialog),
          matching: find.widgetWithText(FlatButton, 'Yes')));

      verify(partyBloc.add(LoadParty(partyModel))).called(1);
    });
  });
}
