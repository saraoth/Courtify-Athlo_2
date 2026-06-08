import { initializeApp } from 'firebase/app';
import { getAuth } from 'firebase/auth';
import { getFirestore, enableMultiTabIndexedDbPersistence } from 'firebase/firestore';
import { getStorage } from 'firebase/storage';
import { getMessaging } from 'firebase/messaging';

import firebaseConfig from '../firebase-applet-config.json';

/*
  ============================================================
  FLUTTER & DART NATIVE FIREBASE EQUIVALENT REFERENCE:
  ============================================================
  import 'package:firebase_core/firebase_core.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:firebase_messaging/firebase_messaging.dart';

  Future<void> initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "COURTIFY_API_KEY",
        authDomain: "courtify-athlo.firebaseapp.com",
        projectId: "courtify-athlo",
        storageBucket: "courtify-athlo.appspot.com",
        messagingSenderId: "COURTIFY_SENDER_ID",
        appId: "COURTIFY_APP_ID"
      ),
    );
    
    // Enable Offline Persistence in Dart:
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
  ============================================================
*/

const app = initializeApp(firebaseConfig);
export const db = getFirestore(app);

// Enable offline persistence for better mobile experience
if (typeof window !== 'undefined') {
  enableMultiTabIndexedDbPersistence(db).catch((err) => {
    if (err.code === 'failed-precondition') {
      // Multiple tabs open, persistence can only be enabled in one tab at a time.
      console.warn('Firestore persistence failed: Multiple tabs open');
    } else if (err.code === 'unimplemented') {
      // The current browser does not support all of the features required to enable persistence
      console.warn('Firestore persistence failed: Browser not supported');
    }
  });
}

export const auth = getAuth(app);
export const storage = getStorage(app);
export let messaging: any;
try {
  messaging = getMessaging(app);
} catch (e) {
  console.warn('Firebase Messaging not supported');
}

export default app;
