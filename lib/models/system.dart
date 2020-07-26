import 'package:initiative_tracker/uuid.dart';

class System {
  String systemUUID;
  String systemName;
  Map<String, String> systemAttributes;

  System(this.systemName , {this.systemAttributes}){
    this.systemUUID = Uuid().generateV4();
  }

  factory System.fromMap(Map<String, dynamic> json) {
    return new System.json(
        systemUUID: json['systemUUID'],
        systemName: json['systemName'],
        systemAttributes: json['systemAttributes']);
  }

  System.json({this.systemUUID, this.systemName, this.systemAttributes});

  Map<String, dynamic> toMap() => {
        'systemUUID': systemUUID,
        'systemName': systemName,
        'systemAttributes': systemAttributes,
      };
}
