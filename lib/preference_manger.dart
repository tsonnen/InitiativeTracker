import 'package:shared_preferences/shared_preferences.dart';

class PreferenceManger {
  static SharedPreferences prefs;

  static int getNumberDice() {
    if (prefs != null) {
      String numDice = prefs.getString("pref_num_dice");
      return numDice != null ? int.parse(numDice) : 1;
    }
    return 1;
  }

  static int getNumberSides() {
    if (prefs != null) {
      String numSides = prefs.getString("pref_num_sides");
      return numSides != null ? int.parse(numSides) : 20;
    }
    return 20;
  }

  static bool getConfirmDelete(){
    if (prefs != null) {
      return prefs.getBool("pref_confirm_delete") ?? true;
    }
    return true;
  }

  static bool getConfirmOverwrite(){
    if (prefs != null) {
      return prefs.getBool("pref_confirm_overwrite") ?? true;
    }
    return true;
  }

  static bool getConfirmLoad(){
    if (prefs != null) {
      return prefs.getBool("pref_confirm_load") ?? true;
    }
    return true;
  }

  static String getSystemUUID(){
    if(prefs != null){
      return prefs.getString("pref_systemuuid") ?? null;
    }
    return null;
  }

  static Future<void> getPreferences() async {
    if(prefs == null){
      prefs = await SharedPreferences.getInstance();
    }
  }

  static Future<void> setSystemUUID(String systemUUID) async {
    if(prefs != null){
      await prefs.setString("pref_systemuuid", systemUUID);
    }else{
      await getPreferences();
      await setSystemUUID(systemUUID);
    }
  }
}
