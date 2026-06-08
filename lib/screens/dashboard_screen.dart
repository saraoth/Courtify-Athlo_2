import 'package:flutter/material';
import '../models/user_profile.dart';
import '../ui/main_shell.dart';

class DashboardScreen extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onLogout;
  final Function(UserProfile) onProfileUpdate;

  const DashboardScreen({
    Key? key,
    required this.profile,
    required this.onLogout,
    required this.onProfileUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainShell(
      profile: profile,
      onLogout: onLogout,
      onProfileUpdate: onProfileUpdate,
    );
  }
}
