import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';

class VideoGeneratorScreen extends StatefulWidget {
  const VideoGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<VideoGeneratorScreen> createState() => _VideoGeneratorScreenState();
}

class _VideoGeneratorScreenState extends State<VideoGeneratorScreen> {
  final TextEditingController _promptController = TextEditingController();
  bool _isGenerating = false;
  String? _videoUrl;
  String? _error;

  void _generateVideo() {
    final text = _promptController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isGenerating = true;
      _error = null;
      _videoUrl = null;
    });

    // Simulate Veo generation steps
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isGenerating = false;
          _videoUrl = 'https://assets.mixkit.co/videos/preview/mixkit-tennis-player-hitting-ball-slow-motion-40011-large.mp4';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2F80ED).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.video_library_rounded, color: Color(0xFF2F80ED)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Video Technique Lab',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 22,
                          fontWeight: FontWeight.black,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Generate ideal movement demonstrations via Veo models.',
                        style: TextStyle(color: Colors.white54, fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Generator Input Card
              Container(
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
                      'DESCRIBE THE TECHNIQUE DEMO',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F80ED),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _promptController,
                      maxLines: 3,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'e.g., Serve acceleration at 120 FPS slow motion with knee flexion visual annotations...',
                        hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.01),
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
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2F80ED),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _isGenerating ? null : _generateVideo,
                        icon: _isGenerating
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Icon(Icons.bolt_rounded),
                        label: Text(
                          _isGenerating ? 'GENERATING VEO RENDER...' : 'GENERATE DEMONSTRATION',
                          style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Render preview space
              if (_isGenerating || _videoUrl != null)
                Container(
                  width: double.infinity,
                  height: 240,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: _isGenerating
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(color: Color(0xFF2F80ED)),
                            const SizedBox(height: 16),
                            const Text(
                              'Compiling optical dynamics (Veo-3.1)...',
                              style: TextStyle(color: Colors.white60, fontSize: 13),
                            ),
                          ],
                        )
                      : Stack(
                          alignment: Alignment.center,
                          children: [
                            // Mocking the video player thumbnail with high quality overlay
                            Opacity(
                              opacity: 0.4,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.network(
                                  'https://images.unsplash.com/photo-1595435934249-5df7ed86e1c0?q=80&w=600&auto=format&fit=crop',
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundColor: const Color(0xFF2F80ED),
                                  child: IconButton(
                                    icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
                                    onPressed: () {},
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Slow-motion Demonstration Ready',
                                  style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const Text(
                                  'Resolution: 1080p | Duration: 4s',
                                  style: TextStyle(color: Colors.white54, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
