import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print('data from background $data');
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('notification from background $notification');
  }

  // Or do other work.
}

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  Function(String) onMessage;
  Function(String) onLaunch;
  Function(String) onResume;
  Function getTokenCallback;

  FirebaseNotifications.handler(this.onMessage, this.onLaunch, this.onResume) {
    setUpFirebase();
  }
  FirebaseNotifications.getToken(this.getTokenCallback) {
    _firebaseMessaging = FirebaseMessaging();
    if (Platform.isIOS) iOSPermission();
    // _firebaseMessaging.deleteInstanzzceID().then((b) {
    // print('instance deleted $b');
    _firebaseMessaging.getToken().then((token) {
      print(token);
      getTokenCallback(token);
      // });
      
    });
  }

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessagingListeners();
  }

  void firebaseCloudMessagingListeners() {
    // if (Platform.isIOS) iOS_Permission();
    // _firebaseMessaging.getToken().then((token) {
    //   print('This is FCM Token: $token');
    //   getTokenCallback(token);
    // });

    _firebaseMessaging.configure(
      // onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        onMessage(message['notification']['body']);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
        onResume(message['notification']['body']);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
        onLaunch(message['notification']['body']);
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
