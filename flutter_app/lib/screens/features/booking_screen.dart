import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';

class BookingScreen extends StatefulWidget {
  final UserProfile profile;

  const BookingScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String _selectedSport = 'Tennis';
  DateTime _selectedDate = DateTime.now();

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
              Text(
                'Instant Resource Booking',
                style: GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.black, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text('Secure professional courts instantly with standard ELO matching.', style: TextStyle(color: Colors.white54)),
              const SizedBox(height: 24),

              // Filter Tabs
              Row(
                children: [
                  _sportFilterTab('Tennis', '🎾'),
                  const SizedBox(width: 8),
                  _sportFilterTab('Padel', '🏸'),
                  const SizedBox(width: 8),
                  _sportFilterTab('Basketball', '🏀'),
                ],
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
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: Color(0xFF2F80ED)),
                          const SizedBox(width: 12),
                          Text(
                            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.white60),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              _header('Available Slots matching ELO'),
              const SizedBox(height: 12),
              _courtSlotCard('Court 01 (Clay Supreme)', 'Indoor • Pro Lights', '16:00 - 17:00 PM', 'Available', true),
              _courtSlotCard('Court 02 (Acrylic Elite)', 'Outdoor • Wind Shield', '18:00 - 19:30 PM', 'Prime Slot Available', true),
              _courtSlotCard('Court 03 (Panoramic Glass)', 'Indoor • Underfloor cushion', '20:00 - 21:00 PM', 'Booked', false),
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
          color: isSelected ? const Color(0xFF2F80ED).withOpacity(0.12) : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF2F80ED) : Colors.white10),
        ),
        child: Row(
          children: [
            Text(emoji),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 12, fontWeight: isSelected ? FontWeight.black : FontWeight.normal, color: isSelected ? Colors.white : Colors.white60),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }

  Widget _courtSlotCard(String name, String details, String time, String status, bool available) {
    return Card(
      color: Colors.white.withOpacity(0.01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.white10)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(details, style: const TextStyle(color: Colors.white54, fontSize: 11)),
                  const SizedBox(height: 8),
                  Text(time, style: GoogleFonts.spaceGrotesk(color: const Color(0xFF2F80ED), fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: available ? () {} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: available ? const Color(0xFF2F80ED) : Colors.white10,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                available ? 'Reserve' : 'Full',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 11, color: available ? Colors.white : Colors.white38),
              ),
            )
          ],
        ),
      ),
    );
  }
}
