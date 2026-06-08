import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';
import '../../models/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoachDashboard extends StatefulWidget {
  final UserProfile profile;

  const CoachDashboard({Key? key, required this.profile}) : super(key: key);

  @override
  State<CoachDashboard> createState() => _CoachDashboardState();
}

class _CoachDashboardState extends State<CoachDashboard> {
  final AppStateStore _stateStore = AppStateStore();
  bool _showFeedbackTab = false;

  @override
  void initState() {
    super.initState();
    _stateStore.addListener(_onStateUpdate);
  }

  @override
  void dispose() {
    _stateStore.removeListener(_onStateUpdate);
    super.dispose();
  }

  void _onStateUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _reviewDiagnosticRequest(String studentName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFFE11D48),
        content: Text(
          'Processing spin trajectory dataset for $studentName in Gemini Live Sandbox.',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dynamically calculate the active, high performance bookings
    final coachBookingsCount = _stateStore.bookings.length;

    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 40),
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
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFE11D48),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'LICENSED INSTRUCTOR',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE11D48),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Coach ${widget.profile.name}',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 28,
                          fontWeight: FontWeight.black,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: const Color(0xFFE11D48).withOpacity(0.1),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        widget.profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=coach',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 28),

              // Metrics Row
              Row(
                children: [
                  _metricCard(
                    'Coaching Roster',
                    '18 Active Athletes',
                    Colors.blueAccent,
                    Icons.sports_tennis_rounded,
                    'Telemetry Sync',
                  ),
                  const SizedBox(width: 12),
                  _metricCard(
                    'Classes Today',
                    '$coachBookingsCount Active Slots',
                    Colors.purpleAccent,
                    Icons.calendar_month_rounded,
                    'Court Bookings',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Active Alert
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.redAccent.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SPIN REPORT REQUEST',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Sarah Chen requested high-speed camera ball-spin telemetry and diagnostic calibrations.',
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.white70, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      icon: const Icon(Icons.arrow_circle_right_rounded, color: Colors.redAccent, size: 28),
                      onPressed: () => _reviewDiagnosticRequest('Sarah Chen'),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Segmented Switcher for Roster vs Feedback Stream Hub
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFeedbackTab = false;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_showFeedbackTab 
                              ? const Color(0xFFE11D48).withOpacity(0.12)
                              : Colors.white.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: !_showFeedbackTab ? const Color(0xFFE11D48) : Colors.white.withOpacity(0.05),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'ATHLETE ROSTER',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.black,
                            color: !_showFeedbackTab ? const Color(0xFFE11D48) : Colors.white60,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFeedbackTab = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _showFeedbackTab 
                              ? const Color(0xFF10B981).withOpacity(0.12)
                              : Colors.white.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _showFeedbackTab ? const Color(0xFF10B981) : Colors.white.withOpacity(0.05),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'SESSION FEEDBACKS',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.black,
                            color: _showFeedbackTab ? const Color(0xFF10B981) : Colors.white60,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              if (!_showFeedbackTab) ...[
                // Player Roster List
                Row(
                  mainAxisAlignment: MainAxisAlignment.between,
                  children: [
                    Text(
                      'High Performance Roster',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.black,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'REAL-TIME SYNC',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white30),
                    )
                  ],
                ),
                const SizedBox(height: 14),
                _rosterListItem('Sarah Chen', 'Tennis • Level A (Advanced)', 'Last diagnostic: Yesterday', '92% Progress'),
                _rosterListItem('Alex Rivera', 'Basketball • Level B (Intermediate)', 'Scheduled for 18:00', '84% Progress'),
                _rosterListItem('Michael Rivera', 'Padel • Level C (Beginner)', 'Completed initial baseline', '71% Progress'),
              ] else ...[
                _buildCoachFeedbackHub(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricCard(String label, String value, Color color, IconData icon, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.015),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Icon(icon, color: color, size: 24),
                Text(
                  subtitle.toUpperCase(),
                  style: const TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(label, style: const TextStyle(color: Colors.white45, fontSize: 11)),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 15,
                fontWeight: FontWeight.black,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _rosterListItem(String name, String details, String status, String progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.01),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white10,
              backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=$name'),
              radius: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    details,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: const TextStyle(color: Color(0xFF2F80ED), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                progress,
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoachFeedbackHub() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Text(
              'Real-Time Athlete Reviews',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.black,
                color: Colors.white,
              ),
            ),
            const Text(
              'LIVE FEED',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white30),
            )
          ],
        ),
        const SizedBox(height: 14),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('session_feedback')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Failed to load feedback stream: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent));
            }
            if (!snapshot.hasData) {
              return const Center(child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(color: Color(0xFF10B981)),
              ));
            }
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.01),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.rate_review_rounded, color: Colors.white45, size: 32),
                    const SizedBox(height: 12),
                    Text(
                      'No athlete feedback received yet',
                      style: GoogleFonts.spaceGrotesk(color: Colors.white54, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'When players rate their completed training sessions, reviews will register live here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white30, fontSize: 11),
                    ),
                  ],
                ),
              );
            }

            final sortedDocs = List<QueryDocumentSnapshot>.from(docs);
            sortedDocs.sort((a, b) {
              final aMap = a.data() as Map<String, dynamic>;
              final bMap = b.data() as Map<String, dynamic>;
              final aTime = aMap['createdAt'] as String? ?? '';
              final bTime = bMap['createdAt'] as String? ?? '';
              return bTime.compareTo(aTime);
            });

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedDocs.length,
              itemBuilder: (context, index) {
                final doc = sortedDocs[index];
                final data = doc.data() as Map<String, dynamic>;
                final rating = (data['rating'] ?? 5.0) as double;
                final comments = data['comments'] ?? '';
                final playerName = data['playerName'] ?? 'Anonymous Athlete';
                final playerAvatar = data['playerAvatar'] ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=athlete';
                final exertion = data['exertion'] ?? 'Unknown Exertion';
                final isAck = data['acknowledged'] ?? false;
                final sport = data['sport'] ?? 'Tennis';
                final List<dynamic> focusTags = data['technicalFocus'] ?? [];
                final courtName = data['courtName'] ?? 'General Arena';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.012),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isAck ? Colors.white.withOpacity(0.04) : const Color(0xFF10B981).withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white10,
                            backgroundImage: NetworkImage(playerAvatar),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  playerName,
                                  style: GoogleFonts.spaceGrotesk(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$sport • $courtName',
                                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          
                          Row(
                            children: List.generate(5, (sIdx) {
                              return Icon(
                                sIdx < rating ? Icons.star_rounded : Icons.star_outline_rounded,
                                color: sIdx < rating ? const Color(0xFFF2C94C) : Colors.white12,
                                size: 14,
                              );
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '"$comments"',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      if (focusTags.isNotEmpty) ...[
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: focusTags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2F80ED).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFF2F80ED).withOpacity(0.15)),
                              ),
                              child: Text(
                                tag.toString(),
                                style: const TextStyle(fontSize: 8.5, color: Color(0xFF2F80ED), fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 10),
                      ],
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.flash_on_rounded, size: 10, color: Color(0xFF10B981)),
                              const SizedBox(width: 4),
                              Text(
                                exertion,
                                style: GoogleFonts.spaceGrotesk(
                                  color: const Color(0xFF10B981),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          
                          if (!isAck) ...[
                            ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  await doc.reference.update({'acknowledged': true});
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Could not sync acknowledgement: $e')),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981).withOpacity(0.15),
                                foregroundColor: const Color(0xFF10B981),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: Size.zero,
                              ),
                              icon: const Icon(Icons.check_circle_rounded, size: 10, color: Color(0xFF10B981)),
                              label: Text(
                                'ACKNOWLEDGE',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.black,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.done_all_rounded, color: Colors.white30, size: 11),
                                  const SizedBox(width: 4),
                                  Text(
                                    'ACKNOWLEDGED',
                                    style: GoogleFonts.spaceGrotesk(
                                      color: Colors.white30,
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
