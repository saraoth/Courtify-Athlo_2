import 'package:flutter/material';
import 'package:google_fonts/google_fonts.dart';
import '../models/notification_service.dart';

class NotificationHUDOverlay extends StatefulWidget {
  final Widget child;

  const NotificationHUDOverlay({Key? key, required this.child}) : super(key: key);

  @override
  State<NotificationHUDOverlay> createState() => _NotificationHUDOverlayState();
}

class _NotificationHUDOverlayState extends State<NotificationHUDOverlay> with SingleTickerProviderStateMixin {
  final LocalNotificationService _notifService = LocalNotificationService();
  late AnimationController _hudController;
  late Animation<Offset> _hudOffset;

  NotificationPayload? _currentAlert;

  @override
  void initState() {
    super.initState();
    _hudController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _hudOffset = Tween<Offset>(
      begin: const Offset(0.0, -1.8),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _hudController,
      curve: Curves.elasticOut,
    ));

    _notifService.addListener(_handleNotificationUpdate);
  }

  @override
  void dispose() {
    _notifService.removeListener(_handleNotificationUpdate);
    _hudController.dispose();
    super.dispose();
  }

  void _handleNotificationUpdate() {
    final active = _notifService.activeHUDNotification;

    if (active != null && _currentAlert?.id != active.id) {
      if (mounted) {
        setState(() {
          _currentAlert = active;
        });
        _hudController.forward();
      }
    } else if (active == null && _currentAlert != null) {
      if (mounted) {
        _hudController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _currentAlert = null;
            });
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Underneath screen body
        widget.child,

        // High fidelity HUD alert element
        if (_currentAlert != null)
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: SlideTransition(
              position: _hudOffset,
              child: SafeArea(
                child: Center(
                  child: Container(
                    maxWidth: 500, // Look brilliant even on desktop/tablet rails
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.95),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFF2F80ED), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2F80ED).withOpacity(0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Highlight strip indicating sport gradient
                        Container(
                          height: 4,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF2F80ED), Color(0xFF06B6D4), Color(0xFF10B981)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Responsive spinning athletic icon badge
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2F80ED).withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    _getSportEmoji(_currentAlert!.sport),
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2F80ED).withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            'LOCAL ALERT • ${_currentAlert!.sport.toUpperCase()}',
                                            style: GoogleFonts.inter(
                                              fontSize: 8,
                                              letterSpacing: 1,
                                              color: const Color(0xFF2F80ED),
                                              fontWeight: FontWeight.black,
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          'Just Now',
                                          style: GoogleFonts.inter(
                                            fontSize: 9,
                                            color: Colors.white30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      _currentAlert!.title,
                                      style: GoogleFonts.spaceGrotesk(
                                        color: Colors.white,
                                        fontWeight: FontWeight.black,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentAlert!.body,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 11.5,
                                        height: 1.35,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _notifService.markAsRead(_currentAlert!.id);
                                            _notifService.clearHUD();
                                          },
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.white38,
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                          ),
                                          child: Text(
                                            'Dismiss',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: () {
                                            _notifService.markAsRead(_currentAlert!.id);
                                            _notifService.clearHUD();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFF2F80ED),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            'Open Details',
                                            style: GoogleFonts.spaceGrotesk(
                                              fontSize: 11,
                                              fontWeight: FontWeight.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
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
    );
  }

  String _getSportEmoji(String sport) {
    switch (sport.toLowerCase()) {
      case 'tennis':
        return '🎾';
      case 'padel':
        return '🏸';
      case 'basketball':
        return '🏀';
      case 'fitness':
        return '🏋️';
      default:
        return '🔔';
    }
  }
}
