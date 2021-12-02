import 'package:pretty_json/pretty_json.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class MetaTask {
  String title;
  String difficulty;
  String description;
  String proofDescription;
  String id;

  MetaTask.fromData(Map<String, dynamic> data) {
    title = data['title'];
    description = data['description'];
    difficulty = data['difficulty'];
    proofDescription = data['proofDescription'];
    if (data['id'] == null) {
      id = sha256.convert(utf8.encode(title + difficulty)).toString();
    } else {
      id = data['id'];
    }
  }

  MetaTask.deepCopy(MetaTask source) {
    title = source.title;
    description = source.description;
    difficulty = source.difficulty;
    proofDescription = source.proofDescription;
    id = source.id;
  }

  // Default constructor for custom tasks
  MetaTask() {
    title = null;
    description = null;
    difficulty = null;
    proofDescription = null;
    id = null;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'description': description,
      'proofDescription': proofDescription,
      'difficulty': difficulty
    };
  }

  @override
  String toString() {
    return prettyJson(toJson());
  }
}
