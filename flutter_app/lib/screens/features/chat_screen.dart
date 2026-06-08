import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_profile.dart';

class ChatScreen extends StatefulWidget {
  final UserProfile profile;
  
  const ChatScreen({Key? key, required this.profile}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();
  
  String _searchTerm = '';
  Map<String, dynamic>? _selectedChatUser;
  
  // High fidelity pre-populated conversations
  final List<Map<String, dynamic>> _mockChats = [
    {
      'uid': 'coach_rob',
      'name': 'Coach Robert',
      'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Robert',
      'role': 'COACH',
      'lastMessage': 'Ready for your spin analysis tomorrow?',
      'lastTime': '10:42 AM',
      'messages': [
        {'role': 'assistant', 'text': 'Hi athlete, make sure to drink water and warm up.'},
        {'role': 'user', 'text': 'Understood Coach! I improved my shoulder posture.'},
        {'role': 'assistant', 'text': 'Ready for your spin analysis tomorrow?'},
      ]
    },
    {
      'uid': 'opp_nadal',
      'name': 'Carlos Alcaraz',
      'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carlos',
      'role': 'PLAYER',
      'lastMessage': 'Awesome match! Can you booking Supreme Court 02?',
      'lastTime': 'Yesterday',
      'messages': [
        {'role': 'assistant', 'text': 'Hey, let\'s schedule our league game.'},
        {'role': 'user', 'text': 'Sure, which court?'},
        {'role': 'assistant', 'text': 'Awesome match! Can you booking Supreme Court 02?'},
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: _selectedChatUser != null ? _buildActiveChat() : _buildChatList(),
      ),
    );
  }

  Widget _buildChatList() {
    final filteredChats = _mockChats.where((chat) {
      return chat['name'].toLowerCase().contains(_searchTerm.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Courtify Secure Chat',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 26,
                  fontWeight: FontWeight.black,
                  color: Colors.white,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2F80ED).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF2F80ED)),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect securely with coaching staff, parents, and prospective match opponents.',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 24),
          
          // Search Bar
          TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchTerm = val;
              });
            },
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search conversations or opponents...',
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.white30),
              filled: true,
              fillColor: Colors.white.withOpacity(0.04),
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
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: filteredChats.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.speaker_notes_off_rounded, size: 48, color: Colors.white.withOpacity(0.2)),
                        const SizedBox(height: 16),
                        const Text(
                          'No dialogue channels initiated',
                          style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredChats.length,
                    itemBuilder: (context, idx) {
                      final chat = filteredChats[idx];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
                                backgroundImage: NetworkImage(chat['avatar']),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.emerald,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFF0F172A), width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: Row(
                            children: [
                              Text(
                                chat['name'],
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F80ED).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  chat['role'],
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.black,
                                    color: Color(0xFF2F80ED),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              chat['lastMessage'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white60, fontSize: 12),
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                chat['lastTime'],
                                style: const TextStyle(color: Colors.white30, fontSize: 10),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2F80ED),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            setState(() {
                              _selectedChatUser = chat;
                            });
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChat() {
    final chat = _selectedChatUser!;
    final List<Map<String, dynamic>> msgs = chat['messages'];

    return Column(
      children: [
        // App bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 20),
                onPressed: () {
                  setState(() {
                    _selectedChatUser = null;
                  });
                },
              ),
              const SizedBox(width: 4),
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(chat['avatar']),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat['name'],
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Active Now',
                      style: TextStyle(color: Colors.emerald, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone_rounded, color: Colors.white70),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.videocam_rounded, color: Colors.white70),
                onPressed: () {},
              ),
            ],
          ),
        ),
        
        // Chat list area
        Expanded(
          child: Container(
            color: const Color(0xFF0F172A).withBlue(22),
            padding: const EdgeInsets.all(20),
            child: ListView.builder(
              reverse: false,
              itemCount: msgs.length,
              itemBuilder: (context, idx) {
                final msg = msgs[idx];
                final isUser = msg['role'] == 'user';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isUser) ...[
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(chat['avatar']),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? const Color(0xFF2F80ED)
                                : Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20).copyWith(
                              bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(20),
                              bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            msg['text'],
                            style: TextStyle(
                              color: isUser ? Colors.white : Colors.white.withOpacity(0.9),
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.done_all_rounded, size: 14, color: Color(0xFF2F80ED)),
                      ]
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        
        // Bottom Input box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Encrypt and transmit message...',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 12),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.02),
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
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF2F80ED),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  onPressed: () {
                    final text = _msgController.text.trim();
                    if (text.isEmpty) return;
                    setState(() {
                      msgs.add({'role': 'user', 'text': text});
                      chat['lastMessage'] = text;
                      chat['lastTime'] = 'Now';
                      _msgController.clear();
                    });
                    
                    // Respond with smart simulated response after delay
                    Future.delayed(const Duration(seconds: 1), () {
                      if (mounted) {
                        setState(() {
                          msgs.add({
                            'role': 'assistant',
                            'text': 'Simulated response from Coach model: Got it. I am parsing your metrics right now.'
                          });
                          chat['lastMessage'] = 'Got it. I am parsing your metrics right now.';
                          chat['lastTime'] = 'Now';
                        });
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
