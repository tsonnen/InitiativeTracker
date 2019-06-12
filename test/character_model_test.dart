import 'package:test/test.dart';
import 'package:initiative_tracker/character_model.dart';


void main(){
  group('Character Model', () {
    test('Should be able to find item in list', (){
        Character testChar = new Character();
        Character testChar2 = new Character();
        CharacterListModel charList = new CharacterListModel();

        charList.addCharacter(testChar);
        charList.addCharacter(testChar2);
      expect(charList.containsCharacter(testChar), true);
    });

    test('ID should be different', (){
      Character testChar = new Character();
      Character testChar2 = new Character();
      CharacterListModel charList = new CharacterListModel();

      charList.addCharacter(testChar);
      charList.addCharacter(testChar2);
      expect(testChar.id, isNot(testChar2.id));
    });

    test('First Element should have a higher initiative', (){
      Character testChar = new Character();
      Character testChar2 = new Character();
      CharacterListModel charList = new CharacterListModel();

      charList.addCharacter(testChar);
      charList.addCharacter(testChar2);
      expect((charList.characters[0].initiative >= charList.characters[1].initiative), true);
    });

    test('Charcter should have been removed', (){
      Character testChar = new Character();
      Character testChar2 = new Character();
      CharacterListModel charList = new CharacterListModel();

      charList.addCharacter(testChar);
      charList.addCharacter(testChar2);

      charList.removeCharacter(testChar);

      expect(charList.containsCharacter(testChar), false);
    });
  });
}

