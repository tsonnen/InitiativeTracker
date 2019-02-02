class Character{
  String name;
  int initiative;
  List<String> notes;

  Character(String name, int initiative, String notes){
    this.name = name;
    this.initiative = initiative;
    this.notes = notes.split(",");
  }
}
