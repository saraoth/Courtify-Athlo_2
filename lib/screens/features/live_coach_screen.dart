import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';

class LiveCoachScreen extends StatefulWidget {
  const LiveCoachScreen({Key? key}) : super(key: key);

  @override
  State<LiveCoachScreen> createState() => _LiveCoachScreenState();
}

class _LiveCoachScreenState extends State<LiveCoachScreen> with SingleTickerProviderStateMixin {
  bool _isActive = false;
  bool _isMuted = false;
  String _status = 'Disconnected';
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleSession() {
    setState(() {
      if (!_isActive) {
        _isActive = true;
        _status = 'Connecting...';
        Future.delayed(const Duration(milliseconds: 1200), () {
          if (mounted && _isActive) {
            setState(() {
              _status = 'Active Session';
            });
          }
        });
      } else {
        _isActive = false;
        _status = 'Disconnected';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Live Tele-Coach',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 26,
                        fontWeight: FontWeight.black,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Immersive voice channel synchronized with Gemini Live Multimodal AI.',
                      style: TextStyle(color: Colors.white54, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              
              // Animated Pulse Circle for Voice activity
              Stack(
                alignment: Alignment.center,
                children: [
                  // Pulse waves
                  if (_isActive)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 180 + (_pulseController.value * 40),
                          height: 180 + (_pulseController.value * 40),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F80ED).withOpacity(0.08 * (1.0 - _pulseController.value)),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  if (_isActive)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 140 + (_pulseController.value * 25),
                          height: 140 + (_pulseController.value * 25),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F80ED).withOpacity(0.12 * (1.0 - _pulseController.value)),
                            shape: BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  
                  // Main Core Sphere
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isActive
                            ? [const Color(0xFF2F80ED), const Color(0xFF06B6D4)]
                            : [Colors.white24, Colors.white10],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: _isActive
                          ? [
                              BoxShadow(
                                color: const Color(0xFF2F80ED).withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 5,
                              )
                            ]
                          : [],
                    ),
                    child: IconButton(
                      icon: Icon(
                        _isActive ? Icons.mic_rounded : Icons.mic_none_rounded,
                        size: 44,
                        color: Colors.white,
                      ),
                      onPressed: _toggleSession,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              Text(
                _status.toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  color: _isActive ? const Color(0xFF2F80ED) : Colors.white24,
                  fontSize: 14,
                  fontWeight: FontWeight.black,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _isActive
                      ? '"Keep your racket head high Carlos! Accelerate your shoulder turn for deeper spin velocity."'
                      : 'Tap the microphone to establish real-time bio-technical live audio coaching.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _isActive ? Colors.white : Colors.white38,
                    fontSize: 13,
                    height: 1.5,
                    fontStyle: _isActive ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
              ),
              
              const Spacer(),
              
              // Audio Toggle Actions
              if (_isActive)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white10),
                      ),
                      child: IconButton(
                        icon: Icon(
                          _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
                          color: _isMuted ? Colors.redAccent : Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isMuted = !_isMuted;
                          });
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.redAccent),
                        onPressed: _toggleSession,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
