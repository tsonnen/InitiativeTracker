class OLDCharacterModel {
  String? characterUUID;
  String? characterName;
  int? initiative;
  String? notes;
  int? hp;
  bool isExpanded = false;
  Map<String, int>? attributes = <String, int>{};
  String? systemUUID;

  OLDCharacterModel(
      {this.characterName,
      this.hp,
      this.initiative,
      this.characterUUID,
      this.notes,
      this.systemUUID,
      this.attributes});

  factory OLDCharacterModel.fromJson(Map<String, dynamic> json,
      {bool legacyRead = false}) {
    return OLDCharacterModel(
      characterName: json[legacyRead ? 'name' : 'characterName'],
      initiative: json['initiative'],
      hp: json['hp'],
      characterUUID: json[legacyRead ? 'id' : 'characterUUID'],
      notes: json['notes'],
      systemUUID: json['systemUUID'],
    );
  }

  @override
  bool operator ==(rhs) {
    return rhs is OLDCharacterModel &&
        characterUUID == rhs.characterUUID &&
        characterName == rhs.characterName &&
        initiative == rhs.initiative &&
        notes == rhs.notes &&
        hp == rhs.hp;
  }

  @override
  int get hashCode =>
      characterName.hashCode ^
      initiative.hashCode ^
      characterUUID.hashCode ^
      hp.hashCode ^
      initiative.hashCode ^
      notes.hashCode;
}
