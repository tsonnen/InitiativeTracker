import 'package:flutter/material.dart';

class TestHelper{
  static void debugDumpApp() {
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
}