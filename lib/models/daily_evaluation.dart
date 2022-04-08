import 'package:pretty_json/pretty_json.dart';

class DailyEvaluation {
  bool isSuccessful;
  bool isCustomTask;
  String id;
  String reflection;
  String activityEnjoyment;
  String taskTitle;
  String imageProof; // stored as base64 encoding
  int hashedDate; // comparison purpose

  DailyEvaluation.fromData(Map<String, dynamic> data) {
    isSuccessful = data['isSuccessful'];
    isCustomTask = data['isCustomTask'];
    taskTitle = data['taskTitle'];
    id = data['id'];
    reflection = data['reflection'];
    imageProof = data['imageProof'];
    hashedDate = data['hashedDate'];
    activityEnjoyment = data['activityEnjoyment'];
  }

  // Default constructor for a daily evaluation
  DailyEvaluation() {
    id = '';
    reflection = '';
    imageProof = null;
    taskTitle = '';
    activityEnjoyment = '';
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
      'isCustomTask': isCustomTask,
      'activityEnjoyment': activityEnjoyment
    };
  }

  @override
  String toString() {
    return prettyJson(toJson());
  }
}
