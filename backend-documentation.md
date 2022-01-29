# META Curiosity Backend Documentation

## Starting application via terminal
1. For web browsers
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
- Once finish remember to revert the changes back inside /web/index.html file as the old change allows Google OAuth.
- In order to view the logs from the backend service, user would need to use Chrome browser.
```
// Run the following command inside terminal to start application on Chrome
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

2. registerUserId() -> response
```dart
'''
Ouput:
  - Map<String, dynamic> response:
    - User user: an user object representing the user who just registered
'''
UserDbService userDbService = UserDbService(hashedEmail);
await userDbService.registerUserId();
```

3. updateUserLabId(labId) -> response
```dart
'''
Input:
  - int labId: The participants lab id
Ouput:
  - Map<String, dynamic> response:
    - Bool success: indicating if the operation has succeeded
'''
db.updateUserLabId(2);
```

4. updateUserConsent(agreed) -> response
```dart
'''
Input:
  - bool agreed: Shows consent to give data from participants
Ouput:
  - Map<String, dynamic> response:
    - bool success: indicating if the operation has succeeded
'''
db.updateUserConsent(true);
```

5. updateMindfulReminders(reminders) -> response
```dart
'''
Input:
  - List<int> reminders: the intervals by hours of the reminders
Output:
  - Map<String, dynamic> response:
    - bool success: indicating if the operation has succeeded
'''
db.updateMindfulReminders([9,10,11,12]);
```

6. updateCompleteActivityReminders(reminders) -> response
```dart
'''
Input:
  - List<int> reminders: the intervals by hours of the reminders
Output:
  - Map<String, dynamic> response:
    - bool success: indicating if the operation has succeeded
'''
db.updateCompleteActivityReminders([9,10,11,12]);
```

7. updateTask(taskId, newTask, oldTask) -> response
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

8. addDailyEvalMorningEvent(data) -> response
```dart
'''
Input: 
  - Map<String, dynamic> data:
    - String taskTitle: title of the choosen task
    - String id: the current date (MM-DD-YY)
    - Boolean isCustomTask: True = task created from user and False = task created by META
Ouput:
    - Map<String, dynamic> response:
      - DailyEvaluation dailyEvalRecord: the daily evaluation record after user chose their task for the day
    
'''
Map<String, dynamic> data = {
    'id': '11-20-21',
    'taskTitle': 'jogging in the morning',
    'isCustomTask': true
};
await userDbService.addDailyEvalMorningEvent(data);
```

9. updateDailyEval(data) -> response
```dart
'''
Input:
  - Map<String, dynamic> data:
    - String id: the current date (MM-DD-YY)
    - Boolean isSuccessful: daily evalu successful/not successful
    - String imageProof: Base64 encoding of the uploaded proof provided by the user | if empty can leave as null
    - String reflection: user daily reflection
Output:
  - Map<String, dynamic> response:
      - DailyEvaluation dailyEvalRecord: the daily evaluation record after user chose their task for the day
'''
Map<String, dynamic> data = {
    'id': '11-20-21',
    'isSuccessful': true,
    'imageProof': 'hello',
    'reflection': 'it went pretty well i would say'
};
await userDbService.updateDailyEval(data);
```

10. getUserDailyEvalByDate(date) -> response
```dart
'''
Input:
  - String date: Specific date of user daily evaluation (MM-DD-YY)
Ouput:
  - Map<String, dynamic> response:
      - DailyEvaluation dailyEvalRecord: the daily evaluation record queried
'''
await userDbService.getUserDailyEvalByDate('11-29-21');
```

11. getUserDailyEvalDatesByMonth(endDate) -> response
```dart
'''
Input:
  - String endDate: the ending date of the month to retrieve all the daily evaluation records within that month
Ouput:
  - Map<String, dynamic> response:
    - List<DailyEvaluation> dailyEvalRecords: a list of all inputted daily evaluation records of the whole month
'''
await userDbService.getUserDailyEvalDatesByMonth('11-30-21');
```

12. getUserData() -> response
```dart
'''
Ouput:
  - Map<String, dynamic> response:
    - User user: User information
'''
await userDbService.getUserData();
```

13. getUserStreakAndTotalDaysCompleted() -> response
```dart
'''
Ouput:
  - Map<String, dynamic> response:
    - int totalDaysRegistered: Number of days user have registered using the app,
    - int totalSuccessfulDays: Number of days the user successfully completed a task,
    - int currentStreak: Number of days in a row that the user completed a task
'''
await userDbService.getUserStreakAndTotalDaysCompleted();
```

14. updateCompleteActivityReminder(data) -> response
```dart
'''
Input:
  - Map<String, dynamic> data:
    - List<int> reminders: An array representing the interval of when users would like to be reminded to complete their daily activity.
Ouput:
  - Map<String, dynamic> response:
    - String msg: Indicating to the front-end that updating users daily activity reminder is successful
'''
// Representing the interval from 12PM - 4PM
Map<String, dynamic> data = {'reminders': [12, 13, 14, 15, 16]};
await userDbService.updateCompleteActivityReminder(data);
```

15. updateCompleteActivityReminder(data) -> response
```dart
'''
Input:
  - Map<String, dynamic> data:
    - List<int> reminders: An array representing the interval of when users would like to be reminded to complete their daily activity.
Ouput:
  - Map<String, dynamic> response:
    - String msg: Indicating to the front-end that updating users daily activity reminder is successful
'''
// Representing the interval from 8AM - 12PM
Map<String, dynamic> data = { 'reminders': [8, 9, 10, 11, 12]};
await userDbService.updateCompleteActivityReminder(data);
```

16. getRandomMetaTask(String difficulty) -> response
```dart
'''
Input:
    - String difficulty: difficulty | easy, intermediate, hard
Ouput:
  - Map<String, dynamic> response:
    -taskId: an integer representing the ID of a task within a given difficulty. This Id can be used with the MetaTaskDbService to obtain task details
    -userIndex: an integer representing the index of the task, this number is needed to remove this task from the list of remaining tasks if the user decides to select it.
'''
await userDbService.getRandomMetaTask('easy');
```

17. removeMetaTask(String difficulty, int index)
```dart
'''
Input:
    - String difficulty: difficulty | easy, intermediate, hard
    - Int index: the userIndex of the task that will be removed by this function
Ouput:
    - None
'''
await userDbService.removeMetaTask('easy', 5);
```

18. addMindfulnessSessionCompletion(String difficulty, int index)
```dart
'''
Input:
  - Map<String, dynamic> data:
    - String id: the current date (MM-DD-YY)
    - Boolean hasCompleted: True = mindfulness session completed is successful | False = mindfulness ession was not completed
Ouput:
  - Map<String, dynamic> response:
      - MindfulSession userMindfulInput: a record of the user entered mindfulness completion stored in the database
'''
Map<String, dynamic> data = {
  'hasCompleted': false,
  'id': '01-02-2022'
}
userDbService.addMindfulnessSessionCompletion(data);
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

3. getTaskByDifficultyAndID(difficulty, id) -> response
```dart
'''
Input:
  - String difficulty: task's difficulty | easy, intermediate, hard
  - int id: id of the task
Ouput:
  - Map<String, dynamic> response:
    - MetaTask metaTask: Queried task
'''
await metaTaskDbService.getTaskByDifficultyAndID('easy', 1);
```

4. getCountForDifficulty(String difficulty) -> response
```dart
'''
Input:
  - String difficulty: task's difficulty | easy, intermediate, hard
Ouput:
  - Map<String, dynamic> response:
    - count: Integer that represents the number of tasks for a given difficulty 
'''
await metaTaskDbService.getCountForDifficulty('easy');
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