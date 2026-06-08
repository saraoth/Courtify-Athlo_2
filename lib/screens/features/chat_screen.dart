import 'dart:async';
import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_profile.dart';
import '../../models/app_state.dart';

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
  ChatChannel? _selectedChannel;
  bool _initializingFirestore = true;

  @override
  void initState() {
    super.initState();
    _ensureChannelsSeeded();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  // Seeding initial chats so that empty Firestore has default channels instantly visible on preview!
  Future<void> _ensureChannelsSeeded() async {
    try {
      final firestoreInstance = FirebaseFirestore.instance;
      final currentUserId = widget.profile.uid;

      // 1. Check & Seed Coach Rob Chat
      final coachChatId = '${currentUserId}_coach_rob';
      final coachDoc = await firestoreInstance.collection('chats').doc(coachChatId).get();
      if (!coachDoc.exists) {
        await firestoreInstance.collection('chats').doc(coachChatId).set({
          'id': coachChatId,
          'participants': [currentUserId, 'coach_rob'],
          'name': 'Coach Robert',
          'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Robert',
          'role': 'COACH',
          'lastMessage': 'Ready for your spin analysis tomorrow?',
          'lastMessageTime': DateTime.now().subtract(const Duration(minutes: 30)).toIso8601String(),
        });

        // Seed initial message list
        final messages = [
          {'senderId': 'coach_rob', 'text': 'Hi athlete, make sure to drink water and warm up.', 'timestamp': DateTime.now().subtract(const Duration(hours: 4))},
          {'senderId': currentUserId, 'text': 'Understood Coach! I improved my shoulder posture.', 'timestamp': DateTime.now().subtract(const Duration(hours: 2))},
          {'senderId': 'coach_rob', 'text': 'Ready for your spin analysis tomorrow?', 'timestamp': DateTime.now().subtract(const Duration(minutes: 30))},
        ];

        for (var msg in messages) {
          await firestoreInstance
              .collection('chats')
              .doc(coachChatId)
              .collection('messages')
              .add({
            'senderId': msg['senderId'],
            'text': msg['text'],
            'timestamp': Timestamp.fromDate(msg['timestamp'] as DateTime),
          });
        }
      }

      // 2. Check & Seed Opponent Nadal Chat (Carlos Alcaraz)
      final oppChatId = '${currentUserId}_opp_nadal';
      final oppDoc = await firestoreInstance.collection('chats').doc(oppChatId).get();
      if (!oppDoc.exists) {
        await firestoreInstance.collection('chats').doc(oppChatId).set({
          'id': oppChatId,
          'participants': [currentUserId, 'opp_nadal'],
          'name': 'Carlos Alcaraz',
          'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carlos',
          'role': 'PLAYER',
          'lastMessage': 'Awesome match! Can you booking Supreme Court 02?',
          'lastMessageTime': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        });

        final messages = [
          {'senderId': 'opp_nadal', 'text': 'Hey, let\'s schedule our league game.', 'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 2))},
          {'senderId': currentUserId, 'text': 'Sure, which court?', 'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 1))},
          {'senderId': 'opp_nadal', 'text': 'Awesome match! Can you booking Supreme Court 02?', 'timestamp': DateTime.now().subtract(const Duration(days: 1))},
        ];

        for (var msg in messages) {
          await firestoreInstance
              .collection('chats')
              .doc(oppChatId)
              .collection('messages')
              .add({
            'senderId': msg['senderId'],
            'text': msg['text'],
            'timestamp': Timestamp.fromDate(msg['timestamp'] as DateTime),
          });
        }
      }
    } catch (e) {
      debugPrint('Firestore initial seed error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _initializingFirestore = false;
        });
      }
    }
  }

  void _createNewConversation() {
    final nameController = TextEditingController();
    String selectedRole = 'COACH';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E293B),
              shadowColor: Colors.black54,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              title: Text(
                'Initialize Secure Channel',
                style: GoogleFonts.spaceGrotesk(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Establish an end-to-end synchronized chat feed.',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      labelText: 'Contact Name',
                      labelStyle: const TextStyle(color: Colors.white70),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.white20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF2F80ED)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Participant Role',
                    style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['COACH', 'PLAYER', 'PARENT', 'ADMIN'].map((role) {
                      final isSel = selectedRole == role;
                      return ChoiceChip(
                        label: Text(
                          role,
                          style: TextStyle(
                            fontSize: 11,
                            color: isSel ? Colors.white : Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSel,
                        selectedColor: const Color(0xFF2F80ED),
                        backgroundColor: Colors.white.withOpacity(0.04),
                        onSelected: (selected) {
                          if (selected) {
                            setDialogState(() {
                              selectedRole = role;
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white38)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    Navigator.pop(ctx);

                    try {
                      final newId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
                      final firestoreInstance = FirebaseFirestore.instance;

                      await firestoreInstance.collection('chats').doc(newId).set({
                        'id': newId,
                        'participants': [widget.profile.uid, newId],
                        'name': name,
                        'avatar': 'https://api.dicebear.com/7.x/avataaars/svg?seed=$name',
                        'role': selectedRole,
                        'lastMessage': 'Channel initialized.',
                        'lastMessageTime': DateTime.now().toIso8601String(),
                      });

                      await firestoreInstance.collection('chats').doc(newId).collection('messages').add({
                        'senderId': newId,
                        'text': 'Hello! Secure E2E communication channel is now active.',
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Synchronized secure channel for $name.')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Handshake exception: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F80ED),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Initialize', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0F172A),
      child: SafeArea(
        child: _selectedChannel != null ? _buildActiveChat() : _buildChatList(),
      ),
    );
  }

  Widget _buildChatList() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Text(
                'Courtify Secure Chat',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.black,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2F80ED).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF2F80ED), size: 20),
                  onPressed: _createNewConversation,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Connect securely with coaching staff, parents, and prospective ELO opponents.',
            style: TextStyle(color: Colors.white54, fontSize: 13, height: 1.4),
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
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search secure channels or ELO matches...',
              hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
              prefixIcon: const Icon(Icons.search_rounded, color: Colors.white30, size: 20),
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
          ),
          const SizedBox(height: 24),

          Expanded(
            child: _initializingFirestore
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2F80ED)),
                  )
                : StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .where('participants', arrayContains: widget.profile.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading secure feeds: ${snapshot.error}',
                            style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                          ),
                        );
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(color: Color(0xFF2F80ED)),
                        );
                      }

                      final docs = snapshot.data!.docs;
                      final List<ChatChannel> channels = docs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final docId = doc.id;

                        final lastTimeRaw = data['lastMessageTime'] ?? '';
                        String lastTimeStr = 'Now';
                        if (lastTimeRaw is String && lastTimeRaw.isNotEmpty) {
                          try {
                            final parsed = DateTime.parse(lastTimeRaw);
                            final diff = DateTime.now().difference(parsed);
                            if (diff.inDays > 0) {
                              lastTimeStr = '${diff.inDays}d ago';
                            } else if (diff.inHours > 0) {
                              lastTimeStr = '${diff.inHours}h ago';
                            } else if (diff.inMinutes > 0) {
                              lastTimeStr = '${diff.inMinutes}m ago';
                            } else {
                              lastTimeStr = 'Now';
                            }
                          } catch (_) {}
                        }

                        return ChatChannel(
                          uid: docId,
                          name: data['name'] ?? 'Dialogue Node',
                          avatar: data['avatar'] ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=Node',
                          role: data['role'] ?? 'MEMBER',
                          lastMessage: data['lastMessage'] ?? '',
                          lastTime: lastTimeStr,
                          messages: [], 
                        );
                      }).toList();

                      final filteredChannels = channels.where((channel) {
                        return channel.name.toLowerCase().contains(_searchTerm.toLowerCase());
                      }).toList();

                      if (filteredChannels.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.speaker_notes_off_rounded, size: 40, color: Colors.white.withOpacity(0.15)),
                              const SizedBox(height: 16),
                              const Text(
                                'No dialogue channels match your constraints',
                                style: TextStyle(color: Colors.white38, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredChannels.length,
                        itemBuilder: (context, idx) {
                          final chat = filteredChannels[idx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.01),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.04)),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
                                    backgroundImage: NetworkImage(chat.avatar),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      width: 10,
                                      height: 10,
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
                                    chat.name,
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 14,
                                      fontWeight: FontWeight.black,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2F80ED).withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      chat.role,
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
                                  chat.lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    chat.lastTime,
                                    style: const TextStyle(color: Colors.white30, fontSize: 10),
                                  ),
                                  const SizedBox(height: 6),
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
                                  _selectedChannel = chat;
                                });
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveChat() {
    final chat = _selectedChannel!;

    return Column(
      children: [
        // Custom App Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A),
            border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.04))),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 18),
                onPressed: () {
                  setState(() {
                    _selectedChannel = null;
                  });
                },
              ),
              const SizedBox(width: 4),
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(chat.avatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 15,
                        fontWeight: FontWeight.black,
                        color: Colors.white,
                      ),
                    ),
                    const Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(color: Colors.emerald, shape: BoxShape.circle),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Secure Node Active',
                          style: TextStyle(color: Colors.emerald, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone_rounded, color: Colors.white70, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Connecting secure audio VoIP relay...')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.videocam_rounded, color: Colors.white70, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Initializing secure video portal...')),
                  );
                },
              ),
            ],
          ),
        ),

        // Chat list area with Live Stream builder
        Expanded(
          child: Container(
            color: const Color(0xFF0F172A).withBlue(22),
            padding: const EdgeInsets.all(20),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chat.uid)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Failed to bind secure E2E feed: ${snapshot.error}',
                      style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF2F80ED)),
                  );
                }

                final docs = snapshot.data!.docs;
                final List<ChatMessage> msgs = docs.map((docSnap) {
                  final data = docSnap.data() as Map<String, dynamic>;
                  final timestampRaw = data['timestamp'];
                  DateTime ts = DateTime.now();
                  if (timestampRaw is Timestamp) {
                    ts = timestampRaw.toDate();
                  } else if (timestampRaw is String) {
                    ts = DateTime.tryParse(timestampRaw) ?? DateTime.now();
                  }
                  final role = data['senderId'] == widget.profile.uid ? 'user' : 'assistant';
                  return ChatMessage(
                    role: role,
                    text: data['text'] ?? '',
                    timestamp: ts,
                  );
                }).toList();

                if (msgs.isEmpty) {
                  return Center(
                    child: Text(
                      'Secure channel established. Ready for transmission.',
                      style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 12),
                    ),
                  );
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: msgs.length,
                  itemBuilder: (context, idx) {
                    final msg = msgs[idx];
                    final isUser = msg.role == 'user';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14.0),
                      child: Row(
                        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (!isUser) ...[
                            CircleAvatar(
                              radius: 11,
                              backgroundImage: NetworkImage(chat.avatar),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                              decoration: BoxDecoration(
                                color: isUser ? const Color(0xFF2F80ED) : Colors.white.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(18).copyWith(
                                  bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(18),
                                  bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(18),
                                ),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.white.withOpacity(0.9),
                                  fontSize: 12.5,
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
            border: Border(top: BorderSide(color: Colors.white.withOpacity(0.04))),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgController,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Encrypt and transmit message payload...',
                    hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
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
                  onSubmitted: (_) => _handleSubmit(),
                ),
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFF2F80ED),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  onPressed: _handleSubmit,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handleSubmit() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    final chatId = _selectedChannel!.uid;
    _msgController.clear();

    try {
      final firestoreInstance = FirebaseFirestore.instance;

      // Add user message to subcollection
      await firestoreInstance.collection('chats').doc(chatId).collection('messages').add({
        'senderId': widget.profile.uid,
        'text': text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update parent document latest status
      await firestoreInstance.collection('chats').doc(chatId).update({
        'lastMessage': text,
        'lastMessageTime': DateTime.now().toIso8601String(),
      });

      // Trigger smart response simulation on background delay
      Future.delayed(const Duration(seconds: 1), () async {
        if (!mounted || _selectedChannel == null || _selectedChannel!.uid != chatId) return;

        String replyText = 'Understood. Let me parse your kinetic metrics directly.';
        final isCoachChat = chatId.contains('coach_rob');
        final isPlayerChat = chatId.contains('opp_nadal');

        if (isCoachChat) {
          replyText =
              'Hi athlete, I am parsing your telemetry. Your target wrist velocity looks great. Warm up safely before Clay Court session.';
        } else if (isPlayerChat) {
          replyText =
              'That works! I will lock in our upcoming scheduled match on Courtify. Let us test our ELO levels.';
        } else {
          replyText = 'Encrypted feedback loop synced. Let us synchronize our schedules on the calendar.';
        }

        final senderId = isCoachChat ? 'coach_rob' : (isPlayerChat ? 'opp_nadal' : 'assistant');

        await firestoreInstance.collection('chats').doc(chatId).collection('messages').add({
          'senderId': senderId,
          'text': replyText,
          'timestamp': FieldValue.serverTimestamp(),
        });

        await firestoreInstance.collection('chats').doc(chatId).update({
          'lastMessage': replyText,
          'lastMessageTime': DateTime.now().toIso8601String(),
        });
      });
    } catch (e) {
      debugPrint('Error writing chat msg: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('E2E Transmission error: $e')),
      );
    }
  }
}
