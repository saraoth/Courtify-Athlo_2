import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';
import '../../models/app_state.dart';
import '../../models/notification_service.dart';
import '../../screens/features/feedback_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlayerDashboard extends StatefulWidget {
  final UserProfile profile;

  const PlayerDashboard({Key? key, required this.profile}) : super(key: key);

  @override
  State<PlayerDashboard> createState() => _PlayerDashboardState();
}

class _PlayerDashboardState extends State<PlayerDashboard> {
  final AppStateStore _stateStore = AppStateStore();
  final LocalNotificationService _notifService = LocalNotificationService();

  @override
  void initState() {
    super.initState();
    _stateStore.addListener(_onStateUpdate);
    _notifService.addListener(_onStateUpdate);
  }

  @override
  void dispose() {
    _stateStore.removeListener(_onStateUpdate);
    _notifService.removeListener(_onStateUpdate);
    super.dispose();
  }

  void _onStateUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  void _challengeOpponent(String opponentName, String sport) {
    final newBooking = BookingModel(
      id: 'book_${DateTime.now().millisecondsSinceEpoch}',
      courtName: 'Challenger Arena (Premium Play)',
      details: '$sport Match Play with $opponentName',
      timeSlot: 'Scheduled Tomorrow • 19:00 PM',
      date: DateTime.now().add(const Duration(days: 1)),
      status: 'Pending Approval',
      isConfirmed: false,
      sport: sport,
      opponentName: opponentName,
    );
    _stateStore.addBooking(newBooking);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2F80ED),
        content: Text(
          'Challenge Issued! $opponentName was invited to a $sport duel.',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Current user configured details
    final favoriteSport = widget.profile.sports?.isNotEmpty == true ? widget.profile.sports!.first : 'Tennis';
    final userSkill = widget.profile.skillLevel ?? 'beginner';

    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header Row
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
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'ONLINE BASELINE LAB',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2F80ED),
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.profile.name,
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
                    backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        widget.profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=${widget.profile.name}',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 28),

              // Tactical summary details bento-style
              Row(
                children: [
                  _statCard(
                    'My Discipline',
                    favoriteSport.toUpperCase(),
                    const Color(0xFF10B981),
                    Icons.sports_tennis_rounded,
                    'Specialization',
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    'Neural Baseline',
                    userSkill.toUpperCase(),
                    const Color(0xFF2F80ED),
                    Icons.psychology_rounded,
                    'AI Skill Index',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // AI Coach Active Insights Quote
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2F80ED).withOpacity(0.08),
                      const Color(0xFF4F46E5).withOpacity(0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF2F80ED).withOpacity(0.25),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Color(0xFF2F80ED), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'ATHLO AI COACH DIAGNOSTIC',
                          style: GoogleFonts.spaceGrotesk(
                            fontWeight: FontWeight.w900,
                            fontSize: 11,
                            color: const Color(0xFF2F80ED),
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '"Hello ${widget.profile.name}! Based on your designated $userSkill profile, I structured custom $favoriteSport biomechanics modules. Schedule any prime court slot below to sync physical sensors with the AI Core."',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // List of dynamic active bookings
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Text(
                    'My Scheduled Sessions',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 20,
                      fontWeight: FontWeight.black,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, py: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_stateStore.bookings.length} TOTAL',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white60,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 14),

              if (_stateStore.bookings.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.calendar_today_rounded, color: Colors.white24, size: 32),
                      const SizedBox(height: 12),
                      Text(
                        'No upcoming reservations',
                        style: GoogleFonts.spaceGrotesk(color: Colors.white54, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Use the Reservations tab to secure a court.',
                        style: TextStyle(color: Colors.white30, fontSize: 11),
                      ),
                    ],
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _stateStore.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = _stateStore.bookings[index];
                    return _bookingListItem(booking);
                  },
                ),

              const SizedBox(height: 32),

              // SUBMIT FEEDBACK CTA CARD
              _buildFeedbackCTACard(),
              const SizedBox(height: 32),

              // MY HISTORICAL FEEDBACK SUBMISSIONS
              _buildMyFeedbackHistoryList(),
              const SizedBox(height: 32),

              // Matchmaking Board
              Text(
                'High Performance Opponents',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 20,
                  fontWeight: FontWeight.black,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Engage local players calibrated directly to your ELO level.',
                style: TextStyle(color: Colors.white45, fontSize: 12),
              ),
              const SizedBox(height: 14),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _opponentMatchCard('Dennis Shapovalov', '🎾 Tennis', 'ELO 1940', 'PRO', 'tennis'),
                    _opponentMatchCard('Michael Rivera', '🏀 Basketball', 'ELO 1820', 'HIGH COMP', 'basketball'),
                    _opponentMatchCard('Sania Penza', '🏸 Padel', 'ELO 1710', 'INTERMED', 'padel'),
                    _opponentMatchCard('Sarah O\'Connell', '🎾 Tennis', 'ELO 1690', 'INTERMED', 'tennis'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildNotificationControlDeck(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationControlDeck() {
    final enabled = _notifService.notificationsEnabled;
    final logCount = _notifService.notifications.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Text(
              'Training Reminders Hub',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.black,
                color: Colors.white,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: enabled ? Colors.green.withOpacity(0.12) : Colors.red.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                enabled ? 'SYNC LIVE' : 'SYNC MUTED',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.black,
                  color: enabled ? Colors.greenAccent : Colors.redAccent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Manage your upcoming physical court calibration and coaching warnings.',
          style: TextStyle(color: Colors.white45, fontSize: 12),
        ),
        const SizedBox(height: 18),

        // Settings Box
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.012),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Column(
            children: [
              // Delivery Switch Option
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Row(
                    children: [
                      Icon(
                        enabled ? Icons.notifications_active_rounded : Icons.notifications_off_rounded,
                        color: enabled ? const Color(0xFF2F80ED) : Colors.white30,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Local Broadcast Sync',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const Text(
                            'Receive reminders on system workspace',
                            style: TextStyle(color: Colors.white30, fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Switch(
                    value: enabled,
                    onChanged: (val) {
                      _notifService.toggleNotifications(val);
                    },
                    activeColor: const Color(0xFF2F80ED),
                    activeTrackColor: const Color(0xFF2F80ED).withOpacity(0.3),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Divider(color: Colors.white15, height: 1),
              ),

              // Advance warning slider configuration
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Text(
                        'Calibrate Warmup Lead Time',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${_notifService.reminderOffsetMinutes} Mins Before',
                        style: GoogleFonts.spaceGrotesk(
                          color: const Color(0xFF2F80ED),
                          fontWeight: FontWeight.black,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF2F80ED),
                      inactiveTrackColor: Colors.white10,
                      thumbColor: Colors.white,
                      overlayColor: const Color(0xFF2F80ED).withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _notifService.reminderOffsetMinutes.toDouble(),
                      min: 5,
                      max: 45,
                      divisions: 8,
                      onChanged: enabled
                          ? (value) {
                              _notifService.updateReminderOffset(value.toInt());
                            }
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Instant Simulation Suite
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: enabled
                          ? () {
                              _notifService.triggerNotificationInstantly(
                                sport: 'Tennis',
                                title: '🎾 Upcoming Tennis Session Alert',
                                body: 'Your reserved Clay Supreme Court session slot is starting in ${_notifService.reminderOffsetMinutes} minutes. Warmup with your visual analysis systems!',
                                location: 'Indoor Court 01',
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F80ED).withOpacity(0.12),
                        foregroundColor: const Color(0xFF2F80ED),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.sports_tennis_rounded, size: 14),
                      label: Text(
                        'Test Tennis',
                        style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: enabled
                          ? () {
                              _notifService.triggerNotificationInstantly(
                                sport: 'Padel',
                                title: '🏸 Live Padel Coaching Warmup',
                                body: 'Your pro Padel Arena session with Coach Robert starts in ${_notifService.reminderOffsetMinutes} minutes!',
                                location: 'Padel Arena 01',
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF06B6D4).withOpacity(0.12),
                        foregroundColor: const Color(0xFF06B6D4),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      icon: const Icon(Icons.flash_on_rounded, size: 14),
                      label: Text(
                        'Test Padel',
                        style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 18),

        // Notifications list / log panel
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.007),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Text(
                    'Workspace Logs ($logCount)',
                    style: GoogleFonts.spaceGrotesk(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  if (logCount > 0)
                    TextButton(
                      onPressed: () {
                        _notifService.markAllAsRead();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF2F80ED),
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(50, 20),
                      ),
                      child: Text(
                        'Read All',
                        style: GoogleFonts.spaceGrotesk(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (_notifService.notifications.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'No local reminders generated yet.',
                      style: TextStyle(color: Colors.white30, fontSize: 11),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _notifService.notifications.length,
                  itemBuilder: (context, idx) {
                    final alert = _notifService.notifications[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: alert.isRead ? Colors.transparent : const Color(0xFF2F80ED).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: alert.isRead ? Colors.white.withOpacity(0.03) : const Color(0xFF2F80ED).withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.02),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              alert.sport == 'Tennis'
                                  ? Icons.sports_tennis_rounded
                                  : Icons.sports_kabaddi_rounded,
                              color: const Color(0xFF2F80ED),
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        alert.title,
                                        style: GoogleFonts.spaceGrotesk(
                                          color: alert.isRead ? Colors.white60 : Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (!alert.isRead)
                                      Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF10B981),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  alert.body,
                                  style: TextStyle(
                                    color: alert.isRead ? Colors.white38 : Colors.white70,
                                    fontSize: 10.5,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () {
                              _notifService.deleteNotification(alert.id);
                            },
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.white24, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          )
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _statCard(String label, String value, Color color, IconData icon, String subtitle) {
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
                  subtitle,
                  style: const TextStyle(color: Colors.white30, fontSize: 9, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              label,
              style: const TextStyle(color: Colors.white45, fontSize: 11),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.black,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bookingListItem(BookingModel booking) {
    final bool isConfirmed = booking.isConfirmed || booking.status == 'Confirmed';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.01),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isConfirmed ? const Color(0xFF10B981) : const Color(0xFFF2994A)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                booking.sport == 'Tennis'
                    ? Icons.sports_tennis_rounded
                    : booking.sport == 'Padel'
                        ? Icons.sports_kabaddi_rounded
                        : Icons.sports_basketball_rounded,
                color: isConfirmed ? const Color(0xFF10B981) : const Color(0xFFF2994A),
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking.courtName,
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.black,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    booking.details,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    booking.timeSlot,
                    style: GoogleFonts.spaceGrotesk(
                      color: const Color(0xFF2F80ED),
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: (isConfirmed ? const Color(0xFF10B981) : const Color(0xFFF2994A)).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: TextStyle(
                      color: isConfirmed ? const Color(0xFF10B981) : const Color(0xFFF2994A),
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                if (isConfirmed) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder: (context) => PostTrainingFeedbackForm(
                          profile: widget.profile,
                          booking: booking,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2F80ED).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF2F80ED).withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF2C94C), size: 10),
                          const SizedBox(width: 4),
                          Text(
                            'RATE',
                            style: GoogleFonts.spaceGrotesk(
                              color: const Color(0xFF2F80ED),
                              fontWeight: FontWeight.black,
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _opponentMatchCard(String name, String sport, String elo, String tag, String sportType) {
    return Container(
      width: 154,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.01),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white10,
            backgroundImage: NetworkImage('https://api.dicebear.com/7.x/avataaars/svg?seed=$name'),
            radius: 26,
          ),
          const SizedBox(height: 12),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.black,
              fontSize: 12,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sport,
            style: const TextStyle(fontSize: 10, color: Colors.white45),
          ),
          const SizedBox(height: 4),
          Text(
            elo,
            style: GoogleFonts.spaceGrotesk(fontSize: 10, color: const Color(0xFF2F80ED), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 30,
            child: ElevatedButton(
              onPressed: () => _challengeOpponent(name, sportType.toUpperCase()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F80ED).withOpacity(0.15),
                foregroundColor: const Color(0xFF2F80ED),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                'CHALLENGE',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFeedbackCTACard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF10B981).withOpacity(0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.rate_review_rounded, color: Color(0xFF10B981), size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'POST-TRAINING FEEDBACK LOOP',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  color: const Color(0xFF10B981),
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Keep your coaching team perfectly aligned with your physical states and technical milestones. Rate your workout load and submit qualitative metrics.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withOpacity(0.75),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => PostTrainingFeedbackForm(
                    profile: widget.profile,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              icon: const Icon(Icons.add_task_rounded, color: Colors.white, size: 16),
              label: Text(
                'RECORD POST-SESSION REVIEWS',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 11,
                  fontWeight: FontWeight.black,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyFeedbackHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Text(
              'My Sent Reviews',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 20,
                fontWeight: FontWeight.black,
                color: Colors.white,
              ),
            ),
            const Text(
              'SECURE COUPLING',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white30),
            )
          ],
        ),
        const SizedBox(height: 14),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('session_feedback')
              .where('playerId', isEqualTo: widget.profile.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Failed to load logs: ${snapshot.error}', style: const TextStyle(color: Colors.redAccent));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));
            }
            final docs = snapshot.data!.docs;
            if (docs.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.01),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.hourglass_empty_rounded, color: Colors.white30, size: 24),
                    const SizedBox(height: 8),
                    Text(
                      'No reviews submitted yet',
                      style: GoogleFonts.spaceGrotesk(color: Colors.white38, fontSize: 12),
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
                final data = sortedDocs[index].data() as Map<String, dynamic>;
                final rating = (data['rating'] ?? 5.0) as double;
                final comments = data['comments'] ?? '';
                final coachName = data['coachName'] ?? 'Your Coach';
                final exertion = data['exertion'] ?? 'Unknown Exertion';
                final isAck = data['acknowledged'] ?? false;
                final sport = data['sport'] ?? 'Tennis';
                final List<dynamic> focusTags = data['technicalFocus'] ?? [];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.012),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.04)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Row(
                            children: [
                              Icon(
                                sport == 'Tennis'
                                    ? Icons.sports_tennis_rounded
                                    : sport == 'Padel'
                                        ? Icons.sports_kabaddi_rounded
                                        : Icons.sports_basketball_rounded,
                                size: 14,
                                color: const Color(0xFF2F80ED),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                sport,
                                style: GoogleFonts.spaceGrotesk(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isAck 
                                  ? const Color(0xFF10B981).withOpacity(0.12)
                                  : const Color(0xFF2F80ED).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isAck ? Icons.check_circle_rounded : Icons.pending_rounded,
                                  color: isAck ? const Color(0xFF10B981) : const Color(0xFF2F80ED),
                                  size: 10,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isAck ? 'ACKNOWLEDGED' : 'TRANSMITTED',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 8,
                                    fontWeight: FontWeight.black,
                                    color: isAck ? const Color(0xFF10B981) : const Color(0xFF2F80ED),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text('Target Coach: ', style: TextStyle(color: Colors.white30, fontSize: 11)),
                          Text(coachName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          const Spacer(),
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
                      const SizedBox(height: 8),
                      Text(
                        comments,
                        style: const TextStyle(color: Colors.white80, fontSize: 12, height: 1.4),
                      ),
                      const SizedBox(height: 10),
                      
                      if (focusTags.isNotEmpty) ...[
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: focusTags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Text(
                                tag.toString(),
                                style: const TextStyle(fontSize: 8.5, color: Colors.white54),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                      ],
                      
                      Row(
                        children: [
                          const Icon(Icons.flash_on_rounded, size: 10, color: Color(0xFF10B981)),
                          const SizedBox(width: 4),
                          Text(
                            exertion,
                            style: GoogleFonts.spaceGrotesk(color: const Color(0xFF10B981), fontSize: 10, fontWeight: FontWeight.bold),
                          ),
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
