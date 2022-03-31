importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js');

/*Update with yours config*/
const firebaseConfig = {
  apiKey: 'AIzaSyCh5J_5WLnOMGEsBpu5IyZsxkwPtMV080g',
  appId: '1:49671142207:web:d4820974e2641c1d35718a',
  messagingSenderId: '49671142207',
  projectId: 'curiosity-e1f26',
  authDomain: 'curiosity-e1f26.firebaseapp.com',
  databaseURL: 'https://curiosity-e1f26.firebaseio.com',
  storageBucket: 'curiosity-e1f26.appspot.com',
  measurementId: 'G-Y7P2RNV2TN',
};
firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

console.log('lets get it');
messaging.onBackgroundMessage(function (payload) {
  console.log('Received background message ', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
  };

  self.registration.showNotification(notificationTitle,
    notificationOptions);
});