import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';
import '../../models/app_state.dart';

class AdminDashboard extends StatefulWidget {
  final UserProfile profile;

  const AdminDashboard({Key? key, required this.profile}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final AppStateStore _stateStore = AppStateStore();

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

  void _toggleMaintenance() {
    _stateStore.logAction(
      'MAINTENANCE_TOGGLE',
      'System maintenance mode requested by ${widget.profile.name}. All clients notified.',
      Colors.redAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          'System under virtual operational testing mode.',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _flushSockets() {
    _stateStore.logAction(
      'SOCKETS_FLUSHED',
      'Active websocket connections flushed. Synchronous states re-aligned.',
      Colors.amberAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.amberAccent,
        content: Text(
          'Sessions synchronized successfully.',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingBookings = _stateStore.bookings.where((e) => !e.isConfirmed).toList();
    final totalBookings = _stateStore.bookings.length;

    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 40),
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
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.orangeAccent,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'ADMIN OPERATIONS OVERWATCH',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.orangeAccent,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Director Desk',
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
                    backgroundColor: Colors.orangeAccent.withOpacity(0.1),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        widget.profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin',
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 28),

              // Metrics Row
              Row(
                children: [
                  _statCard(
                    'Active Bookings',
                    '$totalBookings Total Slots',
                    Colors.green,
                    Icons.calendar_month_rounded,
                    'Telemetry Sync',
                  ),
                  const SizedBox(width: 12),
                  _statCard(
                    'Pending Demands',
                    '${pendingBookings.length} For Verification',
                    Colors.amberAccent,
                    Icons.privacy_tip_rounded,
                    'Awaiting Approvals',
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Pending Approvals List (Interactive!)
              if (pendingBookings.isNotEmpty) ...[
                Text(
                  'Awaiting Reservation Approvals',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pendingBookings.length,
                  itemBuilder: (context, idx) {
                    final booking = pendingBookings[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.01),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    booking.sport.toUpperCase(),
                                    style: const TextStyle(color: Colors.amberAccent, fontSize: 9, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  booking.timeSlot,
                                  style: GoogleFonts.spaceGrotesk(color: const Color(0xFF2F80ED), fontSize: 11, fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              booking.courtName,
                              style: GoogleFonts.spaceGrotesk(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            Text(
                              booking.details,
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _stateStore.approveBooking(booking.id),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: const Text('APPROVE SLOT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () => _stateStore.rejectBooking(booking.id),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
                                      foregroundColor: Colors.redAccent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    child: const Text('REJECT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    };
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Operations Logs (Dynamic!)
              Text(
                'Recent System Manifest Audit',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _stateStore.systemLogs.length > 5 ? 5 : _stateStore.systemLogs.length,
                itemBuilder: (context, idx) {
                  final log = _stateStore.systemLogs[idx];
                  return _opLogItem(log.action, log.details, log.timeAgo, log.tagColor);
                },
              ),

              const SizedBox(height: 32),

              // Global Controls Panel
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.01),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Global System Directives',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Broadcast priority parameters instantly down to active worker nodes.',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _toggleMaintenance,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent.withOpacity(0.15),
                              foregroundColor: Colors.redAccent,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.redAccent.withOpacity(0.2)),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('MAINTENANCE ON', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _flushSockets,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white.withOpacity(0.1)),
                              foregroundColor: Colors.white70,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('SYNC SOCKETS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
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

  Widget _opLogItem(String action, String details, String time, Color tagColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.005),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.02)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: Text(
                action,
                style: TextStyle(color: tagColor, fontSize: 8.5, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                details,
                style: const TextStyle(color: Colors.white70, fontSize: 11.5),
              ),
            ),
            const SizedBox(width: 6),
            Text(time, style: const TextStyle(color: Colors.white30, fontSize: 9.5)),
          ],
        ),
      ),
    );
  }
}
