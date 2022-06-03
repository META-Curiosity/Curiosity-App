import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:pretty_json/pretty_json.dart';

class User {
  final int CUSTOM_TASK_LENGTH = 6; // indicate how many task we currently have

  // Toggle option to get user consent to use their data
  Map<String, CustomTask> customTasks = {};
  int currentStreak;
  int totalSuccessfulDays;
  int totalSuccessfulMindfulnessSession;
  int bestTaskCompletedStreak;
  int prevTypeOfTaskDone; // 0 = custom task, 1 = META task
  int labId; // -1 if the user does not have lab id

  String id; // User hashed email
  String prevSucessDateTime;
  String registerDateTime;

  bool contributeData;
  bool mindfulEligibility; // whether users can view the mindfulness screen
  bool onboarded; // Indicate whether user finished with onboarding process
  bool hasViewedMetaTaskIntro; // if user have view intro when first viewing meta task

  List<dynamic> mindfulReminders;
  var completeActivityReminders;

  // Default constructor to initialize everthing to null equivalent
  User() {
    customTasks = {
      '0': new CustomTask(),
      '1': new CustomTask(),
      '2': new CustomTask(),
      '3': new CustomTask(),
      '4': new CustomTask(),
      '5': new CustomTask()
    };
    id = null;
    labId = null;
    contributeData = null;
    prevSucessDateTime = null;
    registerDateTime = null;
    mindfulEligibility = null;
    mindfulReminders = null;
    completeActivityReminders = null;
    currentStreak = 0;
    totalSuccessfulDays = 0;
    prevTypeOfTaskDone = 1;
    onboarded = false;
    hasViewedMetaTaskIntro = false;
    totalSuccessfulMindfulnessSession = 0;
    bestTaskCompletedStreak = 0;
  }

  // Created from the data retrieved from firestore
  User.fromData(Map<String, dynamic> data) {
    fromData(data);
    data['customTasks'].forEach((key, value) {
      customTasks[key] = new CustomTask.fromData(value);
    });
  }

  fromData(Map<String, dynamic> data) {
    id = data['id'];
    labId = data['labId'];
    contributeData = data['contributeData'] ?? contributeData;
    prevSucessDateTime = data['prevSucessDateTime'] ?? prevSucessDateTime;
    currentStreak = data['currentStreak'] ?? currentStreak;
    registerDateTime = data['registerDateTime'] ?? registerDateTime;
    totalSuccessfulDays = data['totalSuccessfulDays'] ?? totalSuccessfulDays;
    mindfulEligibility = data['mindfulEligibility'] ?? mindfulEligibility;
    mindfulReminders = data['mindfulReminders'] ?? mindfulReminders;
    completeActivityReminders = data['completeActivityReminders'] ?? completeActivityReminders;
    onboarded = data['onboarded'] ?? onboarded;
    prevTypeOfTaskDone = data['prevTypeOfTaskDone'] ?? prevTypeOfTaskDone;
    hasViewedMetaTaskIntro = data['hasViewedMetaTaskIntro'] ?? hasViewedMetaTaskIntro;
    totalSuccessfulMindfulnessSession = data['totalSuccessfulMindfulnessSession'] ?? totalSuccessfulMindfulnessSession;
    bestTaskCompletedStreak = data['bestTaskCompletedStreak'] ?? bestTaskCompletedStreak;
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
      'contributeData': contributeData,
      'currentStreak': currentStreak,
      'prevSucessDateTime': prevSucessDateTime,
      'registerDateTime': registerDateTime,
      'totalSuccessfulDays': totalSuccessfulDays,
      'mindfulEligibility': mindfulEligibility,
      'completeActivityReminders': completeActivityReminders,
      'onboarded': onboarded,
      'mindfulReminders': mindfulReminders,
      'prevTypeOfTaskDone': prevTypeOfTaskDone,
      'hasViewedMetaTaskIntro': hasViewedMetaTaskIntro,
      'totalSuccessfulMindfulnessSession': totalSuccessfulMindfulnessSession,
      'bestTaskCompletedStreak': bestTaskCompletedStreak
    };
  }

  @override
  String toString() {
    return prettyJson(toJson());
  }
}
