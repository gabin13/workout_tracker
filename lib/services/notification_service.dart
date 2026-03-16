import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const DarwinInitializationSettings macosSettings = DarwinInitializationSettings();
    
    // Nouveauté V17 : paramètre nommé `settings`
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: macosSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings, 
    );
  }

  Future<void> scheduleWorkoutReminder(int id, String programmeNom, DateTime date) async {
    final scheduledDate = DateTime(date.year, date.month, date.day, 17, 30);
    
    if (scheduledDate.isBefore(DateTime.now())) return;

    // Nouveauté V17 : paramètres nommés stricts pécifisés dans l'appel
    await _localNotifications.zonedSchedule(
      id: id,
      title: 'Entraînement prévu !',
      body: '💪 C\'est l\'heure du $programmeNom !',
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'workout_reminder_channel',
          'Rappels d\'entraînement',
          channelDescription: 'Notifications pour les séances planifiées',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
        macOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelReminder(int id) async {
    await _localNotifications.cancel(id: id);
  }
}
