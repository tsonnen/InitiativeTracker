import 'dart:convert';

import 'package:initiative_tracker/models/character_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moor/moor.dart';

part 'character_list.g.dart';

@JsonSerializable(explicitToJson: true)
class CharacterList {
  @CharacterConverter()
  List<CharacterModel> _l = [];
  List<CharacterModel> get list => _l;
  CharacterModel get first => _l.first;

  CharacterList({List<CharacterModel> list = const []}) : _l = list;
  void removeWhere(bool Function(CharacterModel) test) {
    return _l.removeWhere(test);
  }

  void add(CharacterModel characterModel) {
    _l.add(characterModel);
  }

  void sort([int Function(CharacterModel, CharacterModel) compare]) {
    return _l.sort(compare);
  }

  int indexWhere(bool Function(CharacterModel) test, {int start = 0}) {
    return _l.indexWhere(test);
  }

  CharacterModel operator [](int index) {
    return _l[index];
  }

  void operator []=(int index, CharacterModel value) {
    _l[index] = value;
  }

  factory CharacterList.fromJson(Map<String, dynamic> json) =>
      _$CharacterListFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterListToJson(this);

  CharacterList clone() {
    var tmp = CharacterList();
    _l?.forEach((i) => tmp.add(i));
    return tmp;
  }
}

class CharacterConverter implements JsonConverter<CharacterModel, String> {
  const CharacterConverter();

  @override
  CharacterModel fromJson(String json) {
    if (json is Map<String, dynamic>) {
      return CharacterModel.fromMap(jsonDecode(json));
    }

    return null;
  }

  @override
  String toJson(CharacterModel object) {
    return jsonEncode(object.toSQLMap());
  }
}

// stores preferences as strings
class CharacterListConverter extends TypeConverter<CharacterList, String> {
  const CharacterListConverter();
  @override
  CharacterList mapToDart(String fromDb) {
    if (fromDb == null) {
      return null;
    }
    return CharacterList.fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String mapToSql(CharacterList value) {
    if (value == null) {
      return null;
    }

    return json.encode(value.toJson());
  }
}
