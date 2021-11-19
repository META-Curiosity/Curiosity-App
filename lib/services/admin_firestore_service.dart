import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/models/user.dart';
import 'package:pretty_json/pretty_json.dart';

/* 
1) Admin Firestore Service - the service is for admin to use to retrieve all 
users or search an user by their id
2) At each call to the service, the return type is of type map
  a) If the key 'error' exist inside the return value -> there is an error from the method
  b) If the key 'error' does not exist -> the call is successful
*/

class AdminFireStoreService {
  final String USER_DB_NAME = 'tb-test';
  final String NIGHTLY_EVALUATION_DB_NAME = 'nightlyEval';
  CollectionReference usersCollection;

  AdminFireStoreService() {
    usersCollection = FirebaseFirestore.instance.collection(USER_DB_NAME);
  }
  // Read and return all data from the users database, result can be accessed
  // inside the 'docs' key
  Future<Map<String, dynamic>> getAllUsers() async {
    printPrettyJson({'method': 'getAllUsers'});
    QuerySnapshot querySnapshot;
    List<dynamic> docs = [];
    try {
      querySnapshot = await usersCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          docs.add(new User.fromData(doc.data()));
        }
      }
      return {'docs': docs};
    } catch (error) {
      printPrettyJson({'method': 'getAllUsers - error', 'error': error});
      return {'error': error, 'docs': docs};
    }
  }

  // Querying for an user with the specific id. Result can be accessed
  // via the 'user' key
  Future<Map<String, dynamic>> getUserById(String id) async {
    printPrettyJson({'method': 'getUserById', 'id': id});
    DocumentSnapshot userSnapshot;
    try {
      userSnapshot = await usersCollection.doc(id).get();

      // User does not exist
      if (!userSnapshot.exists) {
        printPrettyJson({
          'method': 'getUserById - error',
          'message': 'User with ${id} does not exist'
        });
        return {'error': 'User with ${id} does not exist', 'user': new User()};
      }

      User newUser = new User.fromData(userSnapshot.data());
      printPrettyJson(
          {'method': 'getUserById - success', 'user': newUser.toJson()});
      return {'user': newUser};
    } catch (error) {
      printPrettyJson({'method': 'getUserById - error', 'error': error});
      return {'error': error, 'user': new User()};
    }
  }
}
