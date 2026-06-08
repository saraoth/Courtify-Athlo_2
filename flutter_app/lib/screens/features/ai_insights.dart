import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';

class AIInsights extends StatefulWidget {
  const AIInsights({Key? key}) : super(key: key);

  @override
  State<AIInsights> createState() => _AIInsightsState();
}

class _AIInsightsState extends State<AIInsights> {
  final List<Map<String, dynamic>> _messages = [
    {
      'role': 'assistant',
      'text': 'Hello Athlete! I am your Athlo AI neural coach. I analyze matches and offer precise structural feedback. Ask me anything about your form or recent sessions.'
    }
  ];

  final TextEditingController _msgController = TextEditingController();

  void _sendMessage() {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _msgController.clear();
    });

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _messages.add({
          'role': 'assistant',
          'text': 'Analyzing biomechanics context... Based on deep-learning parameters, your "$text" forehand velocity corresponds with stable ELO standards. I recommend scheduling Clay Supreme Court 01 for spin calibration.'
        });
      });
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Performance Diagnostics',
                style: GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.black, color: Colors.white),
              ),
              const SizedBox(height: 8),
              const Text('Biomechanical metrics initialized under global ELO algorithms.', style: TextStyle(color: Colors.white54)),
              const SizedBox(height: 24),

              // Mock Analytics Graph / Chart placeholder in Dribbble Style
              Container(
                height: 140,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)]),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('WEEKLY VELOCITY', style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70)),
                        const SizedBox(height: 8),
                        Text('84.2 km/h', style: GoogleFonts.spaceGrotesk(fontSize: 24, fontWeight: FontWeight.black, color: Colors.white)),
                        const SizedBox(height: 4),
                        const Text('+12.4% vs Baseline', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    // Mock Bars indicating analytics
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(6, (index) {
                        final heights = [30.0, 50.0, 40.0, 70.0, 60.0, 90.0];
                        return Container(
                          margin: const EdgeInsets.only(left: 4),
                          width: 8,
                          height: heights[index],
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(index == 5 ? 0.9 : 0.4),
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
                'Interact with Neural Assistant',
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
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
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
                                  if (isAI)
                                    const CircleAvatar(
                                        radius: 12, backgroundColor: Colors.indigoAccent, child: Icon(Icons.psychology, size: 14, color: Colors.white)),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isAI ? Colors.white.withOpacity(0.04) : const Color(0xFF2F80ED).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16).copyWith(
                                          topLeft: isAI ? const Radius.circular(0) : const Radius.circular(16),
                                          topRight: isAI ? const Radius.circular(16) : const Radius.circular(0),
                                        ),
                                      ),
                                      child: Text(
                                        m['text']!,
                                        style: TextStyle(color: isAI ? Colors.white70 : Colors.white, fontSize: 12, height: 1.4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _msgController,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                hintText: 'Query form diagnostics...',
                                hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.02),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: const BorderSide(color: Colors.white10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
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
