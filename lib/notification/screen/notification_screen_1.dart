import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen1 extends StatefulWidget {
  const NotificationScreen1({super.key});

  @override
  State<NotificationScreen1> createState() => _NotificationScreen1State();
}

class _NotificationScreen1State extends State<NotificationScreen1> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }

    (context as Element).visitChildElements(rebuild);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialFirbaseMessaging();
    setupInteractedMessage();
  }

  Future<void> setupInteractedMessage() async {
    // get any message which caused the application to open from terminate state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
    // also handel any interaction when the app is in the background via a stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {}

  void initialFirbaseMessaging() async {
    // you may set the permission requirest to provisional which allow the user to choose what type
    // of notification they would like to receive once the user receives a notification.

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log("User Granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      log("User Granted provisional permission");
    } else {
      log('User declined or has not accepted permission');
    }

    // for apple platform, ensure the APNS token is available before making any FCM plugin api call
    final apnsToken = await messaging.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCm plugin api requests...
    }
    await AwesomeNotifications().initialize(null, <NotificationChannel>[
      NotificationChannel(
          channelKey: 'notification',
          channelName: "Notification",
          channelDescription: "Firebase Notification",
          importance: NotificationImportance.High,
          playSound: true,
          enableVibration: true,
          enableLights: true)
    ]);

    final token = await messaging.getToken();
    log(token ?? '');
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("Got message whilst in the foreground!");
      log("message data ${message.data}");

      final AndroidNotification? androidNotification =
          message.notification?.android;
      final AppleNotification? appleNotification = message.notification?.apple;
      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }

      if (message.notification != null &&
          (androidNotification != null || appleNotification != null)) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 20,
              channelKey: 'notification',
              title: message.notification?.title ?? '',
              body: message.notification?.body ?? ''),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? androidNotification =
          message.notification?.android;
      if (notification != null && androidNotification != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: int.parse(
                message.senderId ?? '12345',
              ),
              channelKey: 'notification',
              title: message.notification?.title ?? '',
              body: message.notification?.body ?? ''),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(
              "Notification Screen",
            ),
          ],
        ),
      ),
    );
  }
}
