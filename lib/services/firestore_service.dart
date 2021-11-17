import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:curiosity_flutter/models/nightly_evaluation.dart';
import 'package:curiosity_flutter/models/user.dart';

/* 
1) FireStoreService - the service expects an authenticated user id to perform neccessary operations 
2) At each call to the service, the return type is of type map
  a) If the key 'error' exist inside the return value -> there is an error from the method
  b) If the key 'error' does not exist -> the call is successful
*/

class FireStoreService {
  final String USER_DB_NAME = 'tb-test';
  final String NIGHTLY_EVALUATION_DB_NAME = 'nightlyEval';
  String uid;
  CollectionReference usersCollection;
  CollectionReference nightlyEvalCollection;

  FireStoreService(String uid) {
    this.uid = uid;
    usersCollection = FirebaseFirestore.instance.collection(USER_DB_NAME);
    nightlyEvalCollection =
        usersCollection.doc(uid).collection(NIGHTLY_EVALUATION_DB_NAME);
  }

  // Read and return all data from the users database, result can be accessed
  // inside the 'docs' key
  Future<Map<String, dynamic>> getAllUsers() async {
    print({"method": 'getAllUsers'});
    QuerySnapshot querySnapshot;
    List<dynamic> docs = [];
    try {
      querySnapshot = await usersCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          docs.add(new User.fromData(doc.id, doc.data()));
        }
      }
      return {"docs": docs};
    } catch (error) {
      print({'method': 'getAllUsers', 'error': error});
      return {"error": error, "docs": docs};
    }
  }

  // Querying for an user with the specific id. Result can be accessed
  // via the 'user' key
  Future<Map<String, dynamic>> getUserById(String id) async {
    print({'method': 'getUserById', 'id': id});
    DocumentSnapshot userSnapshot;
    try {
      userSnapshot = await usersCollection.doc(id).get();

      // User does not exist
      if (!userSnapshot.exists) {
        print({
          'method': 'getUserById',
          'message': 'User with ${id} does not exist'
        });
        return {"error": 'User with ${id} does not exist', "user": new User()};
      }

      User newUser = new User.fromData(id, userSnapshot.data());
      print({'method': 'getUserById', 'user': newUser.toJson()});
      return {"user": newUser};
    } catch (error) {
      print({'method': 'getUserById', 'error': error});
      return {"error": error, "user": new User()};
    }
  }

  // Adding new user to the database, if successful the new user data can be
  // accessed via the 'user' key of the response
  Future<Map<String, dynamic>> registerUser(
      String hashedEmail, String labId, bool contributeData) async {
    print({
      "method": "registerUser",
      "data": {
        "email": hashedEmail,
        "labId": labId,
        "contributeData": contributeData
      }
    });
    try {
      User user = new User();
      user.labId = "-1";
      // [TODO]: Hash the email to id
      user.id = hashedEmail;
      user.contributeData = contributeData;

      // Put the new user id into the db
      await usersCollection.doc(user.id).set(user.toJson());
      print({"method": "registerUser", "user": user.toJson()});
      return {'user': user};
    } catch (error) {
      print({'method': 'registerUser', 'error': error});
      return {'error': error, 'user': new User()};
    }
  }

  // Update user task via the position passed in and new values -
  // Upon successful update - the value of the new updated user can be accessed
  // in the key 'user' of the returned response
  Future<Map<String, dynamic>> updateTask(
      String taskId, CustomTask newTask) async {
    print({
      "method": "updateTask",
      "userId": this.uid,
      "taskId": taskId,
      "newTask": newTask
    });
    try {
      Map<String, dynamic> sharedObject = {
        "customTasks.${taskId}": newTask.toJson()
      };

      await usersCollection.doc(this.uid).update(sharedObject);

      // Retrieve the user from the database again
      Map<String, dynamic> newUser = await getUserById(this.uid);

      // Getting the user by their id results in an error => return the error
      if (newUser.containsKey("error")) {
        print({"method": "updateTask - error", "error": newUser["error"]});
        return {'error': newUser["error"], 'user': new User()};
      }

      // Successful output
      print({"method": "updateTask - done", "user": newUser["user"]});
      return {'user': newUser["user"]};
    } catch (error) {
      print({"method": "updateTask - error", "error": error});
      return {'error': error, 'user': new User()};
    }
  }

  // Creating a nightly evaluation for an user and store in user db
  // date format: MM-DD-YY
  // Expecting photo to be a base64 encoding of user proof image
  Future<Map<String, dynamic>> addNightlyEvalToDb(
      String date, String reflection, bool isSuccessful,
      [String imageProof = '']) async {
    print({
      "method": "addNightlyEval",
      "date": date,
      "isSuccessful": isSuccessful,
      "imageProof": imageProof
    });
    try {
      NightlyEvaluation userInputEval = new NightlyEvaluation.fromInput(
          date, reflection, imageProof, isSuccessful, _calculateDateHash(date));
      await nightlyEvalCollection.doc(date).set(userInputEval.toJson());

      // Successful output
      print({"method": "addNightlyEval - done", "nightlyEval": userInputEval});
      return {"nightlyEval": userInputEval};
    } catch (error) {
      return {'error': error, 'nightlyEval': new NightlyEvaluation()};
    }
  }

  // Querying a specific nightly evaluation of the user
  // expected date format: MM-DD-YY
  Future<Map<String, dynamic>> getUserNightlyEvalByDate(String date) async {
    print({'method': 'getUserNightlyEvalByDate', 'id': this.uid, 'date': date});
    DocumentSnapshot nightlyEvalSnapshot;
    try {
      nightlyEvalSnapshot = await nightlyEvalCollection.doc(date).get();

      // User does not exist
      if (!nightlyEvalSnapshot.exists) {
        String message =
            'Nightly evaluation with date = ${date} does not exist';
        print({'method': 'getUserNightlyEvalByDate', 'message': message});
        return {"error": message, "nightlyEval": new NightlyEvaluation()};
      }

      NightlyEvaluation newNightlyEval =
          new NightlyEvaluation.fromData(nightlyEvalSnapshot.data());
      print({
        'method': 'getUserNightlyEvalByDate',
        'nightlyEval': newNightlyEval.toJson()
      });
      return {"nightlyEval": newNightlyEval};
    } catch (error) {
      print({'method': 'getUserNightlyEvalByDate', 'error': error});
      return {"error": error, "nightlyEval": new NightlyEvaluation()};
    }
  }

  // Retrieving a list of all nightly evaluation dates of an user within
  // a month
  // Need to receive the ending date of a month in the format: MM-DD-YY
  Future<Map<String, dynamic>> getUserNightlyEvalDatesByMonth(
      String endDate) async {
    print({
      'method': 'getUserNightlyEvalDatesByMonth',
      'id': this.uid,
      'endDate': endDate
    });

    List<String> endDateSplit = endDate.split('-');
    int hashedStartDate =
        _calculateDateHash(endDateSplit[0] + '-01-' + endDateSplit[2]);

    QuerySnapshot querySnapshot;
    List<dynamic> nightlyEvalDates = [];
    try {
      querySnapshot = await nightlyEvalCollection
          .where('hashedDate', isGreaterThanOrEqualTo: hashedStartDate)
          .where('hashedDate', isLessThanOrEqualTo: _calculateDateHash(endDate))
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          nightlyEvalDates.add(new NightlyEvaluation.fromData(doc.data()));
        }
      }
      print({
        'method': 'getUserNightlyEvalDatesByMonth - successs',
        'nightlyEvalDates': nightlyEvalDates
      });
      return {"nightlyEvalDates": nightlyEvalDates};
    } catch (error) {
      print({'method': 'getUserNightlyEvalDatesByMonth', 'error': error});
      return {"error": error, "nightlyEvalDates": nightlyEvalDates};
    }
  }

  // Hashing the date for each nightly evaluation for the purpose of retrieving date
  int _calculateDateHash(String date) {
    List<String> dateSplit = date.split('-');
    final int initialYear = 20;
    final int constantMultiplier = 31;

    int value = int.parse(dateSplit[0]) * constantMultiplier;
    value += int.parse(dateSplit[1]);
    value += (403 * (int.parse(date[3]) - initialYear));
    return value;
  }
}
