import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';

class AIInsights extends StatefulWidget {
  final UserProfile profile;

  const AIInsights({Key? key, required this.profile}) : super(key: key);

  @override
  State<AIInsights> createState() => _AIInsightsState();
}

class _AIInsightsState extends State<AIInsights> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _msgController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    final sport = widget.profile.sports?.isNotEmpty == true ? widget.profile.sports!.first : 'Tennis';
    final skill = widget.profile.skillLevel ?? 'beginner';

    _messages.add({
      'role': 'assistant',
      'text': 'Hello ${widget.profile.name}! I am your Athlo AI. I have analyzed your configured profile ($sport • $skill) and synced initial movement metrics. Ask me anything about your game, wrist flexion, or stance trajectory.'
    });
  }

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _msgController.clear();
      _isTyping = true;
    });

    final sport = widget.profile.sports?.isNotEmpty == true ? widget.profile.sports!.first : 'Tennis';
    final skill = widget.profile.skillLevel ?? 'beginner';

    // Simulate smart contextualized cognitive advisor response
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'role': 'assistant',
            'text': 'Ingesting diagnostic inputs... For a $skill player in $sport, "$text" is normally caused by late wrist pronation during release. Try keeping your center of mass 15% lower during knee flexion. Would you like me to render a customized slow-motion Veo technique demonstration for this?'
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final sport = widget.profile.sports?.isNotEmpty == true ? widget.profile.sports!.first : 'tennis';
    final skill = widget.profile.skillLevel ?? 'beginner';

    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Performance Diagnostics',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 26,
                  fontWeight: FontWeight.black,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Personalized training engine calibrated to your $skill $sport baseline.',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              const SizedBox(height: 24),

              // Aesthetic biomechanical metrics summary panel
              Container(
                height: 120,
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    )
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SYNCHRONIZED SPORTS METRICS',
                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1.5),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          sport.toUpperCase(),
                          style: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.black, color: Colors.white),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Skill Category: ${skill.toUpperCase()}',
                          style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // Mock bars
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(5, (index) {
                        final heights = [25.0, 45.0, 35.0, 65.0, 80.0];
                        return Container(
                          margin: const EdgeInsets.only(left: 5),
                          width: 8,
                          height: heights[index],
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(index == 4 ? 0.95 : 0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Text(
                'Continuous Neural Diagnostics',
                style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 12),

              // Interactive chat pane
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _messages.length,
                          itemBuilder: (context, index) {
                            final m = _messages[index];
                            final isAI = m['role'] == 'assistant';
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: isAI ? MainAxisAlignment.start : MainAxisAlignment.end,
                                children: [
                                  if (isAI) ...[
                                    CircleAvatar(
                                      radius: 12,
                                      backgroundColor: const Color(0xFF4F46E5).withOpacity(0.2),
                                      child: const Icon(Icons.psychology, size: 14, color: Color(0xFF06B6D4)),
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                                      decoration: BoxDecoration(
                                        color: isAI ? Colors.white.withOpacity(0.03) : const Color(0xFF2F80ED),
                                        borderRadius: BorderRadius.circular(18).copyWith(
                                          topLeft: isAI ? const Radius.circular(0) : const Radius.circular(18),
                                          topRight: isAI ? const Radius.circular(18) : const Radius.circular(0),
                                        ),
                                      ),
                                      child: Text(
                                        m['text']!,
                                        style: TextStyle(
                                          color: isAI ? Colors.white.withOpacity(0.9) : Colors.white,
                                          fontSize: 12.5,
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      if (_isTyping)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 32),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'AI is computing kinetics...',
                              style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 11, fontStyle: FontStyle.italic),
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _msgController,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              decoration: InputDecoration(
                                hintText: 'Ask AI diagnostic questions...',
                                hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.015),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Colors.white10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: Color(0xFF2F80ED)),
                                ),
                              ),
                              onSubmitted: (_) => _sendMessage(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFF2F80ED),
                            child: IconButton(
                              icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                              onPressed: _sendMessage,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
