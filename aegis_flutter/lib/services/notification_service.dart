import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    await _plugin.initialize(
      const InitializationSettings(android: androidInit, iOS: iosInit),
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> showMessageNotification(String fromPeer, String preview) async {
    await _plugin.show(
      preview.hashCode,
      'New message from $fromPeer',
      preview.length > 60 ? '${preview.substring(0, 60)}...' : preview,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'signal_chat',
          'Chat Messages',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> showSosNotification({
    required String from,
    required String category,
    required String message,
  }) async {
    await _plugin.show(
      '$from-$category'.hashCode,
      'SOS ALERT — ${category.toUpperCase()}',
      '$from: $message',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'signal_sos',
          'SOS Alerts',
          importance: Importance.max,
          priority: Priority.max,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: DarwinNotificationDetails(interruptionLevel: InterruptionLevel.critical),
      ),
    );
  }

  Future<void> showResourceNotification(String fromPeer, String category) async {
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      'New resource post',
      '$fromPeer posted about $category',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'signal_resources',
          'Resource Feed',
          importance: Importance.defaultImportance,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
