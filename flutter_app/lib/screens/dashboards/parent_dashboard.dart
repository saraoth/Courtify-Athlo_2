import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';

class ParentDashboard extends StatelessWidget {
  final UserProfile profile;

  const ParentDashboard({Key? key, required this.profile}) : super(key: key);

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ATHLO PARENT CENTER',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.indigoAccent, letterSpacing: 2),
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
                    backgroundImage: NetworkImage(profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=parent'),
                  )
                ],
              ),
              const SizedBox(height: 32),

              Text(
                'Linked Student Profiles',
                style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              
              _studentCard('Sarah J. Rivera', 'Class: Advanced Tennis (Level A)', 'Coach: Sarah Othman', 'Active Matchmaking', '0.94'),
              _studentCard('Leo S. Rivera', 'Class: Basketball Training (Level C)', 'Coach: Michael Rivera', 'Resting', '0.78'),
              
              const SizedBox(height: 32),
              Text(
                'System Sync Status',
                style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sync_lock_rounded, color: Colors.greenAccent),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Real-time synchronization secure', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Text('Linked accounts are validated by administrative protocols.', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11)),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _studentCard(String name, String details, String coach, String state, String scale) {
    return Card(
      color: Colors.white.withOpacity(0.01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: const BorderSide(color: Colors.white10)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white10,
                  backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=$name'),
                  radius: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(details, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                      Text(coach, style: const TextStyle(color: Color(0xFF2F80ED), fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    state.toUpperCase(),
                    style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'Progress Score: ${(double.parse(scale) * 100).toInt()}%',
                      style: GoogleFonts.spaceGrotesk(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
