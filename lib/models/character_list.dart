import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:initiative_tracker/models/character_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:moor/moor.dart';

part 'character_list.g.dart';

@JsonSerializable(explicitToJson: true)
class CharacterList {
  @CharacterConverter()
  List<CharacterModel> l = [];
  @CharacterConverter()
  List<CharacterModel> get list => l;
  @CharacterConverter()
  CharacterModel get first => l.first;

  CharacterList({List<CharacterModel> list}) : l = list ?? [];
  void removeWhere(bool Function(CharacterModel) test) {
    return l.removeWhere(test);
  }

  void add(CharacterModel characterModel) {
    l.add(characterModel);
  }

  void sort([int Function(CharacterModel, CharacterModel) compare]) {
    return l.sort(compare);
  }

  int indexWhere(bool Function(CharacterModel) test, {int start = 0}) {
    return l.indexWhere(test);
  }

  CharacterModel operator [](int index) {
    return l[index];
  }

  void operator []=(int index, CharacterModel value) {
    l[index] = value;
  }

  factory CharacterList.fromJson(Map<String, dynamic> json) =>
      _$CharacterListFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterListToJson(this);

  CharacterList clone() {
    var tmp = CharacterList();
    l?.forEach((i) => tmp.add(i));
    return tmp;
  }

  @override
  bool operator ==(dynamic rhs) {
    return rhs is CharacterList && listEquals(l, rhs.l);
  }
}

class CharacterConverter implements JsonConverter<CharacterModel, String> {
  const CharacterConverter();

  @override
  CharacterModel fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return CharacterModel.fromJson(json);
    } else if (json is String) {
      return CharacterModel.fromJson(jsonDecode(json));
    }

    return null;
  }

  @override
  String toJson(CharacterModel object) {
    return jsonEncode(object.toJson());
  }
}

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
