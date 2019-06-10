import 'package:shared_preferences/shared_preferences.dart';


class PreferenceManger{
  static SharedPreferences prefs;

  static int getNumberDice() {
    String numDice = prefs.getString("pref_num_dice");
  	return int.parse(numDice) ?? 1;
  }

  static int getNumberSides() {
    String numSides = prefs.getString("pref_num_sides");
    return int.parse(numSides) ?? 20;
  }

  static void getPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }
}