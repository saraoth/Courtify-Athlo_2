import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';

class OnboardingScreen extends StatefulWidget {
  final UserProfile profile;
  final Function(UserProfile) onComplete;

  const OnboardingScreen({Key? key, required this.profile, required this.onComplete}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  String? _selectedSport;
  String? _selectedSkill;
  bool _loading = false;

  final List<Map<String, dynamic>> _steps = [
    {
      'id': 'welcome',
      'title': 'Welcome to the Elite Circle',
      'subtitle': 'COURTIFY ATHLO ELITE',
      'description': 'Your professional ecosystem for performance tracking, elite coaching, and neural-powered insights.',
      'icon': Icons.auto_awesome_rounded,
      'gradient': [Color(0xFF2F80ED), Color(0xFF4F46E5)]
    },
    {
      'id': 'sport',
      'title': 'Select Your Discipline',
      'subtitle': 'SPECIALIZATION',
      'description': 'Choose the sport you are currently mastering. You can add more later.',
      'icon': Icons.emoji_events_rounded,
      'gradient': [Color(0xFFF2994A), Color(0xFFE11D48)]
    },
    {
      'id': 'skill',
      'title': 'Current Proficiency',
      'subtitle': 'PERFORMANCE BASELINE',
      'description': 'Be precise. This calibrates our AI models to your current level.',
      'icon': Icons.gps_fixed_rounded,
      'gradient': [Color(0xFF10B981), Color(0xFF0D9488)]
    },
    {
      'id': 'tour_booking',
      'title': 'Smart Court Booking',
      'subtitle': 'APP TOUR • 01',
      'description': 'Secure premium courts instantly. Manage your sessions with professional-grade scheduling tools.',
      'icon': Icons.calendar_month_rounded,
      'gradient': [Color(0xFF2563EB), Color(0xFF06B6D4)]
    },
    {
      'id': 'tour_match',
      'title': 'Elite Matchmaking',
      'subtitle': 'APP TOUR • 02',
      'description': 'Find opponents that match your skill level perfectly. Coordinate matches with zero friction.',
      'icon': Icons.bolt_rounded,
      'gradient': [Color(0xFFEF4444), Color(0xFFF59E0B)]
    },
    {
      'id': 'tour_ai',
      'title': 'Neural Insights',
      'subtitle': 'APP TOUR • 03',
      'description': 'Access deep tactical analysis and AI-powered performance breakdowns after every session.',
      'icon': Icons.psychology_rounded,
      'gradient': [Color(0xFF4F46E5), Color(0xFF9333EA)]
    }
  ];

  final List<Map<String, String>> _sportsList = [
    {'id': 'tennis', 'name': 'Tennis', 'icon': '🎾'},
    {'id': 'basketball', 'name': 'Basketball', 'icon': '🏀'},
    {'id': 'football', 'name': 'Football', 'icon': '⚽'},
    {'id': 'padel', 'name': 'Padel', 'icon': '🏸'},
    {'id': 'gym', 'name': 'Fitness', 'icon': '💪'},
    {'id': 'other', 'name': 'Other', 'icon': '🏆'},
  ];

  final List<Map<String, String>> _skillLevels = [
    {'id': 'beginner', 'name': 'Beginner', 'desc': 'Foundational training'},
    {'id': 'intermediate', 'name': 'Intermediate', 'desc': 'Competitive regular'},
    {'id': 'advanced', 'name': 'Advanced', 'desc': 'High-performance athlete'},
    {'id': 'pro', 'name': 'Professional', 'desc': 'Elite professional'},
  ];

  void _next() {
    if (_currentStep < _steps.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _finishOnboarding();
    }
  }

  void _back() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  void _finishOnboarding() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    final updatedProfile = widget.profile.copyWith(
      sports: [_selectedSport ?? 'tennis'],
      skillLevel: _selectedSkill ?? 'beginner',
      onboardingCompleted: true,
    );
    widget.onComplete(updatedProfile);
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];
    final title = step['title'] as String;
    final subtitle = step['subtitle'] as String;
    final description = step['description'] as String;
    final List<Color> gradientColors = step['gradient'] as List<Color>;
    final IconData stepIcon = step['icon'] as IconData;

    return Scaffold(
      backgroundColor: const Color(0xFF020617), // slate-950
      body: Stack(
        children: [
          // Background Atmosphere Sphere
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              radialGradient: RadialGradient(
                colors: [
                  gradientColors[0].withOpacity(0.15),
                  Colors.transparent,
                ],
                center: const Alignment(0, -0.3),
                radius: 1.2,
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Top progress and Skip header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Row(
                        children: List.generate(_steps.length, (index) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: index == _currentStep ? 24 : 6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index <= _currentStep ? gradientColors[0] : Colors.white24,
                            ),
                          );
                        }),
                      ),
                      TextButton(
                        onPressed: _finishOnboarding,
                        child: Text(
                          'Skip Tour',
                          style: GoogleFonts.inter(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.black,
                            letterSpacing: 2,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Responsive Content Panel
                  Expanded(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Icon header
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(color: Colors.white24, width: 1.5),
                              ),
                              child: Icon(stepIcon, color: Colors.white, size: 36),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              subtitle,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                                color: gradientColors[0],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                description,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white70,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Render step specific inputs
                            Expanded(child: _buildStepContent(step['id'])),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Bottom controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      _currentStep > 0
                          ? OutlinedButton.icon(
                              onPressed: _back,
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white12),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              icon: const Icon(Icons.chevron_left_rounded, color: Colors.white60),
                              label: const Text('Back', style: TextStyle(color: Colors.white)),
                            )
                          : const SizedBox(),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: _loading
                            ? null
                            : () {
                                if (step['id'] == 'sport' && _selectedSport == null) return;
                                if (step['id'] == 'skill' && _selectedSkill == null) return;
                                _next();
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: gradientColors[0],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        icon: _loading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1.5),
                              )
                            : const Icon(Icons.arrow_forward_rounded, size: 20),
                        label: Text(
                          _loading
                              ? 'Initializing Core...'
                              : _currentStep == _steps.length - 1
                                  ? 'Initialize System'
                                  : 'Continue',
                          style: GoogleFonts.inter(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStepContent(String stepId) {
    switch (stepId) {
      case 'welcome':
        return Column(
          children: [
            const SizedBox(height: 16),
            _iconFeatureRow(Icons.grade_rounded, 'Elite Standard',
                'Engineered for athletes who demand professional-grade tracking and analysis.'),
            _iconFeatureRow(Icons.psychology_rounded, 'Neural Core',
                'Our proprietary AI models provide deep tactical insights and biomechanical feedback.'),
          ],
        );
      case 'sport':
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
          ),
          itemCount: _sportsList.length,
          itemBuilder: (context, index) {
            final s = _sportsList[index];
            final isS = _selectedSport == s['id'];
            return GestureDetector(
              onTap: () {
                setState(() => _selectedSport = s['id']);
                Future.delayed(const Duration(milliseconds: 300), _next);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isS ? const Color(0xFFF2994A).withOpacity(0.12) : Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isS ? const Color(0xFFF2994A) : Colors.white10,
                    width: isS ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(s['icon']!, style: const TextStyle(fontSize: 32)),
                    const SizedBox(height: 8),
                    Text(
                      s['name']!.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: isS ? const Color(0xFFF2994A) : Colors.white60,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      case 'skill':
        return ListView.builder(
          itemCount: _skillLevels.length,
          itemBuilder: (context, index) {
            final s = _skillLevels[index];
            final isS = _selectedSkill == s['id'];
            return Padding(
              padding: const EdgeInsets.bottom(12.0),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedSkill = s['id']);
                  Future.delayed(const Duration(milliseconds: 300), _next);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isS ? const Color(0xFF10B981).withOpacity(0.1) : Colors.white.withOpacity(0.02),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isS ? const Color(0xFF10B981) : Colors.white10,
                      width: isS ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: isS ? const Color(0xFF10B981) : Colors.white10,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.fitness_center_rounded, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s['name']!.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.black,
                              color: isS ? Colors.white : Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(s['desc']!, style: const TextStyle(fontSize: 11, color: Colors.white54)),
                        ],
                      ),
                      const Spacer(),
                      if (isS) const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981))
                    ],
                  ),
                ),
              ),
            );
          },
        );
      case 'tour_booking':
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.between,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, color: Colors.blueAccent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Prime Slot • 18:00',
                        style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white54),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.emerald.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('Available', style: TextStyle(color: Colors.greenAccent, fontSize: 10)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Court 04 • Indoor Acrylic',
                style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.black, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text('Premium shock-absorbent surface with pro lighting.', style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'RESERVE COURT NOW',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 11, letterSpacing: 2),
                  ),
                ),
              )
            ],
          ),
        );
      case 'tour_match':
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Colors.roseAccent, Colors.amberAccent]),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.people_alt_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Find Opponent', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Text('ELO Matchmaking Engine', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 10)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.04), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white12,
                      child: Text('📱'),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Michael Jordan', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('ELO Ranking: 1840 (Advanced)', style: TextStyle(color: Colors.amberAccent.withOpacity(0.8), fontSize: 9)),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: Colors.roseAccent, borderRadius: BorderRadius.circular(10)),
                      child: const Text('Invite', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      case 'tour_ai':
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
                    child: Column(
                      children: [
                        const Icon(Icons.analytics_rounded, color: Colors.purpleAccent),
                        const SizedBox(height: 8),
                        Text('84.2%', style: GoogleFonts.spaceGrotesk(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('Accuracy Score', style: TextStyle(color: Colors.white38, fontSize: 9)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.indigoAccent.withOpacity(0.12), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.indigoAccent)),
                    child: Column(
                      children: [
                        const Icon(Icons.psychology_rounded, color: Colors.white),
                        const SizedBox(height: 8),
                        Text('Neural active', style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                        const Text('Coach Feedback', style: TextStyle(color: Colors.white54, fontSize: 9)),
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.02), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.insights_rounded, color: Colors.indigoAccent, size: 14),
                      const SizedBox(width: 8),
                      Text('Coach AI Diagnosis', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.indigoAccent)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '"Based on your last 3 matches, your cross-court efficiency has increased by 12%. Focusing on deep baseline placement will further elevate your game."',
                    style: TextStyle(color: Colors.white75, fontSize: 11, fontStyle: FontStyle.italic, height: 1.4),
                  )
                ],
              ),
            )
          ],
        );
      default:
        return Container();
    }
  }

  Widget _iconFeatureRow(IconData icon, String title, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2F80ED), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.black, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(text, style: const TextStyle(fontSize: 11, color: Colors.white60, height: 1.4)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
