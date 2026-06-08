import 'package:flutter/material.dart';

class BookingModel {
  final String id;
  final String courtName;
  final String details;
  final String timeSlot;
  final DateTime date;
  String status; // 'Confirmed', 'Pending Approval', 'Booked'
  final bool isConfirmed;
  final String sport;
  final String? opponentName;

  BookingModel({
    required this.id,
    required this.courtName,
    required this.details,
    required this.timeSlot,
    required this.date,
    required this.status,
    required this.isConfirmed,
    required this.sport,
    this.opponentName,
  });

  BookingModel copyWith({
    String? status,
    bool? isConfirmed,
  }) {
    return BookingModel(
      id: id,
      courtName: courtName,
      details: details,
      timeSlot: timeSlot,
      date: date,
      status: status ?? this.status,
      isConfirmed: isConfirmed ?? this.isConfirmed,
      sport: sport,
      opponentName: opponentName,
    );
  }
}

class ChatMessage {
  final String role; // 'user' or 'assistant'
  final String text;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.text,
    required this.timestamp,
  });
}

class ChatChannel {
  final String uid;
  final String name;
  final String avatar;
  final String role;
  String lastMessage;
  String lastTime;
  final List<ChatMessage> messages;

  ChatChannel({
    required this.uid,
    required this.name,
    required this.avatar,
    required this.role,
    required this.lastMessage,
    required this.lastTime,
    required this.messages,
  });
}

class SystemLog {
  final String action;
  final String details;
  final String timeAgo;
  final Color tagColor;

  SystemLog({
    required this.action,
    required this.details,
    required this.timeAgo,
    required this.tagColor,
  });
}

class AppStateStore {
  // Singleton Pattern
  static final AppStateStore _instance = AppStateStore._internal();
  factory AppStateStore() => _instance;
  AppStateStore._internal();

  // Active bookings in system memory
  final List<BookingModel> bookings = [
    BookingModel(
      id: 'book_1',
      courtName: 'Indoor Court 01 (Clay Supreme)',
      details: 'Indoor • Pro Lights for clay play',
      timeSlot: 'Tomorrow • 18:00 AM',
      date: DateTime.now().add(const Duration(days: 1)),
      status: 'Confirmed',
      isConfirmed: true,
      sport: 'Tennis',
    ),
    BookingModel(
      id: 'book_2',
      courtName: 'Padel Arena 01 (Panoramic Glass)',
      details: 'Indoor • Underfloor cushion play',
      timeSlot: 'June 12 • 14:00 PM',
      date: DateTime.now().add(const Duration(days: 4)),
      status: 'Pending Approval',
      isConfirmed: false,
      sport: 'Padel',
    ),
  ];

  // Chat conversational channels matching ELO profiles
  final List<ChatChannel> chatChannels = [
    ChatChannel(
      uid: 'coach_rob',
      name: 'Coach Robert',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Robert',
      role: 'COACH',
      lastMessage: 'Ready for your spin analysis tomorrow?',
      lastTime: '10:42 AM',
      messages: [
        ChatMessage(role: 'assistant', text: 'Hi athlete, make sure to drink water and warm up.', timestamp: DateTime.now().subtract(const Duration(hours: 4))),
        ChatMessage(role: 'user', text: 'Understood Coach! I improved my shoulder posture.', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
        ChatMessage(role: 'assistant', text: 'Ready for your spin analysis tomorrow?', timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
      ],
    ),
    ChatChannel(
      uid: 'opp_nadal',
      name: 'Carlos Alcaraz',
      avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carlos',
      role: 'PLAYER',
      lastMessage: 'Awesome match! Can you booking Supreme Court 02?',
      lastTime: 'Yesterday',
      messages: [
        ChatMessage(role: 'assistant', text: 'Hey, let\'s schedule our league game.', timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 2))),
        ChatMessage(role: 'user', text: 'Sure, which court?', timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 1))),
        ChatMessage(role: 'assistant', text: 'Awesome match! Can you booking Supreme Court 02?', timestamp: DateTime.now().subtract(const Duration(days: 1))),
      ],
    ),
  ];

  // System Operations Logs (Admin telemetry auditing)
  final List<SystemLog> systemLogs = [
    SystemLog(action: 'SYSTEM_BOOT', details: 'Aether operational cores active', timeAgo: 'Just now', tagColor: Colors.purpleAccent),
    SystemLog(action: 'USER_REGISTRATION', details: 'Alex Chen initialized Baseline', timeAgo: '2 mins ago', tagColor: Colors.greenAccent),
    SystemLog(action: 'COURT_RESERVATION', details: 'Court 04 reserved by Sarah Chen', timeAgo: '12 mins ago', tagColor: Colors.blueAccent),
    SystemLog(action: 'AI_SYNAPSE_QUERY', details: 'Performance metrics mapped for Leo S.', timeAgo: '40 mins ago', tagColor: Colors.amberAccent),
  ];

  // Observers list to notify screen rebuilds
  final List<VoidCallback> _listeners = [];

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (var listener in _listeners) {
      try {
        listener();
      } catch (_) {}
    }
  }

  // SYSTEM ACTIONS
  void addBooking(BookingModel booking) {
    bookings.add(booking);
    logAction(
      'COURT_RESERVATION',
      'New booking of ${booking.courtName} registered under status: ${booking.status}.',
      Colors.blueAccent,
    );
    _notifyListeners();
  }

  void approveBooking(String bookingId) {
    final idx = bookings.indexWhere((e) => e.id == bookingId);
    if (idx != -1) {
      bookings[idx] = bookings[idx].copyWith(status: 'Confirmed', isConfirmed: true);
      logAction(
        'RESERVATION_APPROVED',
        'Reservation status for ${bookings[idx].courtName} upgraded to CONFIRMED.',
        Colors.emeraldAccent,
      );
      _notifyListeners();
    }
  }

  void rejectBooking(String bookingId) {
    final idx = bookings.indexWhere((e) => e.id == bookingId);
    if (idx != -1) {
      final name = bookings[idx].courtName;
      bookings.removeAt(idx);
      logAction(
        'RESERVATION_CANCELLED',
        'Reservation of $name was cancelled by operational director.',
        Colors.redAccent,
      );
      _notifyListeners();
    }
  }

  void addMessage(String channelUid, String senderRole, String text) {
    final channelIdx = chatChannels.indexWhere((e) => e.uid == channelUid);
    if (channelIdx != -1) {
      final channel = chatChannels[channelIdx];
      channel.messages.add(ChatMessage(role: senderRole, text: text, timestamp: DateTime.now()));
      channel.lastMessage = text;
      channel.lastTime = 'Now';
      _notifyListeners();
    }
  }

  void logAction(String action, String details, Color tagColor) {
    systemLogs.insert(
      0,
      SystemLog(action: action, details: details, timeAgo: '1s ago', tagColor: tagColor),
    );
    _notifyListeners();
  }
}
