import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:pretty_json/pretty_json.dart';

class User {
  final int CUSTOM_TASK_LENGTH = 6; // indicate how many task we currently have
  String id; // User hashed email
  String labId; // -1 if the user does not have lab id
  // Toggle option to get user consent to use their data
  bool contributeData;
  Map<String, CustomTask> customTasks = {};

  // Default constructor to initialize everthing to Null equivalent
  User() {
    id = null;
    labId = null;
    customTasks = {
      '0': new CustomTask(),
      '1': new CustomTask(),
      '2': new CustomTask(),
      '3': new CustomTask(),
      '4': new CustomTask(),
      '5': new CustomTask()
    };
    contributeData = null;
  }

  // Created from the data retrieved from firestore as
  User.fromData(Map<String, dynamic> data) {
    id = data['id'];
    labId = data['labId'];
    contributeData = data['contributeData'];

    data['customTasks'].forEach(
        (key, value) => {customTasks[key] = new CustomTask.fromData(value)});
  }

  fromData(Map<String, dynamic> data) {
    print('in from data');
    id = data['id'];
    print('after id');
    labId = data['labId'];
    print('after lab id');
    contributeData = data['contributeData'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> customTasksJson = {};
    customTasks.forEach((key, value) {
      customTasksJson[key] = value.toJson();
    });

    return {
      'id': id,
      'labId': labId,
      'customTasks': customTasksJson,
      'contributeData': contributeData
    };
  }

  @override
  String toString() {
    return prettyJson(toJson());
  }
}
