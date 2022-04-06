import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:curiosity_flutter/models/mindful_session.dart';
import 'package:curiosity_flutter/models/daily_evaluation.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:curiosity_flutter/services/admin_db_service.dart';
import 'package:curiosity_flutter/services/log_service.dart';
import 'package:curiosity_flutter/services/meta_task_db_service.dart';
import '../helper/dateHelper.dart';
import 'dart:math';

/* 
1) UserDbService - the service expects an authenticated user id to perform necessary operations
2) At each call to the service, the return type is of type map
  a) If the key 'error' exist inside the return value -> there is an error from the method
  b) If the key 'error' does not exist -> the call is successful
*/

class UserDbService {
  final String USER_DB_NAME = 'users-dev';
  final String DAILY_EVAL_DB_NAME = 'daily-eval-dev';
  final String MINDFUL_SESSION_DB_NAME = 'mindful-session-completion';
  final LogService log = new LogService();
  String uid;
  CollectionReference usersCollection;
  CollectionReference dailyEvalCollection;
  CollectionReference mindfulSesCollection;

  UserDbService(String uid) {
    this.uid = uid;
    usersCollection = FirebaseFirestore.instance.collection(USER_DB_NAME);
    dailyEvalCollection =
        usersCollection.doc(uid).collection(DAILY_EVAL_DB_NAME);
    mindfulSesCollection =
        usersCollection.doc(uid).collection(MINDFUL_SESSION_DB_NAME);
  }

  Future<Map<String, dynamic>> getUserData() async {
    try {
      log.infoObj({'method': 'getUserData', 'id': uid});
      Map<String, dynamic> response = await AdminDbService().getUserById(uid);
      if (response['error'] != null) {
        return {'error': response['error']};
      }
      log.successObj({'method': 'getUserData - success'});
      return {'user': response['user']};
    } catch (error) {
      log.errorObj({'method': 'getUserData', 'error': error.toString()});
      return {'error': error.toString()};
    }
  }

  // Adding new user to the database, if successful the new user data can be
  // accessed via the 'user' key of the response. Expecting data to contain:
  // the field labId and contributeData.
  Future<Map<String, dynamic>> registerUserId() async {
    log.infoObj({'method': 'registerUserId'});
    try {
      User user = new User();

      user.fromData(
          {'id': uid, 'registerDateTime': DateTime.now().toUtc().toString()});
      // Put the new user id into the db
      await usersCollection.doc(uid).set(user.toJson());
      log.successObj({'method': 'registerUserId - success', 'user': user});
      return {'user': user};
    } catch (error) {
      log.errorObj(
          {'method': 'registerUserId - error', 'error': error.toString()}, 2);
      return {'error': error, 'success': false};
    }
  }

  // Update user lab id
  Future<Map<String, dynamic>> updateUserLabId(int labId) async {
    try {
      log.infoObj({'method': 'updateUserLabId', 'labId': labId});
      await usersCollection.doc(uid).update({'labId': labId});
      // Even number lab id will get access to the mindfulness screen
      if (labId >= 0 && labId % 2 == 0) {
        await usersCollection.doc(uid).update({'mindfulEligibility': true});
      } else {
        await usersCollection.doc(uid).update({'mindfulEligibility': false});
      }
      log.successObj({'method': 'updateUserLabId - success'});
      return {'success': true};
    } catch (error) {
      log.errorObj(
          {'method': 'updateUserLabId - error', 'error': error.toString()}, 2);
      return {'error': error, 'success': false};
    }
  }

  // Update user consent to share data
  Future<Map<String, dynamic>> updateUserConsent(bool agreed) async {
    try {
      log.infoObj({'method': 'updateUserConsent', 'agreed': agreed});
      await usersCollection.doc(uid).update({'contributeData': agreed});
      log.successObj({'method': 'updateUserConsent - success'});
      return {'success': true};
    } catch (error) {
      log.errorObj(
          {'method': 'updateUserConsent - error', 'error': error.toString()},
          2);
      return {'error': error, 'success': false};
    }
  }

  // Updating reminders for when the user would like to get reminded to finish their mindfulness
  Future<Map<String, dynamic>> updateMindfulReminders(
      List<int> reminders) async {
    try {
      log.infoObj({'method': 'updateMindfulReminders', 'reminders': reminders});
      await usersCollection.doc(uid).update({'mindfulReminders': reminders});
      log.successObj({'method': 'updateMindfulReminders - success'});
      return {'success': true};
    } catch (error) {
      log.errorObj({
        'method': 'updateMindfulReminders - error',
        'error': error.toString()
      }, 2);
      return {'error': error, 'success': false};
    }
  }

  // Updating reminders for when the user would like to get reminded to complete their activity
  Future<Map<String, dynamic>> updateCompleteActivityReminders(
      List<int> reminders) async {
    try {
      log.infoObj(
          {'method': 'updateCompleteActivityReminder', 'reminders': reminders});
      await usersCollection
          .doc(uid)
          .update({'completeActivityReminders': reminders});
      log.successObj({'method': 'updateCompleteActivityReminder - success'});
      return {'success': true};
    } catch (error) {
      log.errorObj({
        'method': 'updateCompleteActivityReminder - error',
        'error': error.toString()
      }, 2);
      return {'error': error, 'success': false};
    }
  }

  // Update user onboarding values
  Future<Map<String, dynamic>> updateUserOnboarding(bool hasUserOnboard) async {
    try {
      log.infoObj(
          {'method': 'updateUserOnboarding', 'hasUserOnboard': hasUserOnboard});
      await usersCollection.doc(uid).update({'onboarded': hasUserOnboard});
      log.successObj({'method': 'updateUserOnboarding - success'});
      return {'success': true};
    } catch (error) {
      log.errorObj(
          {'method': 'updateUserOnboarding', 'error': error.toString()});
      return {'error': error, 'success': false};
    }
  }

  // Creating a daily evaluation for an user and store in user db
  // date format: MM-DD-YY. Expecting photo to be a base64 encoding
  // of user proof image
  Future<Map<String, dynamic>> updateDailyEval(
      Map<String, dynamic> data) async {
    log.infoObj({'method': 'updateDailyEval', 'data': data});
    try {
      String id = data.remove('id');
      await dailyEvalCollection.doc(id).update(data);

      // Retrieving user information to update their streak and days successful
      Map<String, dynamic> userData = await getUserData();

      if (userData['error'] != null) {
        log.errorObj(
            {'method': 'updateDailyEval - error', 'error': userData['error']},
            2);
        return {'error': userData['error']};
      }

      User user = userData['user'];
      if (data['isSuccessful']) {
        if (user.prevSucessDateTime != null) {
          DateTime crntLocalDateTime = DateTime.now().toLocal();
          DateTime prevSuccessLocalTime =
              DateTime.parse(user.prevSucessDateTime).toLocal();
          int daysBetween =
              DateHelper.daysBetween(prevSuccessLocalTime, crntLocalDateTime);
          log.infoObj({
            'method': 'updateDailyEval',
            'crntLocalDateTime': crntLocalDateTime.toString(),
            'prevSuccessLocalTime': prevSuccessLocalTime.toString(),
            'daysBetween': daysBetween
          });
          // More than a day since task is marked as successful -> user lose their streak
          if (daysBetween != 1) {
            user.currentStreak = 0;
          }
        }
        user.currentStreak += 1;
        user.totalSuccessfulDays += 1;
        user.prevSucessDateTime = DateTime.now().toUtc().toString();
      } else {
        // Task was not completed successfully -> lose streak
        user.currentStreak = 0;
      }

      log.infoObj({
        'currentStreak': user.currentStreak,
        'totalSuccessfulDays': user.totalSuccessfulDays,
        'prevSuccessDateTime': user.prevSucessDateTime
      });

      await usersCollection.doc(uid).update({
        'currentStreak': user.currentStreak,
        'totalSuccessfulDays': user.totalSuccessfulDays,
        'prevSucessDateTime': user.prevSucessDateTime
      });

      log.infoObj({
        'method': 'updateDailyEval',
        'message': 'update user streaks successful'
      });

      // Returning the daily evaluation document
      DocumentSnapshot dailyEvalSnapshot =
          await dailyEvalCollection.doc(id).get();
      if (!dailyEvalSnapshot.exists) {
        String message = 'Daily evaluation with date = ${id} does not exist';
        log.errorObj({'method': 'updateDailyEval', 'error': message});
        return {'error': message};
      }

      DailyEvaluation dailyEvalRecord =
          new DailyEvaluation.fromData(dailyEvalSnapshot.data());
      log.successObj({
        'method': 'updateDailyEval - success',
        'dailyEvalRecord': dailyEvalRecord
      });
      return {'dailyEvalRecord': dailyEvalRecord};
    } catch (error) {
      log.errorObj(
          {'method': 'updateDailyEval - error', 'error': error.toString()}, 2);
      return {'error': error};
    }
  }

  // Update user onboarding values
  Future<Map<String, dynamic>> updateUserViewingMetaTaskIntro(
      bool hasUserViewedMetaTaskIntro) async {
    try {
      log.infoObj({
        'method': 'updateUserViewingMetaTaskIntro',
        'hasUserViewedMetaTaskIntro': hasUserViewedMetaTaskIntro
      });
      await usersCollection
          .doc(uid)
          .update({'hasViewedMetaTaskIntro': hasUserViewedMetaTaskIntro});
      log.successObj({'method': 'updateUserViewingMetaTaskIntro - success'});
      return {'success': true};
    } catch (error) {
      log.errorObj({
        'method': 'updateUserViewingMetaTaskIntro',
        'error': error.toString()
      });
      return {'error': error, 'success': false};
    }
  }

  // Update user task via the position passed in and new values -
  // Upon successful update - a new custom task array will be returned
  // NOTE: 2 tasks cannot have the same title
  Future<Map<String, dynamic>> updateTask(String taskId, CustomTask newTask,
      Map<String, CustomTask> oldTask) async {
    try {
      log.infoObj(
          {'method': 'updateTask', 'taskId': taskId, 'newTask': newTask});
      Map<String, Map<String, dynamic>> sharedObject = {
        'customTasks.${taskId}': newTask.toJson()
      };

      bool hasDuplicateTitle = false;
      // Search in the old task array to see if any of the created task
      // has the same title
      oldTask.keys.forEach((key) {
        if (key != taskId && oldTask[key].title == newTask.title) {
          hasDuplicateTitle = true;
          return;
        }
      });

      if (hasDuplicateTitle) {
        log.errorObj(
            {'method': 'updateTask - error', 'message': 'duplicate title key'});
        return {
          'error': 'Two tasks cannot have the same title, please try again'
        };
      }
      await usersCollection.doc(uid).update(sharedObject);

      // Override the old task id with the new task
      oldTask[taskId] = newTask;

      log.successObj({'method': 'updateTask - success', 'customTask': oldTask});
      return {'customTask': oldTask};
    } catch (error) {
      log.errorObj(
          {'method': 'updateTask - error', 'error': error.toString()}, 2);
      return {'error': error};
    }
  }

  // Gets the a random meta task id for a given difficulty for a user.
  // Returns metaTaskId which can be used to query for the specific task
  // Returns userIndex which is the index in the user array that can be used to later update remaining tasks for the user
  Future<Map<String, dynamic>> getRandomMetaTask(
    String difficulty,
  ) async {
    log.infoObj({'method': 'getRandomMetaTask', 'difficulty': difficulty});
    try {
      DocumentSnapshot user = await usersCollection.doc(uid).get();
      MetaTaskDbServices metaTasks = MetaTaskDbServices();
      try {
        final random = new Random();

        // If we don't have an array or if it is empty, repopulate the array
        if (!user.data().toString().contains(difficulty) || user[difficulty].length == 0) {
          var currentCount = await metaTasks.getCountForDifficulty(difficulty);
          var list = [for (var i = 1; i <= currentCount['count']; i++) i];
          usersCollection.doc(uid).update({difficulty: list});

          int index = random.nextInt(currentCount['count']);

          log.successObj({
            'method': 'getRandomMetaTask - success',
            'metaTaskId': index + 1,
            'userIndex': index,
          });

          return {"taskId": index + 1, "userIndex": index};
        } else {
          //array exists in db, so we can pull random task out
          int len = user[difficulty].length;
          int index = random.nextInt(len);
          int metaTaskId = user[difficulty][index];
          log.successObj({
            'method': 'getRandomMetaTask - success',
            'metaTaskId': metaTaskId,
            'userIndex': index,
          });
          return {"taskId": metaTaskId, "userIndex": index};
        }
      } on StateError catch (error) {
        log.errorObj(
            {'method': 'getRandomMetaTask - error', 'error': error.toString()},
            2);
        return {'error': error};
      }
      ;
    } catch (error) {
      log.errorObj(
          {'method': 'getRandomMetaTask - error', 'error': error.toString()},
          2);
      return {'error': error};
    }
  }

  //Removes a metaTask from a user's remaining list of meta tasks.
  Future<Map<String, dynamic>> removeMetaTask(
    String difficulty,
    int index,
  ) async {
    log.infoObj(
        {'method': 'removeMetaTask', 'difficulty': difficulty, 'index': index});
    try {
      DocumentSnapshot user = await usersCollection.doc(uid).get();
      //MetaTaskDbServices metaTasks = MetaTaskDbServices();
      try {
        var list = user[difficulty];
        list.removeAt(index);
        usersCollection.doc(uid).update({difficulty: list});
        log.successObj({
          'method': 'removeMetaTask - success',
        });
      } on StateError catch (error) {
        log.errorObj(
            {'method': 'removeMetaTask - error', 'error': error.toString()}, 2);
        return {'error': error};
      }
      ;
    } catch (error) {
      log.errorObj(
          {'method': 'removeMetaTask - error', 'error': error.toString()}, 2);
      return {'error': error};
    }
  }

  // Get user mindfulness reminder time slot preference
  Future<Map<String, dynamic>> getMindfulNotiPref() async {
    try {
      log.infoObj({'method': 'getMindfulNotiPref'});
      DocumentSnapshot user = await usersCollection.doc(uid).get();
      log.infoObj({
        'method': 'getMindfulNotiPref - success',
        'mindfulReminders': user['mindfulReminders']
      });
      return {'mindfulReminders': user['mindfulReminders']};
    } catch (error) {
      log.errorObj(
          {'method': 'getMindfulNotiPref - error', 'error': error.toString()},
          2);
      return {'error': error, 'success': false};
    }
  }

  // Used at the beginning of the morning to create a daily evaluation
  // for a specific task that the user have choosen for that day
  // Expecting the field:
  //  1. taskTitle (title of the choosen task)
  //  2. id - the current date (MM-DD-YY)
  //  3. isCustomTask (a task from experiment or from user)
  Future<Map<String, dynamic>> addDailyEvalMorningEvent(
      Map<String, dynamic> data) async {
    try {
      log.infoObj({'method': 'addDailyEvalMorningEvent', 'data': data});
      DailyEvaluation userInputEval = new DailyEvaluation.fromData(data);
      userInputEval.hashedDate = calculateDateHash(data['id']);
      await dailyEvalCollection.doc(data['id']).set(userInputEval.toJson());

      log.successObj({
        'method': 'addDailyEvalMorningEvent - success',
        'dailyEvalRecord': userInputEval
      });
      return {'dailyEvalRecord': userInputEval};
    } catch (error) {
      log.errorObj({
        'method': 'addDailyEvalMorningEvent - error',
        'error': error.toString()
      }, 2);
      return {'error': error};
    }
  }

  // Querying a specific daily evaluation of the user
  // expected date format: MM-DD-YY
  Future<Map<String, dynamic>> getUserDailyEvalByDate(String date) async {
    log.infoObj({'method': 'getUserDailyEvalByDate', 'date': date});
    DocumentSnapshot dailyEvalSnapshot;
    try {
      dailyEvalSnapshot = await dailyEvalCollection.doc(date).get();

      // User does not exist
      if (!dailyEvalSnapshot.exists) {
        String message = 'Daily evaluation with date = ${date} does not exist';
        log.errorObj({'method': 'getUserDailyEvalByDate', 'error': message});
        return {'error': message};
      }

      DailyEvaluation dailyEvalRecord =
          new DailyEvaluation.fromData(dailyEvalSnapshot.data());
      log.successObj({
        'method': 'getUserDailyEvalByDate - success',
        'dailyEvalRecord': dailyEvalRecord
      });
      return {'dailyEvalRecord': dailyEvalRecord};
    } catch (error) {
      log.errorObj({
        'method': 'getUserDailyEvalByDate - error',
        'error': error.toString()
      }, 2);
      return {'error': error};
    }
  }

  // Retrieving a list of all daily evaluation dates of an user within a month.
  // Need to receive the ending date of a month in the format: MM-DD-YY
  Future<Map<String, dynamic>> getUserDailyEvalDatesByMonth(
      String endDate) async {
    log.infoObj({
      'method': 'getUserDailyEvalDatesByMonth',
      'id': uid,
      'endDate': endDate
    });

    List<String> endDateSplit = endDate.split('-');
    int hashedStartDate =
        calculateDateHash(endDateSplit[0] + '-01-' + endDateSplit[2]);

    QuerySnapshot querySnapshot;
    List<DailyEvaluation> dailyEvalRecords = [];
    try {
      querySnapshot = await dailyEvalCollection
          .where('hashedDate', isGreaterThanOrEqualTo: hashedStartDate)
          .where('hashedDate', isLessThanOrEqualTo: calculateDateHash(endDate))
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          dailyEvalRecords.add(new DailyEvaluation.fromData(doc.data()));
        }
      }
      log.successObj({
        'method': 'getUserDailyEvalDatesByMonth - successs',
        'dailyEvalRecords': dailyEvalRecords
      });
      return {'dailyEvalRecords': dailyEvalRecords};
    } catch (error) {
      log.errorObj({
        'method': 'getUserDailyEvalDatesByMonth - error',
        'error': error.toString()
      }, 2);
      return {'error': error};
    }
  }

  // Getting the user current streak and the number of days that they
  // have successfully completed a task
  Future<Map<String, dynamic>> getUserStreakAndTotalDaysCompleted() async {
    log.infoObj({'method': 'getUserStreakAndTotalDaysCompleted'});
    try {
      Map<String, dynamic> userData = await getUserData();

      if (userData['error'] != null) {
        log.errorObj({
          'method': 'getUserStreakAndTotalDaysCompleted - error',
          'error': userData['error']
        }, 2);
        return {'error': userData['error']};
      }

      User user = userData['user'];
      // Calculating total number of days registered IN LOCAL DEVICE TIME
      DateTime currentLocalDateTime = DateTime.now().toLocal();
      DateTime registeredLocalDateTime =
          DateTime.parse(user.registerDateTime).toLocal();
      int totalDaysRegistered =
          DateHelper.daysBetween(currentLocalDateTime, registeredLocalDateTime);

      log.successObj({
        'method': 'getUserStreakAndTotalDaysCompleted - successful',
        'totalDaysRegistered': totalDaysRegistered,
        'totalSuccessfulDays': user.totalSuccessfulDays,
        'currentStreak': user.currentStreak
      });

      return {
        'totalDaysRegistered': totalDaysRegistered,
        'totalSuccessfulDays': user.totalSuccessfulDays,
        'currentStreak': user.currentStreak
      };
    } catch (error) {
      log.errorObj({
        'method': 'getUserStreakAndTotalDaysCompleted - error',
        'error': error.toString()
      }, 2);
      return {'error': error};
    }
  }

  // Keep track of user mindfulness session
  // Expecting the field:
  //  1. id - the current date (MM-DD-YY)
  //  2. hasCompleted - whether the mindfulness session was completed
  Future<Map<String, dynamic>> addMindfulnessSessionCompletion(
      Map<String, dynamic> data) async {
    try {
      log.infoObj({'method': 'addMindfulnessSessionCompletion', 'data': data});
      MindfulSession userMindfulInput = new MindfulSession.fromData(data);
      userMindfulInput.hashedDate = calculateDateHash(data['id']);
      await mindfulSesCollection.doc(data['id']).set(userMindfulInput.toJson());

      log.successObj({
        'method': 'addMindfulnessSessionCompletion - success',
        'userMindfulInput': userMindfulInput
      });
      return {'userMindfulInput': userMindfulInput};
    } catch (error) {
      log.errorObj({
        'method': 'addMindfulnessSessionCompletion - error',
        'error': error.toString()
      }, 2);
      return {'error': error};
    }
  }

  // Determining which type of task to get for today
  Future<Map<String, dynamic>> getTypeOfTaskToday() async {
    try {
      log.infoObj({'method': 'getTypeOfTaskToday'});

      // Retrieving user information
      Map<String, dynamic> userData = await getUserData();
      // Check if the response return an error
      if (userData['error'] != null) {
        log.errorObj(
            {'method': 'updateDailyEval - error', 'error': userData['error']},
            2);
        return {'error': userData['error'], 'success': false};
      }

      int taskPrevDoneByUser = userData['user'].prevTypeOfTaskDone;
      // Update the task done by the user appropriately
      if (taskPrevDoneByUser == 0) {
        await usersCollection.doc(uid).update({'prevTypeOfTaskDone': 1});
      } else {
        await usersCollection.doc(uid).update({'prevTypeOfTaskDone': 0});
      }
      int userTypeOfTaskToday = taskPrevDoneByUser == 0 ? 1 : 0;
      log.successObj({
        'method': 'getTypeOfTaskToday - success',
        'userTypeOfTaskToday': userTypeOfTaskToday,
        'taskPrevDoneByUser': taskPrevDoneByUser
      });
      return {'success': true, 'userTypeOfTaskToday': userTypeOfTaskToday};
    } catch (error) {
      log.errorObj(
          {'method': 'getTypeOfTaskToday - error', 'error': error.toString()},
          2);
      return {'error': error, 'success': false};
    }
  }

  // Hashing the date for each daily evaluation to help with retrieving
  // dates within a certain range - format: MM-DD-YY
  int calculateDateHash(String date) {
    List<String> dateSplit = date.split('-');
    final int initialYear = 20;
    final int constantMultiplier = 31;

    int value = int.parse(dateSplit[0]) * constantMultiplier;
    value += int.parse(dateSplit[1]);
    value += (403 * (int.parse(dateSplit[2]) - initialYear));
    return value;
  }
}
