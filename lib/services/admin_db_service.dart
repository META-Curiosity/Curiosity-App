import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:curiosity_flutter/services/log_service.dart';

/*
1) AdminDbService - the service is for admin to use to retrieve all 
users or search an user by their id
2) At each call to the service, the return type is of type map
  a) If the key 'error' exist inside the return value -> there is an error from the method
  b) If the key 'error' does not exist -> the call is successful
*/

class AdminDbService {
  final String USER_DB_NAME = 'users-dev';
  final String NIGHTLY_EVALUATION_DB_NAME = 'meta-task-dev';
  final LogService log = new LogService();
  CollectionReference usersCollection;

  AdminDbService() {
    usersCollection = FirebaseFirestore.instance.collection(USER_DB_NAME);
  }

  // Read and return all data from the users database, succesful
  // result can be accessed inside the 'docs' key
  Future<Map<String, dynamic>> getAllUsers() async {
    log.infoObj({'method': 'getAllUsers'});
    try {
      List<User> users = [];
      QuerySnapshot querySnapshot = await usersCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          users.add(new User.fromData(doc.data()));
        }
      }
      return {'users': users};
    } catch (error) {
      log.errorObj(
          {'method': 'getAllUsers - error', 'error': error.toString()});
      return {'error': error};
    }
  }

  // Querying for an user with the specific id. Successful result
  //  can be accessed via the 'user' key
  Future<Map<String, dynamic>> getUserById(String id) async {
    log.infoObj({'method': 'getUserById', 'id': id});
    DocumentSnapshot userSnapshot;
    try {
      userSnapshot = await usersCollection.doc(id).get();
      // User does not exist
      if (!userSnapshot.exists) {
        log.errorObj({
          'method': 'getUserById - error',
          'error': 'User with ${id} does not exist'
        }, 1);
        return {'user': null};
      }
      User newUser = new User.fromData(userSnapshot.data());
      log.successObj({'method': 'getUserById - success', 'user': newUser});
      return {'user': newUser};
    } catch (error) {
      log.errorObj(
          {'method': 'getUserById - error', 'error': error.toString()});
      return {'error': error};
    }
  }
}
