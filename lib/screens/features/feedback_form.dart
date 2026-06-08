import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_profile.dart';
import '../../models/app_state.dart';

class PostTrainingFeedbackForm extends StatefulWidget {
  final UserProfile profile;
  final BookingModel? booking;
  final VoidCallback? onSubmitSuccess;

  const PostTrainingFeedbackForm({
    Key? key,
    required this.profile,
    this.booking,
    this.onSubmitSuccess,
  }) : super(key: key);

  @override
  State<PostTrainingFeedbackForm> createState() => _PostTrainingFeedbackFormState();
}

class _PostTrainingFeedbackFormState extends State<PostTrainingFeedbackForm> {
  final _commentController = TextEditingController();
  
  // State configurations
  double _rating = 5.0;
  String _selectedSport = 'Tennis';
  String _selectedCoachId = 'coach_rob';
  String _selectedCoachName = 'Coach Robert';
  String _selectedExertion = 'Medium Load (Kinetic Flow)';
  List<String> _selectedFocus = [];
  bool _isSubmitting = false;

  final List<Map<String, String>> _coaches = [
    {'id': 'coach_rob', 'name': 'Coach Robert', 'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Robert'},
    {'id': 'coach_jessica', 'name': 'Coach Jessica', 'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Jessica'},
    {'id': 'coach_michael', 'name': 'Coach Michael', 'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Michael'},
  ];

  final List<String> _exertionOptions = [
    'Low Load (Active Rest)',
    'Medium Load (Kinetic Flow)',
    'High Load (Peak Challenge)',
  ];

  final List<String> _technicalFocusOptions = [
    'Backhand Kinetic Alignment',
    'Serve Spin Velocity Pitch',
    'Footwork Lateral Agility',
    'Stamina & Fatigue Reserve',
    'Tactical Court Coverage',
    'Net Play Depth Control',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.booking != null) {
      _selectedSport = widget.booking!.sport;
      // Synthesize coach details based on sport types
      if (_selectedSport == 'Padel') {
        _selectedCoachId = 'coach_jessica';
        _selectedCoachName = 'Coach Jessica';
      } else if (_selectedSport == 'Basketball') {
        _selectedCoachId = 'coach_michael';
        _selectedCoachName = 'Coach Michael';
      }
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _handleFocusToggle(String focus) {
    setState(() {
      if (_selectedFocus.contains(focus)) {
        _selectedFocus.remove(focus);
      } else {
        if (_selectedFocus.length < 3) {
          _selectedFocus.add(focus);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum 3 technical focus areas allowed for calibration.'),
              backgroundColor: Colors.amber,
            ),
          );
        }
      }
    });
  }

  Future<void> _submitFeedback() async {
    final comments = _commentController.text.trim();
    if (comments.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please share a brief comment about your kinetic metrics or session flow.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await FirebaseFirestore.instance.collection('session_feedback').add({
        'playerId': widget.profile.uid,
        'playerName': widget.profile.name,
        'playerAvatar': widget.profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=${widget.profile.name}',
        'sport': _selectedSport,
        'coachId': _selectedCoachId,
        'coachName': _selectedCoachName,
        'rating': _rating,
        'exertion': _selectedExertion,
        'technicalFocus': _selectedFocus,
        'comments': comments,
        'createdAt': DateTime.now().toIso8601String(),
        'acknowledged': false,
        'courtName': widget.booking?.courtName ?? 'Calibration Court Alpha',
        'timeSlot': widget.booking?.timeSlot ?? 'Custom Ad-hoc Workout',
      });

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF10B981),
            content: Row(
              children: [
                const Icon(Icons.done_all_rounded, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  'Telemetry feedback successfully synced to $_selectedCoachName!',
                  style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );

        if (widget.onSubmitSuccess != null) {
          widget.onSubmitSuccess!();
        }
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback sync interrupted: $e'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Column(
          children: [
            // Slide indicator line
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SECURE DATA TRANSMISSION',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2F80ED),
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Post-Training Diagnostics',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 18,
                          fontWeight: FontWeight.black,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step 1: Format & Coach Info
                    _sectionHeader('1', 'KINETIC CONTEXT & COACH'),
                    const SizedBox(height: 12),
                    
                    if (widget.booking != null) ...[
                      // Prefilled card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.015),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _selectedSport == 'Tennis'
                                  ? Icons.sports_tennis_rounded
                                  : Icons.sports_kabaddi_rounded,
                              color: const Color(0xFF2F80ED),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${widget.booking!.courtName}',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${widget.booking!.timeSlot} • $_selectedSport',
                                    style: const TextStyle(color: Colors.white54, fontSize: 11),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      // Custom drop selectors
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Sport Format', style: TextStyle(color: Colors.white60, fontSize: 11)),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.015),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedSport,
                                      dropdownColor: const Color(0xFF1E293B),
                                      icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.white54),
                                      isExpanded: true,
                                      style: const TextStyle(color: Colors.white, fontSize: 13),
                                      items: ['Tennis', 'Padel', 'Basketball'].map((sport) {
                                        return DropdownMenuItem(value: sport, child: Text(sport));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedSport = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 16),
                    const Text('Assign Targeting Coach', style: TextStyle(color: Colors.white60, fontSize: 11)),
                    const SizedBox(height: 8),
                    Container(
                      height: 64,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: _coaches.length,
                        itemBuilder: (context, idx) {
                          final coach = _coaches[idx];
                          final isSelected = _selectedCoachId == coach['id'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCoachId = coach['id']!;
                                _selectedCoachName = coach['name']!;
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 12),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected 
                                    ? const Color(0xFF2F80ED).withOpacity(0.12)
                                    : Colors.white.withOpacity(0.01),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF2F80ED) : Colors.white.withOpacity(0.05),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 14,
                                    backgroundImage: NetworkImage(coach['avatar']!),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    coach['name']!,
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.black : FontWeight.normal,
                                      color: isSelected ? const Color(0xFF2F80ED) : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Step 2: Session Rating Star widget
                    _sectionHeader('2', 'SESSION RATING & QUALITY'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.015),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Calibrate Performance Core',
                            style: GoogleFonts.spaceGrotesk(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) {
                              final starVal = index + 1;
                              final filled = _rating >= starVal;
                              return IconButton(
                                icon: Icon(
                                  filled ? Icons.star_rounded : Icons.star_outline_rounded,
                                  color: filled ? const Color(0xFFF2C94C) : Colors.white24,
                                  size: 36,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _rating = starVal.toDouble();
                                  });
                                },
                              );
                            }),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _rating == 5.0
                                ? 'EXCELLENT PROGRESS SYNC'
                                : _rating >= 4.0
                                    ? 'HIGH QUALITY FLOW'
                                    : _rating >= 3.0
                                        ? 'STABLE CORRELATION'
                                        : 'RECALIBRATION REQUIRED',
                            style: GoogleFonts.spaceGrotesk(
                              color: _rating >= 4.0 ? Colors.emeraldAccent : Colors.amberAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.black,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Step 3: Exertion loads
                    _sectionHeader('3', 'CARDIOVASCULAR & PHYSICAL EXERTION LOAD'),
                    const SizedBox(height: 12),
                    Column(
                      children: _exertionOptions.map((opt) {
                        final isSel = _selectedExertion == opt;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedExertion = opt;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF10B981).withOpacity(0.12) : Colors.white.withOpacity(0.01),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSel ? const Color(0xFF10B981) : Colors.white.withOpacity(0.05),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isSel ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                                  color: isSel ? const Color(0xFF10B981) : Colors.white24,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  opt,
                                  style: TextStyle(
                                    color: isSel ? Colors.white : Colors.white70,
                                    fontSize: 12,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // Step 4: Technical Focus tags
                    _sectionHeader('4', 'SPECIFIC TECHNICAL FOCUS (UP TO 3)'),
                    const SizedBox(height: 6),
                    const Text('Which biomechanical vectors did you work on today?', style: TextStyle(color: Colors.white34, fontSize: 11)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _technicalFocusOptions.map((tag) {
                        final isSel = _selectedFocus.contains(tag);
                        return GestureDetector(
                          onTap: () => _handleFocusToggle(tag),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF2F80ED) : Colors.white.withOpacity(0.015),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSel ? const Color(0xFF2F80ED) : Colors.white10,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSel) ...[
                                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 12),
                                  const SizedBox(width: 6),
                                ],
                                Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isSel ? Colors.white : Colors.white70,
                                    fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 28),

                    // Step 5: Qualitative comments input
                    _sectionHeader('5', 'QUALITATIVE METRIC EXPLANATIONS'),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _commentController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Share technical comments. e.g. "I calibrated wrist velocities but need deeper analysis on serve trajectory stability during deep clay backhands..."',
                        hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.015),
                        contentPadding: const EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.white10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFF2F80ED)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 36),

                    // Encoded Stream Sync Button!
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _submitFeedback,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80ED),
                          disabledBackgroundColor: const Color(0xFF2F80ED).withOpacity(0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: _isSubmitting
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.cloud_upload_rounded, color: Colors.white),
                        label: Text(
                          _isSubmitting ? 'TRANSMITTING ENCRYPTED TELEMETRY...' : 'ENCRYPT & SYNC POST-SESSION FEEDBACK',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 11,
                            fontWeight: FontWeight.black,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String num, String text) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFF2F80ED),
            shape: BoxShape.circle,
          ),
          child: Text(
            num,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 12,
            fontWeight: FontWeight.black,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
