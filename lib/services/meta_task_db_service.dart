import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curiosity_flutter/models/meta_task.dart';
import 'package:curiosity_flutter/services/log_service.dart';

class MetaTaskDbServices {
  final String META_TASK_DB_NAME = 'meta-task';
  final LogService log = new LogService();
  CollectionReference taskCollection;

  MetaTaskDbServices() {
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
      DocumentSnapshot documents = await taskCollection.doc(data['difficulty']).get();
      int count = documents.get("count");

      MetaTask newTask = new MetaTask.fromData(data);
      await taskCollection.doc(data['difficulty']).collection("tasks").doc((count+1).toString()).set(newTask.toJson());
      await taskCollection.doc(data['difficulty']).update({"count": FieldValue.increment(1)});
      log.successObj({'method': 'addMetaTask - success', 'newTask': newTask});
      return {'newTask': newTask};
    } catch (error) {
      log.errorObj({'method': 'addMetaTask - error', 'error': error}, 1);
      return {'error': error};
    }
  }

  // Retrieving a task by their difficulty and id
  Future<Map<String, dynamic>> getTaskByDifficultyAndID(String difficulty, int id) async {
    log.infoObj({
      'method': 'getTaskByDifficultyAndID',
      'difficulty': difficulty,
      'id' : id
    });
    try {
      DocumentSnapshot task = await taskCollection.doc(difficulty).collection("tasks").doc(id.toString()).get();

      // Task does not exist
      if (!task.exists) {
        String message = 'Task does not exist';
        log.errorObj({'method': 'getTaskByDifficultyAndID', 'error': message});
        return {'error': message};
      }
      MetaTask metaTask = new MetaTask.fromData(task.data());
      log.successObj({
        'method': 'getTaskByDifficultyAndID - success',
        'metaTask': metaTask
      });
      return {'metaTask': metaTask};
    } catch (error) {
      log.errorObj({
        'method': 'getTaskByDifficultyAndID - error',
        'error': error.toString()
      });
      return {'error': error};
    }
  }

  // Gets the count of tasks for a difficulty
  Future<Map<String, dynamic>> getCountForDifficulty(String difficulty) async {
    log.infoObj({
      'method': 'getCountForDifficulty',
      'difficulty': difficulty,
    });
    try {
      DocumentSnapshot document = await taskCollection.doc(difficulty).get();

      // Task does not exist
      if (!document.exists) {
        String message = 'Difficulty does not exist';
        log.errorObj({'method': 'getCountForDifficulty', 'error': message});
        return {'error': message};
      }

      log.successObj({
        'method': 'getCountForDifficulty - success',
        'count': document['count']
      });

      return {'count': document['count']};
    } catch (error) {
      log.errorObj({
        'method': 'getCountForDifficulty - error',
        'error': error.toString()
      });
      return {'error': error};
    }
  }
}
