import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:curiosity_flutter/models/nightly_evaluation.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:pretty_json/pretty_json.dart';

/* 
1) UserDbService - the service expects an authenticated user id to perform neccessary operations 
2) At each call to the service, the return type is of type map
  a) If the key 'error' exist inside the return value -> there is an error from the method
  b) If the key 'error' does not exist -> the call is successful
*/

class UserDbService {
  final String USER_DB_NAME = 'tb-test';
  final String NIGHTLY_EVALUATION_DB_NAME = 'nightlyEval';
  String uid;
  CollectionReference usersCollection;
  CollectionReference nightlyEvalCollection;

  UserDbService(String uid) {
    this.uid = uid;
    usersCollection = FirebaseFirestore.instance.collection(USER_DB_NAME);
    nightlyEvalCollection =
        usersCollection.doc(uid).collection(NIGHTLY_EVALUATION_DB_NAME);
  }

  // Adding new user to the database, if successful the new user data can be
  // accessed via the 'user' key of the response. Expecting data to contain:
  // the field labId and contributeData.
  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> data) async {
    printPrettyJson({'method': 'registerUser', 'data': data});
    try {
      User user = new User();
      data['id'] = uid;
      user.fromData(data);

      // Put the new user id into the db
      await usersCollection.doc(uid).set(user.toJson());
      printPrettyJson({'method': 'registerUser - success', 'user': user});
      return {'user': user};
    } catch (error) {
      printPrettyJson({'method': 'registerUser - error', 'error': error});
      return {'error': error, 'user': new User()};
    }
  }

  // Update user task via the position passed in and new values -
  // Upon successful update - a new custom task array will be returned
  // NOTE: 2 tasks cannot have the same title
  Future<Map<String, dynamic>> updateTask(String taskId, CustomTask newTask,
      Map<String, CustomTask> oldTask) async {
    printPrettyJson(
        {'method': 'updateTask', 'taskId': taskId, 'newTask': newTask});
    try {
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
        printPrettyJson(
            {'method': 'updateTask - error', 'message': 'duplicate title key'});
        return {
          'error': 'Two tasks cannot have the same title, please try again'
        };
      }
      await usersCollection.doc(uid).update(sharedObject);

      // Override the old task id with the new task
      oldTask[taskId] = newTask;

      printPrettyJson(
          {'method': 'updateTask - success', 'customTask': oldTask});
      return {'customTask': oldTask};
    } catch (error) {
      printPrettyJson({'method': 'updateTask - error', 'error': error});
      return {'error': error};
    }
  }

  // Used at the beginning of the morning to create a nightly evaluation
  // for a specific task that the user have choosen for that day
  // Expecting the field:
  //  1. taskTitle (title of the choosen task)
  //  2. id - the current date (DD-MM-YY)
  //  3. isCustomTask (a task from experiment or from user)
  Future<Map<String, dynamic>> addNightlyEvalMorningEvent(
      Map<String, dynamic> data) async {
    printPrettyJson({'method': 'addNightlyEvalMorningEvent', 'data': data});
    try {
      NightlyEvaluation userInputEval = new NightlyEvaluation.fromData(data);
      userInputEval.hashedDate = calculateDateHash(data['id']);
      await nightlyEvalCollection.doc(data['id']).set(userInputEval.toJson());

      printPrettyJson({
        'method': 'addNightlyEvalMorningEvent - done',
        'nightlyEvalRecord': userInputEval
      });
      return {'nightlyEvalRecord': userInputEval};
    } catch (error) {
      printPrettyJson(
          {'method': 'addNightlyEvalMorningEvent - error', 'error': error});
      return {'error': error};
    }
  }

  // Creating a nightly evaluation for an user and store in user db
  // date format: MM-DD-YY. Expecting photo to be a base64 encoding
  // of user proof image
  Future<Map<String, dynamic>> updateNightlyEval(
      Map<String, dynamic> data) async {
    printPrettyJson({'method': 'updateNightlyEval', 'data': data});
    try {
      String id = data.remove('id');
      await nightlyEvalCollection.doc(id).update(data);
      DocumentSnapshot nightlyEvalSnapshot =
          await nightlyEvalCollection.doc(id).get();

      if (!nightlyEvalSnapshot.exists) {
        String message = 'Nightly evaluation with date = ${id} does not exist';
        printPrettyJson({'method': 'updateNightlyEval', 'message': message});
        return {'error': message};
      }

      NightlyEvaluation nightlyEvalRecord =
          new NightlyEvaluation.fromData(nightlyEvalSnapshot.data());
      printPrettyJson({
        'method': 'updateNightlyEval - success',
        'nightlyEvalRecord': nightlyEvalRecord
      });
      return {'nightlyEvalRecord': nightlyEvalRecord};
    } catch (error) {
      printPrettyJson({'method': 'updateNightlyEval - error', 'error': error});
      return {'error': error};
    }
  }

  // Querying a specific nightly evaluation of the user
  // expected date format: MM-DD-YY
  Future<Map<String, dynamic>> getUserNightlyEvalByDate(String date) async {
    printPrettyJson({'method': 'getUserNightlyEvalByDate', 'date': date});
    DocumentSnapshot nightlyEvalSnapshot;
    try {
      nightlyEvalSnapshot = await nightlyEvalCollection.doc(date).get();

      // User does not exist
      if (!nightlyEvalSnapshot.exists) {
        String message =
            'Nightly evaluation with date = ${date} does not exist';
        printPrettyJson(
            {'method': 'getUserNightlyEvalByDate', 'message': message});
        return {'error': message};
      }

      NightlyEvaluation nightlyEvalRecord =
          new NightlyEvaluation.fromData(nightlyEvalSnapshot.data());
      printPrettyJson({
        'method': 'getUserNightlyEvalByDate - success',
        'nightlyEvalRecord': nightlyEvalRecord
      });
      return {'nightlyEvalRecord': nightlyEvalRecord};
    } catch (error) {
      printPrettyJson(
          {'method': 'getUserNightlyEvalByDate - error', 'error': error});
      return {'error': error};
    }
  }

  // Retrieving a list of all nightly evaluation dates of an user
  // within a month. Need to receive the ending date of a month
  // in the format: MM-DD-YY
  Future<Map<String, dynamic>> getUserNightlyEvalDatesByMonth(
      String endDate) async {
    printPrettyJson({
      'method': 'getUserNightlyEvalDatesByMonth',
      'id': uid,
      'endDate': endDate
    });

    List<String> endDateSplit = endDate.split('-');
    int hashedStartDate =
        calculateDateHash(endDateSplit[0] + '-01-' + endDateSplit[2]);

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
      printPrettyJson({
        'method': 'getUserNightlyEvalDatesByMonth - successs',
        'nightEvalRecords': nightEvalRecords
      });
      return {'nightEvalRecords': nightEvalRecords};
    } catch (error) {
      printPrettyJson(
          {'method': 'getUserNightlyEvalDatesByMonth - error', 'error': error});
      return {'error': error};
    }
  }

  // Hashing the date for each nightly evaluation to help with retrieving
  // dates within a certain range
  int calculateDateHash(String date) {
    List<String> dateSplit = date.split('-');
    final int initialYear = 20;
    final int constantMultiplier = 31;

    int value = int.parse(dateSplit[0]) * constantMultiplier;
    value += int.parse(dateSplit[1]);
    value += (403 * (int.parse(date[3]) - initialYear));
    return value;
  }
}
