import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:initiative_tracker/preference_manger.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockPartyBloc extends MockBloc<PartyState> implements PartyBloc {}

class MockPartiesBloc extends MockBloc<PartiesState> implements PartiesBloc {
  MockPartiesBloc();
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String> getApplicationDocumentsPath() async {
    var dir = Directory.current;
    while (!await dir
        .list()
        .any((entity) => entity.path.endsWith('pubspec.yaml'))) {
      dir = dir.parent;
    }
    return join(dir.path, 'test_resources');
  }
}

class TestHelper {
  static void dumpTree() {
    assert(WidgetsBinding.instance != null);
    var mode = 'RELEASE MODE';
    assert(() {
      mode = 'CHECKED MODE';
      return true;
    }());
    debugPrint('${WidgetsBinding.instance.runtimeType} - $mode');
    if (WidgetsBinding.instance.renderViewElement != null) {
      debugPrint(WidgetsBinding.instance.renderViewElement.toStringDeep());
    } else {
      debugPrint('<no tree currently mounted>');
    }
  }

  static Future<void> setMockPrefs(Map<String, dynamic> values) async{
    SharedPreferences.setMockInitialValues(values);
    await PreferenceManger.getPreferences();
  }

  static Future<void> selectItemInDropdown(
      WidgetTester tester, DropdownButton dropdown, String item) async {
    await tester.tap(find.byWidget(dropdown));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text(item).last);

    await tester.pump();
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));
  }

  static Future<void> openDialog(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(FlatButton, 'Open Dialog'));
  }

  static Future<File> getProjectFile(String path) async {
    var dir = Directory.current;
    while (!await dir
        .list()
        .any((entity) => entity.path.endsWith('pubspec.yaml'))) {
      dir = dir.parent;
    }
    return File('${dir.path}/$path');
  }

  static Widget createDialogTestScreen(Widget dialog,
      {List<NavigatorObserver> navigatorObservers =
          const <NavigatorObserver>[]}) {
    return MaterialApp(
      home: DialogTestScreen(dialog: dialog),
      navigatorObservers: navigatorObservers,
    );
  }
}

class MatchType<T> extends Matcher {
  MatchType();

  @override
  Description describe(Description description) =>
      description.add('Item of type ${T.runtimeType}');

  @override
  bool matches(desc, Map matchState) {
    return desc is T;
  }
}

class DialogTestScreen extends StatelessWidget {
  final Widget dialog;

  DialogTestScreen({@required this.dialog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FlatButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return dialog;
                  });
            },
            child: Text('Open Dialog')));
  }
}
