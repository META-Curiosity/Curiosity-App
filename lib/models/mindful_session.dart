import 'package:pretty_json/pretty_json.dart';

class MindfulSession {
  String id;
  bool hasCompleted;
  int hashedDate; // comparison purpose

  MindfulSession.fromData(Map<String, dynamic> data) {
    id = data['id'];
    hasCompleted = data['hasCompleted'];
    hashedDate = data['hashedDate'];
  }

  // Default constructor for a nightly evaluation
  MindfulSession() {
    id = '';
    hashedDate = null;
    hasCompleted = null;
  }

  Map<String, dynamic> toJson() {
    return {
      'hasCompleted': hasCompleted,
      'hashedDate': hashedDate,
      'id': id
    };
  }

  @override
  String toString() {
    return prettyJson(toJson());
  }
}
