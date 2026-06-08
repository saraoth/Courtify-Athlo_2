import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';
import '../../models/app_state.dart';
import '../../models/notification_service.dart';

class BookingScreen extends StatefulWidget {
  final UserProfile profile;

  const BookingScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final AppStateStore _stateStore = AppStateStore();
  String _selectedSport = 'Tennis';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Default sport select aligns with onboarding config
    if (widget.profile.sports?.isNotEmpty == true) {
      final initialSport = widget.profile.sports!.first;
      // Capitalize first letter
      _selectedSport = initialSport[0].toUpperCase() + initialSport.substring(1).toLowerCase();
    }
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

  void _reserveCourt(String courtName, String description, String timeSlot) {
    // Generate new booking inside AppStateStore
    final newBooking = BookingModel(
      id: 'book_${DateTime.now().millisecondsSinceEpoch}',
      courtName: courtName,
      details: description,
      timeSlot: 'Slot: ${_selectedDate.day}/${_selectedDate.month} • $timeSlot',
      date: _selectedDate,
      status: 'Pending Approval',
      isConfirmed: false,
      sport: _selectedSport,
    );

    _stateStore.addBooking(newBooking);

    // Schedule a Local Notification starting soon! (Fires in 8 seconds for real simulation play!)
    LocalNotificationService().scheduleNotification(
      sport: _selectedSport,
      title: 'Upcoming Training Session 🎾',
      body: 'Your $_selectedSport slot at $courtName is starting in 15 minutes. Prepare with kinetic drill models!',
      location: courtName,
      scheduledTime: DateTime.now().add(const Duration(seconds: 8)),
      delaySeconds: 8,
    );

    // Show a beautiful premium feedback SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2F80ED),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'RESERVATION SUBMITTED',
                  style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.black, color: Colors.white, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Your request for $courtName has been queued. Simulated local notice scheduled for 8 seconds from now! Keep an eye on the top center of the screen.',
              style: const TextStyle(color: Colors.white80, fontSize: 11, height: 1.35),
            ),
          ],
        ),
        duration: const Duration(seconds: 6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instant Resource Booking',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 26,
                  fontWeight: FontWeight.black,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Instant ELO matching and physical smart court reservation sync.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 24),

              // Filter Tabs Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: [
                    _sportFilterTab('Tennis', '🎾'),
                    const SizedBox(width: 8),
                    _sportFilterTab('Padel', '🏸'),
                    const SizedBox(width: 8),
                    _sportFilterTab('Basketball', '🏀'),
                    const SizedBox(width: 8),
                    _sportFilterTab('Fitness', '💪'),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              _header('Date Calibration'),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 14)),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Color(0xFF2F80ED),
                            surface: Color(0xFF0F172A),
                          ),
                          dialogBackgroundColor: const Color(0xFF0F172A),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: Color(0xFF2F80ED), size: 22),
                          const SizedBox(width: 12),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: GoogleFonts.spaceGrotesk(
                              color: Colors.white,
                              fontWeight: FontWeight.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Icon(Icons.edit_calendar_rounded, color: Colors.white45, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              _header('Available Slots matching ELO'),
              const SizedBox(height: 14),

              // Dynamic lists of slots matching Selected Sport filter variables
              if (_selectedSport == 'Tennis') ...[
                _courtSlotCard('Court 01 (Clay Supreme)', 'Indoor • High-speed visual sensors active', '16:00 - 17:00 PM', true),
                _courtSlotCard('Court 02 (Acrylic Elite)', 'Outdoor • Wind Shield & Pro LED lighting', '18:00 - 19:30 PM', true),
                _courtSlotCard('Court 03 (Classic Grass)', 'Outdoor • Precision moisture drain system', '20:00 - 21:00 PM', true),
              ] else if (_selectedSport == 'Padel') ...[
                _courtSlotCard('Padel Arena 01 (Panoramic Glass)', 'Indoor • Smart vibration shock flooring', '09:00 - 10:30 AM', true),
                _courtSlotCard('Padel Arena 02 (Classic Steel)', 'Outdoor • Wind defense shields', '14:00 - 15:30 PM', true),
                _courtSlotCard('Padel Arena 03 (Panoramic Red)', 'Indoor • Advanced heat recovery system', '19:00 - 20:30 PM', true),
              ] else if (_selectedSport == 'Basketball') ...[
                _courtSlotCard('Basketball Court 01 (Hard Maple)', 'Indoor • Real-time rim metric camera trackers', '10:00 - 11:30 AM', true),
                _courtSlotCard('Basketball Court 02 (Outdoor Asphalt)', 'Outdoor • Double metal chains rim nets', '17:00 - 18:30 PM', true),
              ] else ...[
                _courtSlotCard('Athlo Fitness Zone A', 'Open Workouts • Cardio and structural systems', '08:00 - 10:00 AM', true),
                _courtSlotCard('Athlo Biometrics Suite', 'Calibrations • High frequency motion tracking', '15:00 - 16:00 PM', true),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _sportFilterTab(String label, String emoji) {
    final isSelected = _selectedSport == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedSport = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F80ED).withOpacity(0.12) : Colors.white.withOpacity(0.015),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF2F80ED) : Colors.white.withOpacity(0.04),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(emoji),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.black : FontWeight.medium,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 18,
        fontWeight: FontWeight.black,
        color: Colors.white,
      ),
    );
  }

  Widget _courtSlotCard(String name, String details, String time, bool available) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.01),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.black,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    time,
                    style: GoogleFonts.spaceGrotesk(
                      color: const Color(0xFF2F80ED),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: available ? () => _reserveCourt(name, details, time) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: available ? const Color(0xFF2F80ED) : Colors.white10,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              child: Text(
                available ? 'Reserve' : 'Locked',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.black,
                  fontSize: 11,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
