import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/models/meta_task.dart';
import 'package:curiosity_flutter/services/log_service.dart';
import 'package:crypto/crypto.dart';

/* 
1) AdminDbService - the service is for admin to use to retrieve all 
users or search an user by their id
2) At each call to the service, the return type is of type map
  a) If the key 'error' exist inside the return value -> there is an error from the method
  b) If the key 'error' does not exist -> the call is successful
*/

class MetaTaskDbService {
  final String META_TASK_DB_NAME = 'meta-task-dev';
  final LogService log = new LogService();
  CollectionReference taskCollection;

  MetaTaskDbService() {
    taskCollection = FirebaseFirestore.instance.collection(META_TASK_DB_NAME);
  }

  // Creating new task, expect passed in data to contain
  // 1. title - title of the task
  // 2. difficulty - difficulty | easy, intermediate, hard
  // 3. description - description of the task
  // 4. proofDescription - description on proof of task completion
  Future<Map<String, dynamic>> addMetaTask(Map<String, String> data) async {
    log.infoObj({'method': 'addMetaTask', 'data': data});
    try {
      // id created by hashing the title and difficulty of a task
      data['id'] = generateTaskId(data['title'] + data['difficulty']);

      // Id cannot exist in the database
      DocumentSnapshot dataInDb = await taskCollection.doc(data['id']).get();
      if (dataInDb.exists) {
        String message = 'A task with the same title and difficulty has already existed in the database';
        log.errorObj({'method': 'addMetaTask', 'error': message});
        return {'error': message};
      }

      MetaTask newTask = new MetaTask.fromData(data);
      await taskCollection.doc(newTask.id).set(newTask.toJson());
      log.successObj({'method': 'addMetaTask - success', 'newTask': newTask});
      return {'newTask': newTask};
    } catch (error) {
      log.errorObj({'method': 'addMetaTask - error', 'error': error}, 1);
      return {'error': error};
    }
  }

  // Retrieve all META-created task
  Future<Map<String, dynamic>> getAllTasks() async {
    log.infoObj({'method': 'getAllTasks'});
    try {
      List<MetaTask> metaTaskList = [];
      QuerySnapshot querySnapshot = await taskCollection.get();
      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs.toList()) {
          metaTaskList.add(new MetaTask.fromData(doc.data()));
        }
      }
      log.infoObj({'method': 'getAllTasks - success', 'metaTaskList': metaTaskList});
      return {'metaTaskList': metaTaskList};
    } catch (error) {
      log.errorObj({'method': 'getAllTasks - error', 'error': error.toString()});
      return {'error': error};
    }
  }

  // Retrieving a task by their difficulty level and the title
  Future<Map<String, dynamic>> getTaskByTitleAndDifficulty(String title, String difficulty) async {
    log.infoObj({
      'method': 'getTaskByTitleAndDifficulty',
      'title': title,
      'difficulty': difficulty
    });
    try {
      String id = generateTaskId(title + difficulty);
      DocumentSnapshot task = await taskCollection.doc(id).get();

      // User does not exist
      if (!task.exists) {
        String message = 'Task does not exist';
        log.errorObj({'method': 'getTaskByTitleAndDifficulty', 'error': message});
        return {'error': message};
      }
      MetaTask metaTask = new MetaTask.fromData(task.data());
      log.successObj({
        'method': 'getTaskByTitleAndDifficulty - success',
        'metaTask': metaTask
      });
      return {'metaTask': metaTask};
    } catch (error) {
      log.errorObj({
        'method': 'getTaskByTitleAndDifficulty - error',
        'error': error.toString()
      });
      return {'error': error};
    }
  }

  // Hashing the task title as unique id to store inside db
  String generateTaskId(String titleDifficulty) {
    return sha256.convert(utf8.encode(titleDifficulty)).toString();
  }
}
