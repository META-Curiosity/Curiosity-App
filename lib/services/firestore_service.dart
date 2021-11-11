import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/models/custom_task.dart';
import 'package:curiosity_flutter/models/user.dart';

/* 
1) FireStoreService - the service expects an authenticated user id to perform neccessary operations 
2) At each call to the service, the return type is of type map
  a) If the key 'error' exist inside the return value -> there is an error from the method
  b) If the key 'error' does not exist -> the call is successful
*/

class FireStoreService {
  final String USER_DATABASE_NAME = 'tb-test';
  String uid;
  CollectionReference usersCollection;

  initialize(String uid) {
    usersCollection =
        FirebaseFirestore.instance.collection(this.USER_DATABASE_NAME);
    this.uid = uid;
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

  // [TODO]: replace the parameter later to optional id
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
      String email, String labId, bool contributeData) async {
    print({
      "method": "registerUser",
      "data": {"email": email, "labId": labId, "contributeData": contributeData}
    });
    try {
      User user = new User();
      user.labId = "-1";
      // [TODO]: Hash the email to id
      user.id = email;
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
      String userId, String taskId, CustomTask newTask) async {
    print({
      "method": "updateTask",
      "userId": userId,
      "taskId": taskId,
      "newTask": newTask
    });
    try {
      Map<String, dynamic> sharedObject = {
        "customTasks.${taskId}": newTask.toJson()
      };

      await usersCollection.doc(userId).update(sharedObject);

      // Retrieve the user from the database again
      Map<String, dynamic> newUser = await getUserById(userId);

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
}
