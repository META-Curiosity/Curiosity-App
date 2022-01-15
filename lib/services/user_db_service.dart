import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:curiosity_flutter/models/nightly_evaluation.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:curiosity_flutter/services/admin_db_service.dart';
import 'package:curiosity_flutter/services/log_service.dart';
import '../helper/dateHelper.dart';

/* 
1) UserDbService - the service expects an authenticated user id to perform neccessary operations 
2) At each call to the service, the return type is of type map
  a) If the key 'error' exist inside the return value -> there is an error from the method
  b) If the key 'error' does not exist -> the call is successful
*/

class UserDbService {
  final String USER_DB_NAME = 'users-dev';
  final String NIGHT_EVAL_DB_NAME = 'nightlyEval';
  final LogService log = new LogService();
  String uid;
  CollectionReference usersCollection;
  CollectionReference nightlyEvalCollection;

  UserDbService(String uid) {
    this.uid = uid;
    usersCollection = FirebaseFirestore.instance.collection(USER_DB_NAME);
    nightlyEvalCollection = usersCollection.doc(uid).collection(NIGHT_EVAL_DB_NAME);
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
    log.infoObj({'method': 'registerUser'});
    try {
      User user = new User();

      user.fromData({
        'id': uid,
        'registerDateTime': DateTime.now().toUtc().toString()
      });
      // Put the new user id into the db
      await usersCollection.doc(uid).set(user.toJson());
      log.successObj({'method': 'registerUser - success', 'user': user});
      return {'user': user};
    } catch (error) {
      log.errorObj({'method': 'registerUser - error', 'error': error.toString()}, 2);
      return {'error': error, 'success': false };
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
      return { 'success': true };
    } catch (error) {
      log.errorObj({'method': 'updateUserLabId - error', 'error': error.toString()}, 2);
      return {'error': error, 'success': false };
    }
  }

  // Update user consent to share data
  Future<Map<String, dynamic>> updateUserConsent(bool agreed) async {
    try {
      log.infoObj({'method': 'updateUserConsent', 'agreed': agreed});
      await usersCollection.doc(uid).update({'contributeData': agreed});
      log.successObj({'method': 'updateUserConsent - success'});
      return { 'success': true };
    } catch (error) {
      log.errorObj({'method': 'updateUserConsent - error', 'error': error.toString()}, 2);
      return {'error': error, 'success': false };
    }
  }

  // Updating reminders for when the user would like to get reminded to finish their mindfulness
  Future<Map<String, dynamic>> updateMindfulReminders(List<int> reminders) async {
    try {
      log.infoObj({'method': 'updateMindfulReminders', 'reminders': reminders});
      await usersCollection.doc(uid).update({'mindfulReminders': reminders});
      log.successObj({'method': 'updateMindfulReminders - success'});
      return { 'success': true };
    } catch (error) {
      log.errorObj({'method': 'updateMindfulReminders - error', 'error': error.toString()}, 2);
      return {'error': error, 'success': false };
    }
  }

  // Updating reminders for when the user would like to get reminded to complete their activity
  Future<Map<String, dynamic>> updateCompleteActivityReminders(List<int> reminders) async {
    try {
      log.infoObj({'method': 'updateCompleteActivityReminder', 'reminders': reminders});
      await usersCollection.doc(uid).update({'completeActivityReminders': reminders});
      log.successObj({'method': 'updateCompleteActivityReminder - success'});
      return { 'success': true };
    } catch (error) {
      log.errorObj({'method': 'updateCompleteActivityReminder - error', 'error': error.toString()}, 2);
      return {'error': error, 'success': false };
    }
  }

  // Update user task via the position passed in and new values -
  // Upon successful update - a new custom task array will be returned
  // NOTE: 2 tasks cannot have the same title
  Future<Map<String, dynamic>> updateTask(String taskId, CustomTask newTask, Map<String, CustomTask> oldTask) async {
    try {
      log.infoObj({'method': 'updateTask', 'taskId': taskId, 'newTask': newTask});
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
        log.errorObj({'method': 'updateTask - error', 'message': 'duplicate title key'});
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
      log.errorObj({
        'method': 'updateTask - error', 
        'error': error.toString()
      }, 2);
      return {'error': error};
    }
  }

  // Used at the beginning of the morning to create a nightly evaluation
  // for a specific task that the user have choosen for that day
  // Expecting the field:
  //  1. taskTitle (title of the choosen task)
  //  2. id - the current date (MM-DD-YY)
  //  3. isCustomTask (a task from experiment or from user)
  Future<Map<String, dynamic>> addNightlyEvalMorningEvent(Map<String, dynamic> data) async {
    try {
      log.infoObj({'method': 'addNightlyEvalMorningEvent', 'data': data});
      NightlyEvaluation userInputEval = new NightlyEvaluation.fromData(data);
      userInputEval.hashedDate = calculateDateHash(data['id']);
      await nightlyEvalCollection.doc(data['id']).set(userInputEval.toJson());

      log.successObj({
        'method': 'addNightlyEvalMorningEvent - success',
        'nightlyEvalRecord': userInputEval
      });
      return {'nightlyEvalRecord': userInputEval};
    } catch (error) {
      log.errorObj({
        'method': 'addNightlyEvalMorningEvent - error',
        'error': error.toString()
      }, 2);
      return {'error': error};
    }
  }

  // Creating a nightly evaluation for an user and store in user db
  // date format: MM-DD-YY. Expecting photo to be a base64 encoding
  // of user proof image
  Future<Map<String, dynamic>> updateNightlyEval(
      Map<String, dynamic> data) async {
    log.infoObj({'method': 'updateNightlyEval', 'data': data});
    try {
      String id = data.remove('id');
      await nightlyEvalCollection.doc(id).update(data);

      // Retrieving user information to update their streak and days successful
      Map<String, dynamic> userData = await getUserData();
      
      if (userData['error'] != null) {
        log.errorObj({'method': 'updateNightlyEval - error', 'error': userData['error']},2);
        return { 'error': userData['error'] };
      }
      
      User user = userData['user'];      
      if (data['isSuccessful']) {
        if (user.prevSucessDateTime != null) {
          DateTime crntLocalDateTime = DateTime.now().toLocal();
          DateTime prevSuccessLocalTime = DateTime.parse(user.prevSucessDateTime).toLocal();
          int daysBetween = DateHelper.daysBetween(prevSuccessLocalTime, crntLocalDateTime);
          log.infoObj({
            'method': 'updateNightlyEval',
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
        'method': 'updateNightlyEval', 
        'message': 'update user streaks successful'
      });

      // Returning the nightly evaluation document
      DocumentSnapshot nightlyEvalSnapshot = await nightlyEvalCollection.doc(id).get();
      if (!nightlyEvalSnapshot.exists) {
        String message = 'Nightly evaluation with date = ${id} does not exist';
        log.errorObj({
          'method': 'updateNightlyEval', 
          'error': message
        });
        return {'error': message};
      }

      NightlyEvaluation nightlyEvalRecord =
          new NightlyEvaluation.fromData(nightlyEvalSnapshot.data());
      log.successObj({
        'method': 'updateNightlyEval - success',
        'nightlyEvalRecord': nightlyEvalRecord
      });
      return {'nightlyEvalRecord': nightlyEvalRecord};
    } catch (error) {
      log.errorObj(
          {'method': 'updateNightlyEval - error', 'error': error.toString()},
          2);
      return {'error': error};
    }
  }

  // Querying a specific nightly evaluation of the user
  // expected date format: MM-DD-YY
  Future<Map<String, dynamic>> getUserNightlyEvalByDate(String date) async {
    log.infoObj({'method': 'getUserNightlyEvalByDate', 'date': date});
    DocumentSnapshot nightlyEvalSnapshot;
    try {
      nightlyEvalSnapshot = await nightlyEvalCollection.doc(date).get();

      // User does not exist
      if (!nightlyEvalSnapshot.exists) {
        String message =
            'Nightly evaluation with date = ${date} does not exist';
        log.errorObj({'method': 'getUserNightlyEvalByDate', 'error': message});
        return {'error': message};
      }

      NightlyEvaluation nightlyEvalRecord =
          new NightlyEvaluation.fromData(nightlyEvalSnapshot.data());
      log.successObj({
        'method': 'getUserNightlyEvalByDate - success',
        'nightlyEvalRecord': nightlyEvalRecord
      });
      return {'nightlyEvalRecord': nightlyEvalRecord};
    } catch (error) {
      log.errorObj({
        'method': 'getUserNightlyEvalByDate - error',
        'error': error.toString()
      }, 2);
      return {'error': error};
    }
  }

  // Retrieving a list of all nightly evaluation dates of an user within a month.
  // Need to receive the ending date of a month in the format: MM-DD-YY
  Future<Map<String, dynamic>> getUserNightlyEvalDatesByMonth(String endDate) async {
    log.infoObj({
      'method': 'getUserNightlyEvalDatesByMonth',
      'id': uid,
      'endDate': endDate
    });

    List<String> endDateSplit = endDate.split('-');
    int hashedStartDate = calculateDateHash(endDateSplit[0] + '-01-' + endDateSplit[2]);

    QuerySnapshot querySnapshot;
    List<NightlyEvaluation> nightEvalRecords = [];
    try {
      querySnapshot = await nightlyEvalCollection
          .where('hashedDate', isGreaterThanOrEqualTo: hashedStartDate)
          .where('hashedDate', isLessThanOrEqualTo: calculateDateHash(endDate))
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          nightEvalRecords.add(new NightlyEvaluation.fromData(doc.data()));
        }
      }
      log.successObj({
        'method': 'getUserNightlyEvalDatesByMonth - successs',
        'nightEvalRecords': nightEvalRecords
      });
      return {'nightEvalRecords': nightEvalRecords};
    } catch (error) {
      log.errorObj({
        'method': 'getUserNightlyEvalDatesByMonth - error',
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
        },2);
        return {'error': userData['error'] };
      }

      User user = userData['user'];
      // Calculating total number of days registered IN LOCAL DEVICE TIME
      DateTime currentLocalDateTime = DateTime.now().toLocal();
      DateTime registeredLocalDateTime = DateTime.parse(user.registerDateTime).toLocal();
      int totalDaysRegistered = DateHelper.daysBetween(currentLocalDateTime, registeredLocalDateTime);

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

  // Hashing the date for each nightly evaluation to help with retrieving
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
