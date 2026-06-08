import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';
import 'dashboards/player_dashboard.dart';
import 'dashboards/coach_dashboard.dart';
import 'dashboards/parent_dashboard.dart';
import 'dashboards/admin_dashboard.dart';
import 'features/booking_screen.dart';
import 'features/ai_insights.dart';
import 'features/chat_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserProfile profile;
  final VoidCallback onLogout;

  const DashboardScreen({Key? key, required this.profile, required this.onLogout}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  Widget _getCurrentHome() {
    switch (widget.profile.role) {
      case UserRole.coach:
        return CoachDashboard(profile: widget.profile);
      case UserRole.parent:
        return ParentDashboard(profile: widget.profile);
      case UserRole.admin:
        return AdminDashboard(profile: widget.profile);
      case UserRole.player:
      default:
        return PlayerDashboard(profile: widget.profile);
    }
  }

  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      _getCurrentHome(),
      BookingScreen(profile: widget.profile),
      const AIInsights(),
      ChatScreen(profile: widget.profile),
      _buildProfileTab(),
    ];
  }

  Widget _buildMockChat() {
    return Container(
      color: const Color(0xFF0F172A),
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.forum_rounded, size: 60, color: Color(0xFF2F80ED)),
            const SizedBox(height: 16),
            Text(
              'Secure Chat Engine',
              style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Real-time encrypted connection to your coaches and team members.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F80ED)),
              child: const Text('Open Contacts'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return Container(
      color: const Color(0xFF0F172A),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF2F80ED).withOpacity(0.2),
                  backgroundImage: NetworkImage(
                    widget.profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=${widget.profile.name}',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.profile.name,
                  style: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.black, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.profile.email,
                  style: const TextStyle(color: Colors.white54),
                ),
                const SizedBox(height: 12),
                Chip(
                  label: Text(widget.profile.role.toString().split('.').last.toUpperCase()),
                  backgroundColor: const Color(0xFF2F80ED).withOpacity(0.2),
                  labelStyle: const TextStyle(color: Color(0xFF2F80ED), fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          _profileOption(Icons.sports_rounded, 'My Specialization', widget.profile.sports?.first.toUpperCase() ?? 'NONE'),
          _profileOption(Icons.insights_rounded, 'My Skill Level', widget.profile.skillLevel?.toUpperCase() ?? 'NONE'),
          _profileOption(Icons.notifications_active_rounded, 'Push Notifications', 'ENABLED'),
          _profileOption(Icons.security_rounded, 'System Security', 'PRO CERTIFIED'),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: widget.onLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.withOpacity(0.2),
              foregroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              elevation: 0,
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log Out From System', style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _profileOption(IconData icon, String title, String value) {
    return Card(
      color: Colors.white.withOpacity(0.02),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.white60),
            const SizedBox(width: 16),
            Text(title, style: const TextStyle(color: Colors.white70)),
            const Spacer(),
            Text(value, style: GoogleFonts.spaceGrotesk(color: const Color(0xFF2F80ED), fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0F172A),
        selectedItemColor: const Color(0xFF2F80ED),
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'AI Coach'),
          BottomNavigationBarItem(icon: Icon(Icons.forum_rounded), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
