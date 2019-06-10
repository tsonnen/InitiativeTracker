import 'package:initiative_tracker/character_model.dart';
import 'package:test/test.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main(){
  group('Character Model', () {
    SharedPreferences.setMockInitialValues({"pref_num_dice":"1", "pref_num_sides":"20"});
    Character testChar = new Character();
    Character testChar2 = new Character();
    CharacterListModel charList = new CharacterListModel();

    charList.addCharacter(testChar);
    charList.addCharacter(testChar2);

    test('ID should be different', (){
      expect(testChar.id, isNot(testChar2.id));
    });

    test('First Element should have a higher initiative', (){
      expect((charList.characters[0].initiative.compareTo(charList.characters[1].initiative)), 1);
    });
  });
}

