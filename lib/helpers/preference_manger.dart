import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManger {
  static SharedPreferences prefs;

  static bool getFirstRun() {
    if (prefs != null) {
      return prefs.getBool('pref_first_run') ?? true;
    }
    return true;
  }

  static void setFirstRun(bool value) async {
    if (prefs != null) {
      await prefs.setBool('pref_first_run', value);
    } else {
      await getPreferences();
      await setFirstRun(value);
    }
  }

  static int getNumberDice() {
    if (prefs != null) {
      var numDice = prefs.getString('pref_num_dice') ?? '';
      return int.tryParse(numDice) ?? 1;
    }
    return 1;
  }

  static int getNumberSides() {
    if (prefs != null) {
      var numSides = prefs.getString('pref_num_sides') ?? '';
      return int.tryParse(numSides) ?? 20;
    }
    return 20;
  }

  static bool getConfirmDelete() {
    if (prefs != null) {
      return prefs.getBool('pref_confirm_delete') ?? true;
    }
    return true;
  }

  static bool getConfirmOverwrite() {
    if (prefs != null) {
      return prefs.getBool('pref_confirm_overwrite') ?? true;
    }
    return true;
  }

  static bool getConfirmLoad() {
    if (prefs != null) {
      return prefs.getBool('pref_confirm_load') ?? true;
    }
    return true;
  }

  static bool getShowHP() {
    if (prefs != null) {
      return prefs.getBool('pref_show_hp') ?? true;
    }
    return true;
  }

  static bool getShowNotes() {
    if (prefs != null) {
      return prefs.getBool('pref_show_notes') ?? true;
    }
    return true;
  }

  static bool getConfirmClearParty() {
    if (prefs != null) {
      return prefs.getBool('pref_confirm_clear') ?? true;
    }
    return true;
  }

  static bool getShowInitiative() {
    if (prefs != null) {
      return prefs.getBool('pref_show_initiative') ?? true;
    }
    return true;
  }

  static String getSystemUUID() {
    return prefs?.getString('pref_systemuuid');
  }

  static Future<void> getPreferences() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  static bool getRollInititative() {
    if (prefs != null) {
      return prefs.getBool('pref_should_roll_init') ?? true;
    }
    return true;
  }

  static Future<void> setSystemUUID(String systemUUID) async {
    if (prefs != null) {
      await prefs.setString('pref_systemuuid', systemUUID);
    } else {
      await getPreferences();
      await setSystemUUID(systemUUID);
    }
  }

  static Future<void> setConfirmLoad(bool confirm) async {
    if (prefs != null) {
      await prefs.setBool('pref_confirm_load', confirm);
    } else {
      await getPreferences();
      await setConfirmLoad(confirm);
    }
  }

  static Future<void> setConfirmDelete(bool confirm) async {
    if (prefs != null) {
      await prefs.setBool('pref_confirm_delete', confirm);
    } else {
      await getPreferences();
      await setConfirmDelete(confirm);
    }
  }

  static Future<void> setRollInititative(bool roll) async {
    if (prefs != null) {
      await prefs.setBool('pref_should_roll_init', roll);
    } else {
      await getPreferences();
      await setConfirmDelete(roll);
    }
  }

  static Future<void> setVal(String key, dynamic val) async {
    if (val is bool) {
      await prefs.setBool(key, val);
    } else if (val is double) {
      await prefs.setDouble(key, val);
    } else if (val is int) {
      await prefs.setInt(key, val);
    } else {
      throw UnimplementedError;
    }
  }
}
