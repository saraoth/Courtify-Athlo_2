import 'dart:convert';

enum UserRole { player, coach, parent, admin }

class UserProfile {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final String? avatar;
  final String? parentId;
  final List<String>? sports;
  final String? skillLevel;
  final String? availability;
  final String? fcmToken;
  final bool onboardingCompleted;

  UserProfile({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    this.avatar,
    this.parentId,
    this.sports,
    this.skillLevel,
    this.availability,
    this.fcmToken,
    required this.onboardingCompleted,
  });

  UserProfile copyWith({
    String? uid,
    String? email,
    String? name,
    UserRole? role,
    String? avatar,
    String? parentId,
    List<String>? sports,
    String? skillLevel,
    String? availability,
    String? fcmToken,
    bool? onboardingCompleted,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      parentId: parentId ?? this.parentId,
      sports: sports ?? this.sports,
      skillLevel: skillLevel ?? this.skillLevel,
      availability: availability ?? this.availability,
      fcmToken: fcmToken ?? this.fcmToken,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'avatar': avatar,
      'parentId': parentId,
      'sports': sports,
      'skillLevel': skillLevel,
      'availability': availability,
      'fcmToken': fcmToken,
      'onboardingCompleted': onboardingCompleted,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    UserRole parsedRole = UserRole.player;
    final roleString = map['role'] ?? 'player';
    for (var r in UserRole.values) {
      if (r.toString().split('.').last == roleString) {
        parsedRole = r;
        break;
      }
    }

    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: parsedRole,
      avatar: map['avatar'],
      parentId: map['parentId'],
      sports: map['sports'] != null ? List<String>.from(map['sports']) : null,
      skillLevel: map['skillLevel'],
      availability: map['availability'],
      fcmToken: map['fcmToken'],
      onboardingCompleted: map['onboardingCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserProfile.fromJson(String source) => UserProfile.fromMap(json.decode(source));
}
