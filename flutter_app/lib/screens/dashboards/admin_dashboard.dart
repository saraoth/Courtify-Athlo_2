import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';

class AdminDashboard extends StatelessWidget {
  final UserProfile profile;

  const AdminDashboard({Key? key, required this.profile}) : super(key: key);

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
                        'ADMIN PROTOCOL OPERATIONS',
                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orangeAccent, letterSpacing: 2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Admin ${profile.name}',
                        style: GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.black, color: Colors.white),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin'),
                  )
                ],
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  _statCard('Total Bookings', '482 Reservs', Colors.green, Icons.calendar_month_rounded),
                  const SizedBox(width: 12),
                  _statCard('Total Users', '2,482 Active', Colors.lightBlue, Icons.people_rounded),
                ],
              ),
              const SizedBox(height: 24),

              Text(
                'Recent Operations Manifest',
                style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),
              _opLogItem('USER_REGISTRATION', 'Alex Chen initialized Baseline', '2 mins ago', Colors.greenAccent),
              _opLogItem('COURT_RESERVATION', 'Court 04 reserved by Sarah Chen', '12 mins ago', Colors.blueAccent),
              _opLogItem('AI_SYNAPSE_QUERY', 'Performance metrics mapped for Leo S.', '40 mins ago', Colors.purpleAccent),

              const SizedBox(height: 32),
              // Controls panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Global System Actions',
                      style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text('Warning: These actions cascade immediately to all active sockets.', style: TextStyle(color: Colors.white54, fontSize: 11)),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: const Text('Maintenance Mode', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: const Text('Flush Session Sockets', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
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

  Widget _statCard(String label, String value, Color color, IconData icon) {
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

  Widget _opLogItem(String action, String details, String time, Color tagColor) {
    return Card(
      color: Colors.white.withOpacity(0.01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.white10)),
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: tagColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Text(action, style: TextStyle(color: tagColor, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(details, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ),
            Text(time, style: const TextStyle(color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
