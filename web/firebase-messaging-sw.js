importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyCh5J_5WLnOMGEsBpu5IyZsxkwPtMV080g",
    authDomain: "curiosity-e1f26.firebaseapp.com",
    databaseURL: "https://curiosity-e1f26.firebaseio.com",
    projectId: "curiosity-e1f26",
    storageBucket: "curiosity-e1f26.appspot.com",
    messagingSenderId: "49671142207",
    appId: "1:49671142207:web:d4820974e2641c1d35718a",
    measurementId: "G-Y7P2RNV2TN"
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

