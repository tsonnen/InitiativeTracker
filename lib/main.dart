import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pref/pref.dart';
import 'package:provider/provider.dart';

import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/helpers/app_info.dart';
import 'package:initiative_tracker/helpers/legacy_convert.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:initiative_tracker/helpers/theme.dart';
import 'package:initiative_tracker/moor/database.dart';
import 'package:initiative_tracker/screens/party_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final service = await PrefServiceShared.init(prefix: 'pref_', defaults: {
    'ui_theme': 'dark',
    'should_roll_init': true,
    'num_dice': '1',
    'num_sides': '20',
    'confirm_clear': true,
    'confirm_delete': true,
    'show_hp': true,
    'show_init': true,
    'show_notes': false
  });

  await PreferenceManger.getPreferences();
  AppInfo.getAppInfo();

  runApp(PrefService(
      service: service,
      child: ChangeNotifierProvider<ThemeNotifier>(
          create: (context) =>
              ThemeNotifier(CustomTheme.mapTheme(service.get('ui_theme'))),
          child: App())));
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  late PartyBloc _partyBloc;
  late PartiesBloc _partiesBloc;
  final partiesDao = Database().partiesDao;

  @override
  void initState() {
    ConvertLegacy.addLegacyParties(Colors.blueGrey, partiesDao);

    _partiesBloc = PartiesBloc(partiesDao);
    _partyBloc = PartyBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    var firstLaunch = PreferenceManger.getFirstRun();
    PreferenceManger.setFirstRun(false);
    return MultiBlocProvider(
        providers: [
          BlocProvider<PartyBloc>(create: (BuildContext context) => _partyBloc),
          BlocProvider<PartiesBloc>(
            create: (BuildContext context) => _partiesBloc,
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Initiative Tracker',
          theme: themeNotifier.getTheme(),
          home: PartyScreen(firstLaunch: firstLaunch),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
