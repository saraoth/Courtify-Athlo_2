importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.0.0/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyD-I6QvA5z9RBbSR0dT-kGmIP8llG1_o64",
  authDomain: "courtify-athlo.firebaseapp.com",
  projectId: "courtify-athlo",
  storageBucket: "courtify-athlo.firebasestorage.app",
  messagingSenderId: "714906191204",
  appId: "1:714906191204:web:b1d2c57582d0a47d8a6671"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/firebase-logo.png'
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
