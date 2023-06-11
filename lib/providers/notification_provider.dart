import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  NotificationProvider(this._flutterLocalNotificationsPlugin);

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterLocalNotificationsPlugin;
}
