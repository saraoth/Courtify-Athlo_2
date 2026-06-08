import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/security_provider.dart';

class BiometricGate extends StatefulWidget {
  const BiometricGate({Key? key}) : super(key: key);

  @override
  State<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<BiometricGate> {
  final List<String> _enteredPin = [];
  bool _pinError = false;

  @override
  void initState() {
    super.initState();
    // Auto-trigger biometric authentication dialog upon rendering for excellent UX
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerBiometricAuth();
    });
  }

  Future<void> _triggerBiometricAuth() async {
    final securityProvider = Provider.of<SecurityProvider>(context, listen: false);
    bool validated = await securityProvider.authenticate(
      'Verify biometric ID to grant access to sports statistics and reservation logs.',
    );
    if (validated) {
      // Unlocked successfully!
      securityProvider.unlockWithSuccess();
    }
  }

  void _onKeyPress(String val) {
    if (_enteredPin.length < 4) {
      setState(() {
        _pinError = false;
        _enteredPin.add(val);
      });

      if (_enteredPin.length == 4) {
        _verifyPin();
      }
    }
  }

  void _onBackspace() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _pinError = false;
        _enteredPin.removeLast();
      });
    }
  }

  void _verifyPin() {
    final securityProvider = Provider.of<SecurityProvider>(context, listen: false);
    final pinStr = _enteredPin.join();
    if (securityProvider.verifyFallbackPin(pinStr)) {
      // Unlocked!
    } else {
      setState(() {
        _pinError = true;
        _enteredPin.clear();
      });
      // Small feedback vibration can be simulated/audited
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.redAccent,
          content: Text(
            'INCORRECT PIN CODE. SECURED GATEWAYS ACTIVE.',
            style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final securityProvider = Provider.of<SecurityProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryBlue = Colors.blueAccent;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Animated lock shield node
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2F80ED).withOpacity(0.08),
                  border: Border.all(
                    color: const Color(0xFF2F80ED).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.fingerprint_rounded,
                    size: 54,
                    color: _pinError ? Colors.redAccent : const Color(0xFF2F80ED),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'WORKSPACE GATEWAY',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.5,
                  color: const Color(0xFF2F80ED),
                ),
              ),
              const SizedBox(height: 8),
              
              Text(
                'Verify Athlete Credentials',
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.black,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'This device profile is secured with biometric locking. Use Touch/Face ID or input the 4-digit safety credentials code to proceed.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isDark ? Colors.white38 : Colors.black45,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Biometric Trigger Button
              ElevatedButton.icon(
                onPressed: _triggerBiometricAuth,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981).withOpacity(0.12),
                  foregroundColor: const Color(0xFF10B981),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  side: BorderSide(color: const Color(0xFF10B981).withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                icon: const Icon(Icons.face_retouching_natural_rounded, size: 20),
                label: Text(
                  'SCAN BIOMETRIC CONTROLS',
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.black,
                    fontSize: 11,
                    letterSpacing: 1.0,
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // PIN Indicator dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  final isFilled = index < _enteredPin.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _pinError 
                          ? Colors.redAccent 
                          : isFilled 
                              ? const Color(0xFF2F80ED) 
                              : Colors.transparent,
                      border: Border.all(
                        color: _pinError 
                            ? Colors.redAccent 
                            : isFilled 
                                ? const Color(0xFF2F80ED) 
                                : isDark ? Colors.white24 : Colors.black26,
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 36),

              // Glassmorphic Numerical Keyboard Grid
              Container(
                maxWidth: 280,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      // Clear / Option button
                      return Container();
                    } else if (index == 10) {
                      // '0' button
                      return _buildKeypadButton('0');
                    } else if (index == 11) {
                      // Backspace button
                      return _buildBackspaceButton();
                    } else {
                      // '1' to '9' buttons
                      return _buildKeypadButton('${index + 1}');
                    }
                  },
                ),
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String digit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => _onKeyPress(digit),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.015) : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Center(
          child: Text(
            digit,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: _onBackspace,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.015) : Colors.black.withOpacity(0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.06),
          ),
        ),
        child: Center(
          child: Icon(
            Icons.backspace_outlined,
            size: 20,
            color: isDark ? Colors.white70 : Colors.black70,
          ),
        ),
      ),
    );
  }
}
