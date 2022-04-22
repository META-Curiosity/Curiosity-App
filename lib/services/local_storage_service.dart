import 'package:shared_preferences/shared_preferences.dart';
import './log_service.dart';
import '../const/local_storage_key.dart';


class LocalStorageService {

  final LogService log = new LogService();

  // Adding a key and value associated with the user mindfulness session notification
  // into the database
  Future<Map<String, dynamic>> addMindfulReminders(List<int> value) async {
    try {
      log.infoObj({'method': 'Local Storage - addMindfulReminders', 'value': value});

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String start = value[0].toString();
      String end = value[value.length - 1].toString();

      await prefs.setStringList(MINDFULNESS_NOTIFICATIONS_KEY, [start, end]);
      log.infoObj({'method': 'Local Storage - addMindfulReminders - success'});
      return {'success': true };
    } catch (error) {
      log.errorObj({'method': 'Local Storage - addMindfulReminders - error', 'error': error}, 1);
      return {'success': false, 'error': error};
    }
  }

  Future<Map<String, dynamic>> getMindfulReminders() async {
    try {
      log.infoObj({'method': 'retrieveMindfulReminders'});
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Verify if the user is elgible to receive notification
      Map<String, dynamic> isUserEligible = await getMindfulEligibility();
      if (isUserEligible[MINDFULNESS_ELIGIBILITY_KEY] == null) {
        log.infoObj({'method': 'retrieveMindfulReminders', 'msg': 'User not eligible to participate in mindfulness session'});
        return {"success": true, MINDFULNESS_NOTIFICATIONS_KEY: null};
      }

      List<String> reminderTimes = await prefs.getStringList(MINDFULNESS_NOTIFICATIONS_KEY);
      // User has not set a mindfulnessReminder time yet so ignore
      if (reminderTimes == null) {
        log.infoObj({'method': 'retrieveMindfulReminders', 'msg': 'User have not setup the reminder times for mindfulness session'});
        return {"success": true, MINDFULNESS_NOTIFICATIONS_KEY: null};
      }      
      List<int> mindfulReminders = transformStringToTimeList(reminderTimes);
      log.infoObj({'method': 'retrieveMindfulReminders - success', 'mindfulReminders': mindfulReminders });
      return {'success': true, MINDFULNESS_NOTIFICATIONS_KEY: mindfulReminders};
    } catch (error) {
      log.errorObj({'method': 'retrieveMindfulReminders - error', 'error': error}, 1);
      return {'success': false, 'error': error};
    }
  }

  // Add user mindfulness eligibility to the local storage
  Future<Map<String, dynamic>> addMindfulEligibility(bool eligibility) async {
    try {
      log.infoObj({'method': 'addMindfulEligibility', 'eligibility': eligibility});
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool(MINDFULNESS_ELIGIBILITY_KEY, eligibility);
      log.infoObj({'method': 'addMindfulEligibility - success'});
      return {'success': true };
    } catch (error) {
      log.errorObj({'method': 'addMindfulEligibility - error', 'error': error}, 1);
      return {'success': false, 'error': error};
    }
  }

  Future<Map<String, dynamic>> getMindfulEligibility() async {
    try {
      log.infoObj({'method': 'getMindfulEligibility'});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isUserEligibile = await prefs.getBool(MINDFULNESS_ELIGIBILITY_KEY);
      log.infoObj({'method': 'getMindfulEligibility - success', 'isUserEligibile': isUserEligibile});
      return {MINDFULNESS_ELIGIBILITY_KEY: isUserEligibile, 'success': true };
    } catch (error) {
      log.errorObj({'method': 'getMindfulEligibility - error', 'error': error}, 1);
      return {'success': false, 'error': error};
    }
  }

   // Add user hashed email in local storage for retrieval
  Future<Map<String, dynamic>> addUserHashedEmail(String hashedEmail) async {
    try {
      log.infoObj({'method': 'addUserHashedEmail', 'hashedEmail': hashedEmail});
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString(HASHED_EMAIL_KEY, hashedEmail);
      log.infoObj({'method': 'addUserHashedEmail - success'});

      return {'success': true };
    } catch (error) {
      log.errorObj({'method': 'addUserHashedEmail - error', 'error': error}, 1);
      return {'success': false, 'error': error};
    }
  }

  Future<Map<String, dynamic>> getUserHashedEmail() async {
    try {
      log.infoObj({'method': 'getUserHashedEmail'});
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String hashedEmail = await prefs.getString(HASHED_EMAIL_KEY);

      log.infoObj({'method': 'getUserHashedEmail - success', HASHED_EMAIL_KEY: hashedEmail});
      return {HASHED_EMAIL_KEY: hashedEmail, 'success': true };
    } catch (error) {
      log.errorObj({'method': 'getUserHashedEmail - error', 'error': error}, 1);
      return {'success': false, 'error': error};
    }
  }

  // Translating the reminder times into a list of integer for notification function to use
  List<int> transformStringToTimeList(List<String> notificationList) {
    int start = int.parse(notificationList[0]);
    int end = int.parse(notificationList[1]);
    List<int> notificationTimes = [];
    for (int time = start; time <= end; time++) {
      notificationTimes.add(time);
    }
    return notificationTimes;
  }
}