import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class TestHelper{
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
}