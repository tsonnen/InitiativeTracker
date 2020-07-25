import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:initiative_tracker/bloc/parties/parties_bloc.dart';
import 'package:initiative_tracker/bloc/party/party_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'dart:io';

class MockPartyBloc extends MockBloc<PartyState> implements PartyBloc {}

class MockPartiesBloc extends MockBloc<PartiesState> implements PartiesBloc {
  String systemUUID;

  MockPartiesBloc(this.systemUUID);
}

class TestHelper {
  static void dumpTree() {
    assert(WidgetsBinding.instance != null);
    String mode = 'RELEASE MODE';
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

  // Fix for CI not working for testfiles
  static String testPath(String relativePath) {
    Directory current = Directory.current;
    String path =
        current.path.endsWith('/test') ? "../": "";
    path =  path + relativePath;

    return path;
  }
}

class MatchType<T> extends Matcher {
  MatchType();

  @override
  Description describe(Description description) =>
      description.add("Item of type ${T.runtimeType}");

  @override
  bool matches(desc, Map matchState) {
    return desc is T;
  }
}
