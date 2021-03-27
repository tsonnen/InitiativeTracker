import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/helpers/app_info.dart';
import 'package:initiative_tracker/helpers/legacy_convert.dart';
import 'package:initiative_tracker/moor/database.dart';
import 'package:preferences/preferences.dart';
import 'package:initiative_tracker/screens/party_screen.dart';
import 'package:initiative_tracker/helpers/preference_manger.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');

  await PreferenceManger.getPreferences();
  await AppInfo.getAppInfo();

  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  PartyBloc _partyBloc;
  PartiesBloc _partiesBloc;
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
    var firstLaunch = PreferenceManger.getFirstRun();
    PreferenceManger.setFirstRun(false);
    return DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => ThemeData(brightness: brightness),
        themedWidgetBuilder: (context, theme) {
          return MultiBlocProvider(
              providers: [
                BlocProvider<PartyBloc>(
                    create: (BuildContext context) => _partyBloc),
                BlocProvider<PartiesBloc>(
                  create: (BuildContext context) => _partiesBloc,
                )
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Initiative Tracker',
                theme: theme,
                home: PartyScreen(firstLaunch: firstLaunch),
              ));
        });
  }

  @override
  void dispose() {
    super.dispose();
    _partyBloc.drain();
    _partiesBloc.drain();
  }
}
