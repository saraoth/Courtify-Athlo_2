import 'dart:async';
import 'package:flutter/material';

class NotificationPayload {
  final String id;
  final String title;
  final String body;
  final DateTime scheduledTime;
  final String sport;
  final String location;
  bool isDelivered;
  bool isRead;

  NotificationPayload({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledTime,
    required this.sport,
    required this.location,
    this.isDelivered = false,
    this.isRead = false,
  });

  NotificationPayload copyWith({
    bool? isDelivered,
    bool? isRead,
  }) {
    return NotificationPayload(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      sport: sport,
      location: location,
      isDelivered: isDelivered ?? this.isDelivered,
      isRead: isRead ?? this.isRead,
    );
  }
}

class LocalNotificationService extends ChangeNotifier {
  // Singleton pattern
  static final LocalNotificationService _instance = LocalNotificationService._internal();
  factory LocalNotificationService() => _instance;
  LocalNotificationService._internal() {
    // Seed initial notifications to simulate history
    _notifications.addAll([
      NotificationPayload(
        id: 'notif_1',
        title: 'Training Session Scheduled 🎾',
        body: 'Your Tennis match at Clay Supreme Court is confirmed for tomorrow.',
        scheduledTime: DateTime.now().subtract(const Duration(hours: 2)),
        sport: 'Tennis',
        location: 'Indoor Court 01',
        isDelivered: true,
        isRead: true,
      ),
      NotificationPayload(
        id: 'notif_2',
        title: 'Upcoming Warmup Reminder 🏋️',
        body: 'Pro-coaching session starts in 1 hour. Get ready with kinetic wrist flexion drills!',
        scheduledTime: DateTime.now().subtract(const Duration(minutes: 45)),
        sport: 'Fitness',
        location: 'Athlo Biometrics Suite',
        isDelivered: true,
        isRead: false,
      ),
    ]);

    // Active polling thread to check scheduled timers
    _timer = Timer.periodic(const Duration(seconds: 1), _checkScheduledAlerts);
  }

  final List<NotificationPayload> _notifications = [];
  Timer? _timer;

  // Track currently active HUD heads-up display alert to animate slide-down banners
  NotificationPayload? _activeHUDNotification;
  NotificationPayload? get activeHUDNotification => _activeHUDNotification;

  // Preferences configuration
  bool _notificationsEnabled = true;
  bool get notificationsEnabled => _notificationsEnabled;

  int _reminderOffsetMinutes = 15; // Warn in advance (configured range)
  int get reminderOffsetMinutes => _reminderOffsetMinutes;

  List<NotificationPayload> get notifications => List.unmodifiable(_notifications);

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void updateReminderOffset(int minutes) {
    _reminderOffsetMinutes = minutes;
    notifyListeners();
  }

  /// Schedule a notification to trigger when training session is starting
  void scheduleNotification({
    required String sport,
    required String title,
    required String body,
    required String location,
    required DateTime scheduledTime,
    int delaySeconds = 8, // Default delay for browser simulator triggers (amazing UX!)
  }) {
    if (!_notificationsEnabled) return;

    final id = 'notif_${DateTime.now().millisecondsSinceEpoch}';
    final targetTime = DateTime.now().add(Duration(seconds: delaySeconds));

    final newNotification = NotificationPayload(
      id: id,
      title: title,
      body: body,
      scheduledTime: targetTime,
      sport: sport,
      location: location,
    );

    _notifications.add(newNotification);
    notifyListeners();
  }

  /// Simulation helper: trigger immediately
  void triggerNotificationInstantly({
    required String sport,
    required String title,
    required String body,
    required String location,
  }) {
    if (!_notificationsEnabled) return;

    final id = 'notif_${DateTime.now().millisecondsSinceEpoch}';
    final newNotification = NotificationPayload(
      id: id,
      title: title,
      body: body,
      scheduledTime: DateTime.now(),
      sport: sport,
      location: location,
      isDelivered: true,
    );

    _notifications.add(newNotification);
    _triggerHUD(newNotification);
    notifyListeners();
  }

  void markAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < _notifications.length; i++) {
      _notifications[i] = _notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  void deleteNotification(String id) {
    _notifications.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearHUD() {
    _activeHUDNotification = null;
    notifyListeners();
  }

  void _triggerHUD(NotificationPayload notification) {
    _activeHUDNotification = notification;
    notifyListeners();

    // Auto-dismiss HUD after 6 seconds
    Timer(const Duration(seconds: 6), () {
      if (_activeHUDNotification?.id == notification.id) {
        _activeHUDNotification = null;
        notifyListeners();
      }
    });
  }

  void _checkScheduledAlerts(Timer timer) {
    if (!_notificationsEnabled) return;

    final now = DateTime.now();
    bool changed = false;

    for (var i = 0; i < _notifications.length; i++) {
      final notif = _notifications[i];
      if (!notif.isDelivered && now.isAfter(notif.scheduledTime)) {
        _notifications[i] = notif.copyWith(isDelivered: true);
        _triggerHUD(_notifications[i]);
        changed = true;
      }
    }

    if (changed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
