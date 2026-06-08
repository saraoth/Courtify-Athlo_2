import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../models/app_state.dart';
import '../../models/theme_provider.dart';
import '../../models/security_provider.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile profile;
  final Function(UserProfile) onProfileUpdate;
  final VoidCallback? onLogout;

  const ProfileScreen({
    Key? key,
    required this.profile,
    required this.onProfileUpdate,
    this.onLogout,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AppStateStore _stateStore = AppStateStore();
  final _formKey = GlobalKey<FormState>();

  // Edit fields controllers
  late TextEditingController _nameController;
  late TextEditingController _avatarController;
  late TextEditingController _availabilityController;

  bool _isEditing = false;
  late String _selectedSkill;
  late List<String> _selectedSports;
  late UserRole _selectedRole;

  // Preset avatar options for convenient choice
  final List<Map<String, String>> _avatarPresets = [
    {
      'name': 'Robert',
      'url': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Robert',
    },
    {
      'name': 'Carlos',
      'url': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Carlos',
    },
    {
      'name': 'Sarah',
      'url': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Sarah',
    },
    {
      'name': 'Alex',
      'url': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alex',
    },
    {
      'name': 'Huda',
      'url': 'https://api.dicebear.com/7.x/avataaars/svg?seed=Huda',
    },
    {
      'name': 'Coach',
      'url': 'https://api.dicebear.com/7.x/avataaars/svg?seed=coach',
    },
  ];

  final List<String> _skillLevels = ['beginner', 'intermediate', 'advanced', 'pro'];
  final List<String> _availableSports = ['Tennis', 'Padel', 'Basketball', 'Fitness'];

  @override
  void initState() {
    super.initState();
    _initFields();
  }

  void _initFields() {
    _nameController = TextEditingController(text: widget.profile.name);
    _avatarController = TextEditingController(text: widget.profile.avatar ?? '');
    _availabilityController = TextEditingController(text: widget.profile.availability ?? 'Flexible');
    _selectedSkill = widget.profile.skillLevel?.toLowerCase() ?? 'beginner';
    _selectedSports = widget.profile.sports != null ? List<String>.from(widget.profile.sports!) : [];
    _selectedRole = widget.profile.role;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _avatarController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updatedProfile = widget.profile.copyWith(
        name: _nameController.text.trim(),
        avatar: _avatarController.text.trim().isNotEmpty ? _avatarController.text.trim() : null,
        role: _selectedRole,
        skillLevel: _selectedSkill,
        sports: _selectedSports.isNotEmpty ? _selectedSports : null,
        availability: _availabilityController.text.trim(),
      );

      widget.onProfileUpdate(updatedProfile);

      // Log the profile update event in the dynamic system state
      _stateStore.logAction(
        'PROFILE_UPDATE',
        'Account profile modified for ${updatedProfile.name} (${updatedProfile.role.toString().split('.').last.toUpperCase()}).',
        Colors.cyanAccent,
      );

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF10B981),
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Sports Club Profile Saved!',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24, bottom: 40),
          child: _isEditing ? _buildEditWorkspace() : _buildProfileView(),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    final hasSports = widget.profile.sports != null && widget.profile.sports!.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? Colors.white45 : const Color(0xFF475569);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.between,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2F80ED),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'MEMBER CARD',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F80ED),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Sports Club Profile',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 28,
                    fontWeight: FontWeight.black,
                    color: textColor,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _initFields(); // reset to current profile values before editing
                  _isEditing = true;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F80ED).withOpacity(0.12),
                foregroundColor: const Color(0xFF2F80ED),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: const Color(0xFF2F80ED).withOpacity(0.2)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: Text(
                'Edit Account',
                style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.black),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // Core Profile Layout Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      Colors.white.withOpacity(0.015),
                      Colors.white.withOpacity(0.005),
                    ]
                  : [
                      Colors.black.withOpacity(0.02),
                      Colors.black.withOpacity(0.005),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.06),
            ),
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 64,
                backgroundColor: const Color(0xFF2F80ED).withOpacity(0.1),
                child: CircleAvatar(
                  radius: 58,
                  backgroundColor: const Color(0xFF2F80ED).withOpacity(0.2),
                  backgroundImage: NetworkImage(
                    widget.profile.avatar ?? 'https://api.dicebear.com/7.x/avataaars/svg?seed=${widget.profile.name}',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.profile.name,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 26,
                  fontWeight: FontWeight.black,
                  color: textColor,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.profile.email,
                style: GoogleFonts.inter(
                  color: subTextColor,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F80ED).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF2F80ED).withOpacity(0.3),
                  ),
                ),
                child: Text(
                  widget.profile.role.toString().split('.').last.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    color: const Color(0xFF2F80ED),
                    fontWeight: FontWeight.black,
                    fontSize: 11,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        Text(
          'Athletic Calibration Details',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.black,
            color: textColor,
          ),
        ),
        const SizedBox(height: 14),

        _infoCard(
          Icons.sports_rounded,
          'Sports Disciplines',
          hasSports
              ? widget.profile.sports!.map((s) => s.toUpperCase()).join(' • ')
              : 'NO SPORT DESIGNATED',
          const Color(0xFF10B981),
        ),
        _infoCard(
          Icons.psychology_rounded,
          'Skill Matrix Level',
          widget.profile.skillLevel?.toUpperCase() ?? 'NONE CONFIG',
          const Color(0xFF2F80ED),
        ),
        _infoCard(
          Icons.calendar_month_rounded,
          'Reservations Availability',
          widget.profile.availability ?? 'Flexible Schedule',
          const Color(0xFFEC4899),
        ),
        _infoCard(
          Icons.vpn_key_rounded,
          'Federated User ID',
          widget.profile.uid,
          Colors.amber,
        ),

        // System Preferences Section (Dynamic Theme Switching Widget)
        const SizedBox(height: 28),
        Text(
          'System Workspace Preferences',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.black,
            color: textColor,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.015) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.08),
            ),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2F80ED).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDark ? Icons.brightness_4_rounded : Icons.brightness_7_rounded,
                  color: const Color(0xFF2F80ED),
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THEME SETUP',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2F80ED),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isDark ? 'Dark Mode Active' : 'Light Mode Active',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        fontWeight: FontWeight.black,
                        color: isDark ? Colors.white.withOpacity(0.9) : const Color(0xFF1F2937),
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: isDark,
                activeColor: const Color(0xFF10B981),
                onChanged: (val) {
                  Provider.of<ThemeProvider>(context, listen: false).setDarkMode(val);
                },
              ),
            ],
          ),
        ),

        // Biometric Security Workspace Settings
        const SizedBox(height: 12),
        Consumer<SecurityProvider>(
          builder: (context, securityProvider, child) {
            final isLockSet = securityProvider.isBiometricSet;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.015) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.08),
                    ),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.fingerprint_rounded,
                              color: Color(0xFF10B981),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'BIOMETRIC GAUNTLET',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF10B981),
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  isLockSet ? 'Biometric Lock Active' : 'Unsecured Workspace',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 14,
                                    fontWeight: FontWeight.black,
                                    color: isDark ? Colors.white.withOpacity(0.9) : const Color(0xFF1F2937),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: isLockSet,
                            activeColor: const Color(0xFF10B981),
                            onChanged: (val) async {
                              bool updated = await securityProvider.toggleBiometricLock(val);
                              if (!updated && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.redAccent,
                                    content: Text(
                                      'Security credentials validation failed.',
                                      style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      if (isLockSet) ...[
                        const Divider(height: 24, thickness: 1, color: Colors.white10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.between,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FALLBACK PIN CODE',
                                  style: GoogleFonts.inter(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white38 : Colors.black45,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Value: ••••  (Default: 1234)',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? Colors.white70 : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            TextButton.icon(
                              onPressed: _showChangePinDialog,
                              icon: const Icon(Icons.pin_rounded, size: 14, color: Color(0xFF2F80ED)),
                              label: Text(
                                'CALIBRATE CODE',
                                style: GoogleFonts.spaceGrotesk(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2F80ED),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                
                if (isLockSet) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        securityProvider.lockWorkspace();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF2F80ED),
                            content: Text(
                              'Secure sports container locked successfully!',
                              style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F80ED).withOpacity(0.12),
                        foregroundColor: const Color(0xFF2F80ED),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: const Color(0xFF2F80ED).withOpacity(0.2)),
                        ),
                      ),
                      icon: const Icon(Icons.lock_outline_rounded, size: 18),
                      label: Text(
                        'Lock System Workspace Now',
                        style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ]
              ],
            );
          },
        ),

        if (widget.onLogout != null) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.12),
                foregroundColor: Colors.redAccent,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.2)),
                ),
              ),
              icon: const Icon(Icons.logout_rounded),
              label: Text(
                'Log Out From System Workspace',
                style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _infoCard(IconData icon, String title, String value, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.015) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.08),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black45,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.black,
                      color: isDark ? Colors.white.withOpacity(0.9) : const Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditWorkspace() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subTextColor = isDark ? Colors.white54 : const Color(0xFF475569);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CALIBRATE PROFILE',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFEC4899),
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Modify Account',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 28,
                      fontWeight: FontWeight.black,
                      color: textColor,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close_rounded, color: isDark ? Colors.white54 : Colors.black54),
                    onPressed: () {
                      setState(() {
                        _isEditing = false;
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.spaceGrotesk(fontSize: 12, fontWeight: FontWeight.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Name field
          Text(
            'Full Name',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: _inputDecoration('Alex Rover', Icons.person_outline_rounded, isDark),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please specify a valid account name';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Preset Avatars header
          Text(
            'Choose Preset Bio-Avatar',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 72,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _avatarPresets.length,
              itemBuilder: (context, idx) {
                final preset = _avatarPresets[idx];
                final isSelected = _avatarController.text == preset['url'];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _avatarController.text = preset['url']!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? const Color(0xFF2F80ED) : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: isDark ? Colors.white10 : Colors.black.withOpacity(0.04),
                      backgroundImage: NetworkImage(preset['url']!),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Custom Avatar URL override
          Text(
            'Or Paste Custom Avatar Vector URL',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _avatarController,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: _inputDecoration('https://api.dicebear.com/7.x/avataaars/svg...', Icons.link_rounded, isDark),
          ),
          const SizedBox(height: 24),

          // Availability Delivery
          Text(
            'Availability Delivery Schedule',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _availabilityController,
            style: TextStyle(color: textColor, fontSize: 14),
            decoration: _inputDecoration('Flexible / Weeknights / Weekends', Icons.schedule_rounded, isDark),
          ),
          const SizedBox(height: 24),

          // Skill Matrix Selector Dropdown
          Text(
            'Skill Matrix Calibration Level',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.015) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.12)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSkill,
                dropdownColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                icon: Icon(Icons.arrow_drop_down_rounded, color: isDark ? Colors.white70 : Colors.black54),
                isExpanded: true,
                style: TextStyle(color: textColor, fontSize: 14),
                onChanged: (String? val) {
                  if (val != null) {
                    setState(() {
                      _selectedSkill = val;
                    });
                  }
                },
                items: _skillLevels.map((String level) {
                  return DropdownMenuItem<String>(
                    value: level,
                    child: Text(
                      level.toUpperCase(),
                      style: TextStyle(color: textColor),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Workspace Environment Role
          Text(
            'Workspace Environment Role',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.015) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.12)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<UserRole>(
                value: _selectedRole,
                dropdownColor: isDark ? const Color(0xFF0F172A) : Colors.white,
                icon: Icon(Icons.arrow_drop_down_rounded, color: isDark ? Colors.white70 : Colors.black54),
                isExpanded: true,
                style: TextStyle(color: textColor, fontSize: 14),
                onChanged: (UserRole? val) {
                  if (val != null) {
                    setState(() {
                      _selectedRole = val;
                    });
                  }
                },
                items: UserRole.values.map((UserRole role) {
                  return DropdownMenuItem<UserRole>(
                    value: role,
                    child: Text(
                      role.toString().split('.').last.toUpperCase(),
                      style: TextStyle(color: textColor),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Sports selection tags
          Text(
            'Registered Sports Clubs Specializations',
            style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold, fontSize: 13, color: textColor),
          ),
          const SizedBox(height: 4),
          Text(
            'Toggle sports to customize your dynamic interactive dashboards.',
            style: TextStyle(color: subTextColor, fontSize: 11),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _availableSports.map((sport) {
              final isSelected = _selectedSports.contains(sport) ||
                  _selectedSports.contains(sport.toLowerCase());
              // Handle match for both capitalized/lowercase list variables
              final matchStr = _selectedSports.firstWhere(
                (s) => s.toLowerCase() == sport.toLowerCase(),
                orElse: () => '',
              );

              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (matchStr.isNotEmpty) {
                      _selectedSports.remove(matchStr);
                    } else {
                      _selectedSports.add(sport);
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                  decoration: BoxDecoration(
                    color: matchStr.isNotEmpty
                        ? const Color(0xFF2F80ED).withOpacity(0.12)
                        : (isDark ? Colors.white.withOpacity(0.015) : Colors.black.withOpacity(0.02)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: matchStr.isNotEmpty
                          ? const Color(0xFF2F80ED)
                          : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.12)),
                      width: matchStr.isNotEmpty ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (matchStr.isNotEmpty) ...[
                        const Icon(Icons.check_rounded, color: Color(0xFF2F80ED), size: 14),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        sport.toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: matchStr.isNotEmpty ? const Color(0xFF2F80ED) : subTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hintext, IconData icon, bool isDark) {
    return InputDecoration(
      hintText: hintext,
      hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black38, fontSize: 13),
      prefixIcon: Icon(icon, color: isDark ? Colors.white30 : Colors.black38, size: 18),
      filled: true,
      fillColor: isDark ? Colors.white.withOpacity(0.015) : Colors.black.withOpacity(0.01),
      contentPadding: const EdgeInsets.all(18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.1)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2F80ED)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }

  void _showChangePinDialog() {
    final securityProvider = Provider.of<SecurityProvider>(context, listen: false);
    final textController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Calibrate Security PIN',
            style: GoogleFonts.spaceGrotesk(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Set a 4-digit fallback passcode to unlock your workspace in case biometrics are unavailable on your desktop/browser.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: textController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  maxLength: 4,
                  style: TextStyle(
                    color: textColor,
                    letterSpacing: 8,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '••••',
                    hintStyle: TextStyle(color: isDark ? Colors.white24 : Colors.black26),
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.015) : Colors.black.withOpacity(0.02),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.12)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2F80ED)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().length != 4 || int.tryParse(value) == null) {
                      return 'Please input exactly 4 numerical digits';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.black,
                  fontSize: 11,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  securityProvider.setFallbackPin(textController.text.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF10B981),
                      content: Text(
                        'Secured Fallback PIN calibrated successfully!',
                        style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                'CONFIRM PIN',
                style: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.black,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
