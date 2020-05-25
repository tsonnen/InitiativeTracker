import 'package:initiative_tracker/uuid.dart';

class System {
  String systemUUID;
  String systemName;
  Map<String, String> attributeRules;

  System(this.systemName , {this.attributeRules}){
    this.systemUUID = Uuid().generateV4();
  }

  factory System.fromMap(Map<String, dynamic> json) {
    return new System.json(
        systemUUID: json['systemUUID'],
        systemName: json['systemName'],
        attributeRules: json['attributeRules']);
  }

  System.json({this.systemUUID, this.systemName, this.attributeRules});

  Map<String, dynamic> toMap() => {
        'systemUUID': systemUUID,
        'systemName': systemName,
        'attributeRules': attributeRules,
      };
}
