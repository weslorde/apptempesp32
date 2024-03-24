import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CustomNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  CustomNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _initializeNotifications();
  }

  void _onReciveResponse(NotificationResponse payload) {
    print(payload);
  }

  _initializeNotifications() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    //TODO fazer para iOS! notificacoes

    await localNotificationsPlugin.initialize(
      const InitializationSettings(android: android),
      onDidReceiveNotificationResponse: _onReciveResponse,
    );
    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  showNotification(CustomNotification notification) {
    androidDetails = const AndroidNotificationDetails(
      "channel_alarms",
      "Avisos e alarmes",
      importance: Importance.max,
      priority: Priority.max,
      enableVibration: true,
      enableLights: true,
      playSound: true,
      fullScreenIntent: true,
      sound: RawResourceAndroidNotificationSound('noticelong')
      //sound: RawResourceAndroidNotificationSound('notification'),
    );

    
    localNotificationsPlugin.show(
        notification.id,
        notification.title,
        notification.body,
        NotificationDetails(
          android: androidDetails,
        ),
        payload: notification.payload);
  }

  checkForNotifications() async {
    final details =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      print(details);
    }
  }
}