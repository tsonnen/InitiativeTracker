import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/services/database.dart';
import 'package:preferences/preferences.dart';

import 'package:initiative_tracker/screens/party_screen.dart';
import 'package:initiative_tracker/preference_manger.dart';

import 'package:initiative_tracker/bloc/party/party_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: "pref_");

  await PreferenceManger.getPreferences();

  if (PreferenceManger.getSystemUUID() == null) {
    String systemUUID = await DBProvider.db.addInitialValues();
    await PreferenceManger.setSystemUUID(systemUUID);
  }

  runApp(new App());
}

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final PartyBloc _partyBloc = PartyBloc();
  final PartiesBloc _partiesBloc =
      PartiesBloc(PreferenceManger.getSystemUUID());

  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.dark,
        data: (brightness) => new ThemeData(brightness: brightness),
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
                title: 'Initiative Tracker',
                theme: theme,
                home: PartyScreen(),
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
