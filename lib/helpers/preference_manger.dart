import 'package:pref/pref.dart';

class PreferenceManger {
  static bool getFirstRun(BasePrefService service) {
    return service.get<bool>('first_run') ?? true;
  }

  static void setFirstRun(bool value, BasePrefService service) async {
    service.set<bool>('first_run', value);
  }

  static int getNumberDice(BasePrefService service) {
    return int.tryParse(service.get<String>('num_dice') ?? '') ?? 1;
  }

  static int getNumberSides(BasePrefService service) {
    return int.tryParse(service.get<String>('num_sides') ?? '') ?? 20;
  }

  static bool getConfirmDelete(BasePrefService service) {
    return service.get<bool>('confirm_delete') ?? true;
  }

  static bool getConfirmOverwrite(BasePrefService service) {
    return service.get<bool>('confirm_overwrite') ?? true;
  }

  static bool getConfirmLoad(BasePrefService service) {
    return service.get<bool>('confirm_load') ?? true;
  }

  static bool getShowHP(BasePrefService service) {
    return service.get<bool>('show_hp') ?? true;
  }

  static bool getShowNotes(BasePrefService service) {
    return service.get<bool>('show_notes') ?? true;
  }

  static bool getConfirmClearParty(BasePrefService service) {
    return service.get<bool>('confirm_clear') ?? true;
  }

  static bool getShowInitiative(BasePrefService service) {
    return service.get<bool>('show_initiative') ?? true;
  }

  static bool getRollInititative(BasePrefService service) {
    return service.get<bool>('should_roll_init') ?? true;
  }

  static Future<void> setConfirmLoad(
      bool confirm, BasePrefService service) async {
    service.set<bool>('confirm_load', confirm);
  }

  static Future<void> setConfirmDelete(
      bool confirm, BasePrefService service) async {
    service.set<bool>('confirm_delete', confirm);
  }

  static Future<void> setRollInititative(
      bool roll, BasePrefService service) async {
    service.set<bool>('should_roll_init', roll);
  }

  static Future<void> setVal(
      String key, dynamic val, BasePrefService service) async {
    service.set(key, val);
  }
}
