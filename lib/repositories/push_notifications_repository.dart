import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);

class PushNotificationRepository {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static final _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final StreamController<String> _messageStream =
      StreamController.broadcast();

  static Stream<String> get messagesStream => _messageStream.stream;

  /// Returns the FCM token.
  Future<String?> getToken() async => FirebaseMessaging.instance.getToken();

  /// Initialized [Firebase] service. This method must be called before
  /// using any other method to ensure that the service is initialized.
  static Future<void> initializeApp() async {
    // Push Notifications
    await Firebase.initializeApp(
        // TODO(me): Execute `flutterfire configure` command to create a firebase config file
        // options: DefaultFirebaseOptions.currentPlatform,
        );
    await requestPermission();

    final token = await FirebaseMessaging.instance.getToken();

    log('FCM Token 🔑: $token');

    // Handlers
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    // Local Notifications
  }

  /// For Apple & Web only.
  ///
  /// Requests device permission to receive push notifications.
  static Future<void> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    await messaging.requestPermission();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            // alert: true, // Required to display a heads up notification
            // badge: true,
            // sound: true,
            );

    // log('User granted permission: ${settings.authorizationStatus}');
  }

  static void close() {
    _messageStream.close();
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    // _messageStream.add(message.data['product'] ?? 'No data');
    final notification = message.notification;
    final android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            // other properties...
          ),
        ),
      );
    }
  }

  static Future<void> _onMessageHandler(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            // other properties...
          ),
        ),
      );
    }
    // _messageStream.add(message.data['product'] ?? 'No data');
  }

  static Future<void> _onMessageOpenApp(RemoteMessage message) async {
    // _messageStream.add(message.data['product'] ?? 'No data');
    final notification = message.notification;
    final android = message.notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: android.smallIcon,
            // other properties...
          ),
        ),
      );
    }
  }
}
