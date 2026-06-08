import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';

class PlayerDashboard extends StatelessWidget {
  final UserProfile profile;

  const PlayerDashboard({Key? key, required this.profile}) : super(key: key);

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
              // Welcome row
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WELCOME BACK ATHLETE',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF2F80ED), letterSpacing: 2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.name,
                        style: GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.black, color: Colors.white),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white24,
                    backgroundImage: NetworkImage(profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=placeholder'),
                  )
                ],
              ),
              const SizedBox(height: 24),

              // Overview stats row
              Row(
                children: [
                  _statCard('Proficiency', profile.skillLevel?.toUpperCase() ?? 'BEGINNER', const Color(0xFF10B981), Icons.analytics_rounded),
                  const SizedBox(width: 12),
                  _statCard('Sessions', '12 / Week', const Color(0xFFF2994A), Icons.directions_run_rounded),
                ],
              ),
              const SizedBox(height: 24),

              // AI Coach Quote Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF2F80ED).withOpacity(0.1), Colors.indigo.withOpacity(0.2)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFF2F80ED).withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology_rounded, color: Color(0xFF2F80ED), size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'ATHLO AI COACH',
                          style: GoogleFonts.inter(fontWeight: FontWeight.black, fontSize: 11, color: Colors.white70, letterSpacing: 1.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"Your court movement metrics show a significant upgrade. Work on your follow-through in your forehand drive during your next reservation."',
                      style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withOpacity(0.85), fontStyle: FontStyle.italic, height: 1.5),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // List of Upcoming bookings
              _headerRow('Upcoming Resourses', 'See All'),
              const SizedBox(height: 12),
              _bookingCard('Indoor Court 04', 'Tennis Practice Match', 'Tomorrow • 18:00 AM', 'Confirmed', true),
              _bookingCard('Padel Arena 01', 'Tactical Training Workshop', 'June 12 • 14:00 PM', 'Pending Approval', false),

              const SizedBox(height: 28),
              // Partner Find Matches
              _headerRow('Interactive Discovery', 'Search Map'),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _partnerCard('Alex Chen', 'Advanced', 'Tennis', '🎾'),
                    _partnerCard('Michael Jordan', 'Pro', 'Basketball', '🏀'),
                    _partnerCard('Sania Mirza', 'Intermediate', 'Padel', '🏸'),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(24),
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

  Widget _headerRow(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.between,
      children: [
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            actionText,
            style: const TextStyle(color: Color(0xFF2F80ED), fontSize: 12, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget _bookingCard(String title, String subtitle, String time, String status, bool confirmed) {
    return Card(
      color: Colors.white.withOpacity(0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Colors.white10),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (confirmed ? Colors.green : Colors.amber).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.schedule_rounded, color: confirmed ? Colors.green : Colors.amber),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.white60)),
                  const SizedBox(height: 8),
                  Text(time, style: GoogleFonts.spaceGrotesk(color: const Color(0xFF2F80ED), fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (confirmed ? Colors.green : Colors.amber).withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(color: confirmed ? Colors.greenAccent : Colors.amberAccent, fontSize: 9, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _partnerCard(String name, String level, String sport, String emo) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white10,
            backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=$name'),
            radius: 24,
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.white)),
          const SizedBox(height: 4),
          Text('$emo $sport', style: const TextStyle(fontSize: 10, color: Colors.white54)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              level.toUpperCase(),
              style: GoogleFonts.spaceGrotesk(fontSize: 8, fontWeight: FontWeight.black, color: Colors.white70),
            ),
          )
        ],
      ),
    );
  }
}
