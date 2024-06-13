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

  void _onAndroidReciveResponse(NotificationResponse payload) {
    print(payload);
  }

  void _onIOSReciveResponse(
      int id, String? title, String? body, String? payload) {
    print(payload);
  }

  _initializeNotifications() async {
    // Android
    const iniAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // Ios
    var iniIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onIOSReciveResponse,
    );

    await localNotificationsPlugin.initialize(
      InitializationSettings(android: iniAndroid, iOS: iniIOS),
      onDidReceiveNotificationResponse: _onAndroidReciveResponse,
    );

    await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  showNotification(CustomNotification notification) {
    androidDetails = const AndroidNotificationDetails(
        "channel_alarms10", "Avisos e alarmes10",
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true,
        enableLights: true,
        playSound: true,
        fullScreenIntent: true,
        sound: RawResourceAndroidNotificationSound('slow_spring_board')
        //sound: RawResourceAndroidNotificationSound('slow_spring_board.mp3')
        //sound: RawResourceAndroidNotificationSound('notification'),
        );

    localNotificationsPlugin.show(
        notification.id,
        notification.title,
        notification.body,
        NotificationDetails(
          android: androidDetails,
          iOS: const DarwinNotificationDetails(),
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
