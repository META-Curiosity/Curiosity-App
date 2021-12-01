# META Curiosity Backend Documentation

## Starting application via terminal
1. For web browsers (Chrome)
```html
<!-- Uncomment out the 3 scripts tag line below inside /web/index.html file-->
  <!-- <script src="https://www.gstatic.com/firebasejs/7.22.1/firebase-app.js"></script>
  <script src="https://www.gstatic.com/firebasejs/7.22.1/firebase-firestore.js"></script>
  <script src="https://www.gstatic.com/firebasejs/7.22.1/firebase-auth.js"></script> -->

<!-- Comment out the 3 scripts tag line below inside /web/index.html file-->
  <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-app.js"></script>
  <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-firestore.js"></script>
  <script src="https://www.gstatic.com/firebasejs/8.6.1/firebase-auth.js"></script>
```
- Once finish remember to revert the changes back inside /web/index.html file as the old change allows Google OAuth
```
// Run the following command inside terminal to start application on chrome
flutter run -d chrome --web-port 8000
```

-----------------------------------------------------------------------------------------------

## Back-end return format
- At each call to the service, the return type will be of Future<Map<String, dynamic>> 
  - Future type due to an asynchronous call the the database
  - Map<String, dynamic> due to mimicking API JSON response format
- If the key 'error' exist inside the return dictionary -> there is an error from the method
- If the key 'error' does not exist inside the return dictionary -> the call is successful
- The key 'error' is of type String
-----------------------------------------------------------------------------------------------
## User Database Service - UserDbService
1. Constructor
```dart
'''
Input:
  - String uid: User's hashed email after logging in
Output:
  - Ouput new UserDbService object
'''
UserDbService userDbService = new UserDbService('HASHED_EMAIL');
```

2. registerUser(data) -> response
```dart
'''
Input:
  - Map<String, dynamic> data:
    - String labId: The lab id given by the META lab
    - Boolean contributeData: Determine whether a given user wants to contribte their data to the study
Ouput:
  - Map<String, dynamic> response:
    - User user: an user object representing the user who just registered
'''
Map<String, dynamic> data = {'labId': '-1', 'contributeData': true};
await userDbService.registerUser(data);
```

3. updateTask(taskId, newTask, oldTask) -> response
```dart
'''
Note: No task with the same title
Input:
  - String taskId: The id of the task that is being updated
  - CustomTask newTask: The task object to update in the database
  - Map<String, CustomTask> oldTask: each id maps to a customTask object from user
Ouput:
  - Map<String, dynamic> response:
    - Map<String, CustomTask> customTask: an mapping of updated custom tasks dictionary
'''
Map<String, dynamic> data = {
    "method": "open google chrome and watch youtube tutorials",
    "title": "To do better",
    "moment": "every day",
    "proof": "create a new full stack application with nodejs and react"
};
CustomTask zero = new CustomTask.fromData(data);
// To be replace by the user original tasks dictionary in the database
Map<String, CustomTask> oldTask = {'0': new CustomTask(), ..., '5': new CustomTask()};
db.updateTask('1', new CustomTask.fromData(data), oldTask);
```

4. addNightlyEvalMorningEvent(data) -> response
```dart
'''
Input: 
  - Map<String, dynamic> data:
    - String taskTitle: title of the choosen task
    - String id: the current date (MM-DD-YY)
    - Boolean isCustomTask: True = task created from user and False = task created by META
Ouput:
    - Map<String, dynamic> response:
      - NightlyEvaluation nightlyEvalRecord: the nightly evaluation record after user chose their task for the day
    
'''
Map<String, dynamic> data = {
    'id': '11-20-21',
    'taskTitle': 'jogging in the morning',
    'isCustomTask': true
};
await userDbService.addNightlyEvalMorningEvent(data);
```

5. updateNightlyEval(data) -> response
```dart
'''
  - Map<String, dynamic> data:
    - String id: the current date (MM-DD-YY)
    - Boolean isSuccessful: True = nightly evaluation is successful | False = night evaluation is unsuccessful
    - String imageProof: Base64 encoding of the uploaded proof provided by the user | if empty can leave as null
    - String reflection: user nightly reflection
  - Map<String, dynamic> response:
      - NightlyEvaluation nightlyEvalRecord: the nightly evaluation record after user chose their task for the day
'''
Map<String, dynamic> data = {
    'id': '11-20-21',
    'isSuccessful': true,
    'imageProof': 'hello',
    'reflection': 'it went pretty well i would say'
};
await userDbService.updateNightlyEval(data);
```

6. getUserNightlyEvalByDate(date) -> response
```dart
'''
Input:
  - String date: Specific date of user nightly evaluation (MM-DD-YY)
Ouput:
  - Map<String, dynamic> response:
      - NightlyEvaluation nightlyEvalRecord: the nightly evaluation record queried
'''
await userDbService.getUserNightlyEvalByDate('11-29-21');
```

7. getUserNightlyEvalDatesByMonth(endDate) -> response
```dart
'''
Input:
  - String endDate: the ending date of the month to retrieve all the nightly evaluation records within that month
Ouput:
  - Map<String, dynamic> response:
    - List<NightlyEvaluation> nightEvalRecords:a list of all inputted nightly evaluation records of the whole month
'''
await userDbService.getUserNightlyEvalDatesByMonth('11-30-21');
```
-----------------------------------------------------------------------------------------------
## Admin Database Service - AdminDbService
1. Constructor
```dart
'''
Output:
  Ouput new AdminDbService service object
'''
AdminDbService adminDbService = new AdminDbService();
```

2. getUserById(id) -> response
```dart
'''
Input:
  - String id: querying user id
Ouput:
  - Map<String, dynamic> response:
    - User user: queried user object
'''
await adminDbService.getUserById('id');
```

3. getAllUsers() -> response
```dart
'''
Ouput:
  - Map<String, dynamic> response:
    - List<User> users: A list containing all the users in the users database
'''
await adminDbService.getAllUsers();
```
-----------------------------------------------------------------------------------------------
## META task database service - MetaTaskDbService
1. Constructor
```dart
'''
Output:
  Ouput new MetaTaskDbService object
'''
MetaTaskDbService metaTaskDbService = new MetaTaskDbService();
```

2. addMetaTask(data) -> response
```dart
'''
Input:
  - Map<String, String> data:
    - String title: title of the task
    - String difficulty: difficulty | easy, intermediate, hard
    - String description: description of the task
    - String proofDescription: description on proof of task completion
Ouput:
  - Map<String, dynamic> response:
    - MetaTask newTask: Newly created task by the META team
'''
Map<String, String> task = {
    'title': 'Sleep challenge',
    'difficulty': 'easy',
    'description': 'to sleep 8 hours a day',
    'proofDescription': 'timing yourself doing that',
};
await metaTaskDbService.addMetaTask(task);
```

3. getAllTasks() -> response
```dart
'''
Ouput:
  - Map<String, dynamic> response:
    - List<MetaTask> metaTaskList: List of all task generated by META
'''
await metaTaskDbService.getAllTasks();
```

4. getTaskByTitleAndDifficulty(title, difficulty) -> response
```dart
'''
Input:
  - String title: title of the task
  - String difficulty: task's difficulty | easy, intermediate, hard
Ouput:
  - Map<String, dynamic> response:
    - MetaTask metaTask: Queried task
'''
await metaTaskDbService.getTaskByTitleAndDifficulty('title', 'easy');
```
5. Note
- In order to delete or update a META task, can use the function here to get its ID and use that to query the correct document inside the META task database.
```dart
'''
Input:
  - String title: title of the task
  - String difficulty: task's difficulty | easy, intermediate, hard
Ouput:
  - String id: return the id of the task
'''
// Hashing the task title as unique id to store inside db
String generateTaskId(String titleDifficulty) {
  return sha256.convert(utf8.encode(titleDifficulty)).toString();
}
print(generateTaskId('TASK TITLE', 'TASK DIFFICULTY'));
```
-----------------------------------------------------------------------------------------------
## Log Service - Utilized to print logs in the console
1. Constructor
```dart
LogService logService = new LogService();
```

2. infoObj(data, stackCall) 
- Used to print out informational, and data is an object
```dart
'''
Input:
  - Map<String, dynamic> data: The object that should be logged
  - int stackCall (OPTIONAL | DEFAULT = 0): The number of stack leading to the executed log
'''
logService.infoObj({'method': 'name'}); // default stack call of 0
```

3. infoString(message, stackCall) 
- Used to print out informational, and message is a string
```dart
'''
Input:
  - String message: The message log
  - int stackCall (OPTIONAL | DEFAULT = 0): The number of stack leading to the executed log
'''
logService.infoString('hey there', 2);
```

4. successObj(data, stackCall) 
- Used to print out successful execution, and data is an object
```dart
'''
Input:
  - Map<String, dynamic> data: The object that should be logged
  - int stackCall (OPTIONAL | DEFAULT = 0): The number of stack leading to the executed log
'''
logService.successObj({'method': 'name - success'}); // default stack call of 0
```

5. successString(message, stackCall) 
- Used to print out success execution and message is a string
```dart
'''
Input:
  - String message: The message log
  - int stackCall (OPTIONAL | DEFAULT = 0): The number of stack leading to the executed log
'''
logService.successString('Successful alert', 2);
```

6. errorObj(data, stackCall) 
- Used to print out error execution, and data is an object
```dart
'''
Input:
  - Map<String, dynamic> data: The object that should be logged
  - int stackCall (OPTIONAL | DEFAULT = 0): The number of stack leading to the executed log
'''
logService.errorObj({'method': 'name - error'}); // default stack call of 0
```

7. errorString(message, stackCall) 
- Used to print out error execution, and message is a string
```dart
'''
Input:
  - String message: The message log
  - int stackCall (OPTIONAL | DEFAULT = 0): The number of stack leading to the executed log
'''
logService.errorString('error ALERT', 2);
```