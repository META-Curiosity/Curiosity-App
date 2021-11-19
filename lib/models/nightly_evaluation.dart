import 'package:pretty_json/pretty_json.dart';

class NightlyEvaluation {
  bool isSuccessful;
  bool isCustomTask;
  String id;
  String reflection;
  String imageProof; // stored as base64 encoding
  int hashedDate; // comparison purpose
  String taskTitle;

  NightlyEvaluation.fromData(Map<String, dynamic> data) {
    isSuccessful = data['isSuccessful'];
    isCustomTask = data['isCustomTask'];
    taskTitle = data['taskTitle'];
    id = data['id'];
    reflection = data['reflection'];
    imageProof = data['imageProof'];
    hashedDate = data['hashedDate'];
  }

  // Default constructor for a nightly evaluation
  NightlyEvaluation() {
    id = '';
    reflection = '';
    imageProof = '';
    taskTitle = '';
    hashedDate = null;
    isSuccessful = null;
    isCustomTask = null;
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccessful': isSuccessful,
      'id': id,
      'reflection': reflection,
      'imageProof': imageProof,
      'hashedDate': hashedDate,
      'taskTitle': taskTitle,
      'isCustomTask': isCustomTask
    };
  }

  @override
  String toString() {
    return prettyJson(toJson());
  }
}
