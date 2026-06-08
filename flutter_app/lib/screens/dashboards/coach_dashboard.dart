import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';

class CoachDashboard extends StatelessWidget {
  final UserProfile profile;

  const CoachDashboard({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ELITE COACH PANEL',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFFE11D48), letterSpacing: 2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Coach ${profile.name}',
                        style: GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.black, color: Colors.white),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=coach'),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // Metrics Row
              Row(
                children: [
                  _metricCard('Coaching Roster', '18 Players', Colors.blue, Icons.sports_tennis_rounded),
                  const SizedBox(width: 12),
                  _metricCard('Classes Today', '4 Scheduled', Colors.purple, Icons.calendar_month_rounded),
                ],
              ),
              const SizedBox(height: 24),

              // Active Alert
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'A student requested deep visual ball-spin reports and analysis.',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Player Roster
              Text(
                'High Performance Roster',
                style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              _rosterListItem('Sarah Chen', 'Tennis • Level A', 'Last seen yesterday', '92% Progress'),
              _rosterListItem('Michael Rivera', 'Basketball • Level B', 'Scheduled for 18:00', '84% Progress'),
              _rosterListItem('David Vance', 'Padel • Level C', 'Completed diagnostic', '71% Progress'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 16),
            Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _rosterListItem(String name, String details, String status, String progress) {
    return Card(
      color: Colors.white.withOpacity(0.01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white10,
          backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=$name'),
        ),
        title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(details, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            const SizedBox(height: 4),
            Text(status, style: const TextStyle(color: Color(0xFF2F80ED), fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        trailing: Chip(
          label: Text(progress),
          backgroundColor: Colors.white10,
          labelStyle: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
