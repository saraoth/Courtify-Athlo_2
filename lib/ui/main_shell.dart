import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';
import '../screens/dashboards/player_dashboard.dart';
import '../screens/dashboards/coach_dashboard.dart';
import '../screens/dashboards/parent_dashboard.dart';
import '../screens/dashboards/admin_dashboard.dart';
import '../screens/features/booking_screen.dart';
import '../screens/features/ai_insights.dart';
import '../screens/features/chat_screen.dart';
import '../screens/features/live_coach_screen.dart';
import '../screens/features/video_generator_screen.dart';
import '../screens/features/profile_screen.dart';
import 'notification_hud_overlay.dart';

class ShellTab {
  final Widget widget;
  final String title;
  final IconData icon;
  final IconData activeIcon;

  const ShellTab({
    required this.widget,
    required this.title,
    required this.icon,
    required this.activeIcon,
  });
}

class MainShell extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onLogout;
  final Function(UserProfile) onProfileUpdate;

  const MainShell({
    Key? key,
    required this.profile,
    required this.onLogout,
    required this.onProfileUpdate,
  }) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  late UserProfile _currentProfile;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _profileSubscription;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.profile;
    _initializeFirebaseListener();
  }

  void _initializeFirebaseListener() {
    try {
      _profileSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.profile.uid)
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final retrievedProfile = UserProfile.fromMap(snapshot.data()!);
          if (mounted) {
            setState(() {
              _currentProfile = retrievedProfile;
            });
            // Propagate retrieved change back to parent store state seamlessly
            widget.onProfileUpdate(retrievedProfile);
          }
        } else {
          // Document does not exist in Firestore yet (e.g. newly registered). Seed it to Firebase!
          _seedProfileToFirebase(widget.profile);
        }
      }, onError: (err) {
        debugPrint('Firestore real-time listener error: $err');
      });
    } catch (e) {
      debugPrint('Firestore initialization caught in fallback: $e');
    }
  }

  Future<void> _seedProfileToFirebase(UserProfile profile) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(profile.uid)
          .set(profile.toMap());
    } catch (e) {
      debugPrint('Error seeding user profile to Firestore: $e');
    }
  }

  @override
  void didUpdateWidget(covariant MainShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.uid != widget.profile.uid) {
      _profileSubscription?.cancel();
      _currentProfile = widget.profile;
      _initializeFirebaseListener();
    } else if (oldWidget.profile != widget.profile) {
      setState(() {
        _currentProfile = widget.profile;
      });
    }
  }

  @override
  void dispose() {
    _profileSubscription?.cancel();
    super.dispose();
  }

  // Build profile tab view within the main shell
  Widget _buildProfileTab() {
    return ProfileScreen(
      profile: _currentProfile,
      onProfileUpdate: (updatedProfile) async {
        // Intercept profile update to save in Firebase Firestore
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(updatedProfile.uid)
              .set(updatedProfile.toMap());
        } catch (e) {
          debugPrint('Error updating user profile in Firestore: $e');
        }
        widget.onProfileUpdate(updatedProfile);
      },
      onLogout: widget.onLogout,
    );
  }

  // Get pages dynamically based on active profile configured role
  List<ShellTab> _getTabsForRole() {
    switch (_currentProfile.role) {
      case UserRole.coach:
        return [
          ShellTab(
            widget: CoachDashboard(profile: _currentProfile),
            title: 'Dashboard',
            icon: Icons.grid_view_rounded,
            activeIcon: Icons.grid_view_sharp,
          ),
          ShellTab(
            widget: BookingScreen(profile: _currentProfile),
            title: 'Planner',
            icon: Icons.calendar_today_rounded,
            activeIcon: Icons.calendar_today_sharp,
          ),
          ShellTab(
            widget: const LiveCoachScreen(),
            title: 'AI Broadcast',
            icon: Icons.mic_rounded,
            activeIcon: Icons.mic_sharp,
          ),
          ShellTab(
            widget: ChatScreen(profile: _currentProfile),
            title: 'Encrypted Feed',
            icon: Icons.forum_rounded,
            activeIcon: Icons.forum_sharp,
          ),
          ShellTab(
            widget: const VideoGeneratorScreen(),
            title: 'AI Lab',
            icon: Icons.video_library_rounded,
            activeIcon: Icons.video_library_sharp,
          ),
          ShellTab(
            widget: _buildProfileTab(),
            title: 'My Profile',
            icon: Icons.person_rounded,
            activeIcon: Icons.person_sharp,
          ),
        ];

      case UserRole.parent:
        return [
          ShellTab(
            widget: ParentDashboard(profile: _currentProfile),
            title: 'Family',
            icon: Icons.family_restroom_rounded,
            activeIcon: Icons.family_restroom_sharp,
          ),
          ShellTab(
            widget: BookingScreen(profile: _currentProfile),
            title: 'Bookings',
            icon: Icons.calendar_today_rounded,
            activeIcon: Icons.calendar_today_sharp,
          ),
          ShellTab(
            widget: ChatScreen(profile: _currentProfile),
            title: 'Secure Chat',
            icon: Icons.forum_rounded,
            activeIcon: Icons.forum_sharp,
          ),
          ShellTab(
            widget: _buildProfileTab(),
            title: 'Profile',
            icon: Icons.person_rounded,
            activeIcon: Icons.person_sharp,
          ),
        ];

      case UserRole.admin:
        return [
          ShellTab(
            widget: AdminDashboard(profile: _currentProfile),
            title: 'Director Desk',
            icon: Icons.admin_panel_settings_rounded,
            activeIcon: Icons.admin_panel_settings_sharp,
          ),
          ShellTab(
            widget: BookingScreen(profile: _currentProfile),
            title: 'Global Calendar',
            icon: Icons.calendar_today_rounded,
            activeIcon: Icons.calendar_today_sharp,
          ),
          ShellTab(
            widget: ChatScreen(profile: _currentProfile),
            title: 'Auditing Log',
            icon: Icons.assignment_rounded,
            activeIcon: Icons.assignment_sharp,
          ),
          ShellTab(
            widget: _buildProfileTab(),
            title: 'System Config',
            icon: Icons.settings_suggest_rounded,
            activeIcon: Icons.settings_suggest_sharp,
          ),
        ];

      case UserRole.player:
      default:
        return [
          ShellTab(
            widget: PlayerDashboard(profile: _currentProfile),
            title: 'Lounge',
            icon: Icons.grid_view_rounded,
            activeIcon: Icons.grid_view_sharp,
          ),
          ShellTab(
            widget: BookingScreen(profile: _currentProfile),
            title: 'Reservations',
            icon: Icons.calendar_today_rounded,
            activeIcon: Icons.calendar_today_sharp,
          ),
          ShellTab(
            widget: AIInsights(profile: _currentProfile),
            title: 'AI Coach',
            icon: Icons.psychology_rounded,
            activeIcon: Icons.psychology_sharp,
          ),
          ShellTab(
            widget: const LiveCoachScreen(),
            title: 'Voice Coach',
            icon: Icons.mic_rounded,
            activeIcon: Icons.mic_sharp,
          ),
          ShellTab(
            widget: ChatScreen(profile: _currentProfile),
            title: 'Team Feed',
            icon: Icons.forum_rounded,
            activeIcon: Icons.forum_sharp,
          ),
          ShellTab(
            widget: _buildProfileTab(),
            title: 'Telemetry ID',
            icon: Icons.person_rounded,
            activeIcon: Icons.person_sharp,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _getTabsForRole();

    // Prevent index out of bounds on role selection switches
    if (_currentIndex >= tabs.length) {
      _currentIndex = 0;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final navBg = isDark ? const Color(0xFF0B0F19) : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.black.withOpacity(0.08);
    final unselectedColor = isDark ? Colors.white30 : Colors.black38;
    final unselectedLabelColor = isDark ? Colors.white45 : Colors.black54;
    final logoLabelColor = isDark ? Colors.white70 : const Color(0xFF0F172A);

    return NotificationHUDOverlay(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 768;

          if (isWide) {
            // Responsive Navigation Rail View for Tablet/Desktop Workspace Spec
            return Scaffold(
              backgroundColor: scaffoldBg,
              body: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(color: borderColor, width: 1),
                      ),
                    ),
                    child: NavigationRail(
                      selectedIndex: _currentIndex,
                      backgroundColor: navBg,
                      extended: constraints.maxWidth >= 960,
                      minWidth: 72,
                      minExtendedWidth: 190,
                      selectedIconTheme: const IconThemeData(color: Color(0xFF2F80ED), size: 24),
                      unselectedIconTheme: IconThemeData(color: unselectedColor, size: 24),
                      selectedLabelTextStyle: GoogleFonts.spaceGrotesk(
                        color: const Color(0xFF2F80ED),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      unselectedLabelTextStyle: GoogleFonts.spaceGrotesk(
                        color: unselectedLabelColor,
                        fontWeight: FontWeight.medium,
                        fontSize: 12,
                      ),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.bolt_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                            if (constraints.maxWidth >= 960) ...[
                              const SizedBox(height: 12),
                              Text(
                                'ATHLO COURTIFY',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.black,
                                  color: logoLabelColor,
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                      onDestinationSelected: (value) {
                        setState(() {
                          _currentIndex = value;
                        });
                      },
                      destinations: tabs.map((tab) {
                        return NavigationRailDestination(
                          icon: Icon(tab.icon),
                          selectedIcon: Icon(tab.activeIcon),
                          label: Text(tab.title),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: tabs.map((t) => t.widget).toList(),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Responsive Mobile Bottom Navigation Layout Spec
            return Scaffold(
              backgroundColor: scaffoldBg,
              body: IndexedStack(
                index: _currentIndex,
                children: tabs.map((t) => t.widget).toList(),
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: navBg,
                selectedItemColor: const Color(0xFF2F80ED),
                unselectedItemColor: unselectedColor,
                selectedLabelStyle: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.medium,
                ),
                items: tabs.map((tab) {
                  return BottomNavigationBarItem(
                    icon: Icon(tab.icon, size: 20),
                    activeIcon: Icon(tab.activeIcon, size: 22),
                    label: tab.title,
                  );
                }).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}
