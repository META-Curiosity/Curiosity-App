import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/services/log_service.dart';

class UserTokenDbService {
  final String USER_TOKEN_DB_NAME = "userToken-dev";
  final String ACTIVITY_SETUP_RECORD_DB_NAME = "activitySetupRecord-dev";
  final LogService log = LogService();
  CollectionReference userTokenCollection;
  CollectionReference activitySetupRecordCollection;

  UserTokenDbService() {
    userTokenCollection =
        FirebaseFirestore.instance.collection(USER_TOKEN_DB_NAME);
    activitySetupRecordCollection =
        FirebaseFirestore.instance.collection(ACTIVITY_SETUP_RECORD_DB_NAME);
  }

  Future<Map<String, dynamic>> addUserToken(
      String hashedEmail, String token) async {
    log.infoObj({
      'method': 'UserTokenDbService - addUserToken',
      'hashedEmail': hashedEmail,
      'token': token
    });
    try {
      await userTokenCollection.doc(hashedEmail).set({'token': token});
      log.successObj({
        'method': 'UserTokenDbService - addUserToken - success',
      });
      return {'success': true};
    } catch (error) {
      log.errorObj({
        'method': 'UserTokenDbService - addUserToken - error',
        'error': error.toString()
      });
      return {'error': error};
    }
  }

  Future<Map<String, dynamic>> markUserSetupCompleted(
      String hashedEmail, String date) async {
    log.infoObj({
      'method': 'UserTokenDbService - markUserSetupCompleted',
      'hashedEmail': hashedEmail,
      'date': date
    });
    try {
      DocumentSnapshot docSnapShot =
          await activitySetupRecordCollection.doc(date).get();
      if (docSnapShot.exists) {
        await activitySetupRecordCollection
            .doc(date)
            .update({'completedIds': FieldValue.arrayUnion([hashedEmail])});
      } else {
        await activitySetupRecordCollection
            .doc(date)
            .set({'completedIds': [hashedEmail]});
      }
      log.successObj({
        'method': 'UserTokenDbService - markUserSetupCompleted - success',
      });
      return {'success': true};
    } catch (error) {
      log.errorObj({
        'method': 'UserTokenDbService - markUserSetupCompleted - error',
        'error': error.toString()
      });
      return {'error': error};
    }
  }
}
