import 'dart:collection';
import 'dart:convert';

import 'package:initiative_tracker/models/character_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moor/moor.dart';

part 'character_list.g.dart';

@JsonSerializable(explicitToJson: true)
class CharacterList extends ListBase<CharacterModel> {
  @CharacterConverter()
  final List<CharacterModel> l = [];

  CharacterList();

  @override
  @CharacterConverter()
  CharacterModel first;

  @override
  @CharacterConverter()
  CharacterModel last;

  @override
  CharacterModel operator [](int index) {
    return l[index];
  }

  @override
  void operator []=(int index, CharacterModel value) {
    l[index] = value;
  }

  factory CharacterList.fromJson(Map<String, dynamic> json) =>
      _$CharacterListFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterListToJson(this);

  @override
  int length;
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
