import 'package:curiosity_flutter/models/custom_task.dart';

class User {
  final int CUSTOM_TASK_LENGTH = 6; // indicate how many task we currently have
  String id; // User hashed email
  String labId; // -1 if the user does not have lab id
  // Toggle option to get user consent to use their data
  bool contributeData;
  Map<String, CustomTask> customTasks = {};

  // Default constructor to initialize everthing to Null equivalent
  User() {
    id = "";
    labId = "";
    customTasks = {
      '0': new CustomTask(),
      '1': new CustomTask(),
      '2': new CustomTask(),
      '3': new CustomTask(),
      '4': new CustomTask(),
      '5': new CustomTask()
    };
    contributeData = false;
  }

  // Created from the data retrieved from firestore as
  User.fromData(String userId, Map<String, dynamic> data) {
    id = userId;
    labId = data['labId'];
    contributeData = data["contributeData"];

    // Initiate a custom tasks array to store custom task object of the user
    data['customTasks'].forEach(
        (key, value) => {customTasks[key] = new CustomTask.fromData(value)});
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> customTasksJson = {};
    customTasks.forEach((key, value) {
      customTasksJson[key] = value.toJson();
    });

    return {
      "id": id,
      "labId": labId,
      "customTasks": customTasksJson,
      "contributeData": contributeData
    };
  }

  @override
  String toString() {
    return "id: ${id}, labId: ${labId}, contributeData ${contributeData}, customTasks: ${customTasks}";
  }
}
