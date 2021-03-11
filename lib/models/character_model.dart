import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:initiative_tracker/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'character_model.g.dart';

@JsonSerializable()
class CharacterModel {
  String characterUUID;
  String characterName;
  int initiative;
  String notes;
  int hp;
  int initMod;
  bool isExpanded = false;

  @ColorConverter()
  Color color;

  CharacterModel(
      {this.characterName = 'TEST',
      this.hp = 123,
      this.initiative,
      this.notes,
      this.initMod = 0,
      this.color,
      String characterUUID})
      : characterUUID = characterUUID ?? Uuid().generateV4();

  void setName(String name) {
    characterName = name;
  }

  void increaseHP() {
    setHP(++hp);
  }

  void reduceHP() {
    setHP(--hp);
  }

  void setHP(int hp) {
    this.hp = hp;
  }

  void setInitiative(int initiative) {
    this.initiative = initiative;
  }

  void edit(
      {String characterName,
      int hp,
      int initiative,
      String notes,
      Color color}) {
    this.characterName = characterName ?? this.characterName;
    this.hp = hp ?? this.hp;
    this.initiative = initiative ?? this.initiative;
    this.notes = notes ?? this.notes;
    this.color = color ?? this.color;
  }

  factory CharacterModel.fromJson(Map<String, dynamic> json) =>
      _$CharacterModelFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterModelToJson(this);

  @override
  bool operator ==(Object rhs) {
    return rhs is CharacterModel &&
        characterName == rhs.characterName &&
        characterUUID == rhs.characterUUID &&
        color == rhs.color &&
        hp == rhs.hp &&
        initMod == rhs.initMod &&
        initiative == rhs.initiative &&
        notes == rhs.notes;
  }

  CharacterModel copyWith(
          {String characterName,
          int hp,
          int initiative,
          String notes,
          Color color,
          String characterUUID,
          int initMod}) =>
      CharacterModel(
          characterName: characterName ?? this.characterName,
          characterUUID: characterUUID ?? this.characterUUID,
          hp: hp ?? this.hp,
          initiative: initiative ?? this.initiative,
          notes: notes ?? this.notes,
          color: color ?? this.color,
          initMod: initMod ?? this.initMod);
}

class ColorConverter implements JsonConverter<Color, String> {
  const ColorConverter();

  @override
  Color fromJson(String json) {
    if (json is Map<String, dynamic>) {
      return Color(jsonDecode(json));
    }

    return null;
  }

  @override
  String toJson(Color object) {
    return jsonEncode(object.value);
  }
}
