import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_profile.dart';

class LoginScreen extends StatefulWidget {
  final Function(UserProfile) onLoginSuccess;

  const LoginScreen({Key? key, required this.onLoginSuccess}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _name = '';
  UserRole _selectedRole = UserRole.player;
  bool _showPassword = false;
  bool _loading = false;
  String _errorMessage = '';

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      // Simulate/Implement Firebase Auth / DB SetDoc
      await Future.delayed(const Duration(milliseconds: 1500)); // Network delay

      final profile = UserProfile(
        uid: 'f_user_${DateTime.now().millisecondsSinceEpoch}',
        email: _email,
        name: _isLogin ? (_email.split('@').first) : _name,
        role: _selectedRole,
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=$_email',
        onboardingCompleted: false,
      );

      widget.onLoginSuccess(profile);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _googleSignIn() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      final profile = UserProfile(
        uid: 'f_google_user_999',
        email: 'athlete.elite@gmail.com',
        name: 'Alex Rivera',
        role: UserRole.player,
        avatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Alex',
        onboardingCompleted: false,
      );
      widget.onLoginSuccess(profile);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Slate 900
      body: Stack(
        children: [
          // Background illustration image and gradient (Dribbble style)
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.network(
                'https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?auto=format&fit=crop&q=80',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Colors.transparent, Color(0xFF2F80ED)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // App logo
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF2F80ED), Color(0xFF4F46E5)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _isLogin ? 'Welcome Back Elite' : 'Create Elite Profile',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isLogin ? 'Sign in to access neural performance' : 'Join the elite athletic ecosystem',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (_errorMessage.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.bottom(16),
                            decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _errorMessage,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!_isLogin) ...[
                                TextFormField(
                                  style: const TextStyle(color: Colors.white),
                                  decoration: _inputDecoration('Full Name', Icons.person_outline),
                                  validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                                  onSaved: (v) => _name = v ?? '',
                                ),
                                const SizedBox(height: 16),
                                // Role Selector Tabs
                                Text(
                                  'SELECT YOUR ROLE',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2,
                                    color: Colors.white54,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 2.2,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    _roleTab(UserRole.player, 'Player', Icons.sports_tennis_rounded),
                                    _roleTab(UserRole.coach, 'Coach', Icons.military_tech_rounded),
                                    _roleTab(UserRole.parent, 'Parent', Icons.supervisor_account_rounded),
                                    _roleTab(UserRole.admin, 'Admin', Icons.admin_panel_settings_rounded),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration('Email Address', Icons.mail_outline),
                                validator: (v) => v == null || !v.contains('@') ? 'Enter a valid email' : null,
                                onSaved: (v) => _email = v ?? '',
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                obscureText: !_showPassword,
                                style: const TextStyle(color: Colors.white),
                                decoration: _inputDecoration('Password', Icons.lock_outline).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                                      color: Colors.white60,
                                    ),
                                    onPressed: () => setState(() => _showPassword = !_showPassword),
                                  ),
                                ),
                                validator: (v) => v == null || v.length < 6 ? 'Password min 6 chars' : null,
                                onSaved: (v) => _password = v ?? '',
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: _loading ? null : _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2F80ED),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 8,
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : Text(
                                        _isLogin ? 'SIGN IN' : 'INITIALIZE BASELINE',
                                        style: GoogleFonts.inter(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                                      ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white.withOpacity(0.12))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text('OR', style: GoogleFonts.inter(fontSize: 12, color: Colors.white38)),
                            ),
                            Expanded(child: Divider(color: Colors.white.withOpacity(0.12))),
                          ],
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: _loading ? null : _googleSignIn,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white.withOpacity(0.12)),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon: Image.network(
                            'https://g.gravatar.com/avatar/6c5a5cc7103a07af11b93fefb09819ee?s=24&d=retro', // placeholder for google icon or standard network icon
                            width: 18,
                            height: 18,
                            errorBuilder: (c, o, s) => const Icon(Icons.g_mobiledata_rounded, size: 24),
                          ),
                          label: Text(
                            'Continue with Google',
                            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          child: Text(
                            _isLogin ? 'New to Courtify? Create Elite Account' : 'Already have an account? Sign In',
                            style: GoogleFonts.inter(color: const Color(0xFF2F80ED), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white65),
      prefixIcon: Icon(icon, color: Colors.white60),
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF2F80ED), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }

  Widget _roleTab(UserRole role, String label, IconData icon) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F80ED).withOpacity(0.15) : Colors.white.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF2F80ED) : Colors.white.withOpacity(0.08),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isSelected ? const Color(0xFF2F80ED) : Colors.white60),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.black : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
