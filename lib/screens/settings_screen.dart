import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _riskAlerts = true;
  bool _darkMode = true;
  bool _biometrics = false;
  String _language = 'English';
  String _jurisdiction = 'US Law';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0A0E),
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlowingCard(
              child: Row(
                children: [
                  Container(
                    width: 60, height: 60,
                    decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFFE53935), Color(0xFFB71C1C)])),
                    child: const Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('ContractLens User', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text('Legal Pro Plan', style: TextStyle(color: const Color(0xFFE53935), fontSize: 14)),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFFE53935)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const SectionHeader(title: 'Notifications', icon: Icons.notifications_rounded),
            _buildToggle('Push Notifications', Icons.notifications_active_rounded, _pushNotifications, (v) => setState(() => _pushNotifications = v)),
            _buildToggle('Risk Alerts', Icons.warning_rounded, _riskAlerts, (v) => setState(() => _riskAlerts = v)),

            const SizedBox(height: 20),
            const SectionHeader(title: 'Legal Preferences', icon: Icons.gavel_rounded),
            _buildDropdown('Analysis Language', Icons.language_rounded, _language, ['English', 'Spanish', 'French', 'German', 'Hindi'], (v) => setState(() => _language = v!)),
            _buildDropdown('Jurisdiction', Icons.public_rounded, _jurisdiction, ['US Law', 'UK Law', 'EU Law', 'Indian Law', 'International'], (v) => setState(() => _jurisdiction = v!)),

            const SizedBox(height: 20),
            const SectionHeader(title: 'App Settings', icon: Icons.settings_rounded),
            _buildToggle('Dark Mode', Icons.dark_mode_rounded, _darkMode, (v) => setState(() => _darkMode = v)),
            _buildToggle('Biometric Lock', Icons.fingerprint_rounded, _biometrics, (v) => setState(() => _biometrics = v)),

            const SizedBox(height: 20),
            const SectionHeader(title: 'About', icon: Icons.info_rounded),
            _buildInfoTile('App Version', '1.0.0', Icons.verified_rounded),
            _buildInfoTile('AI Engine', 'GPT-OSS 120B', Icons.auto_awesome_rounded),
            _buildInfoTile('API Endpoint', 'sai.sharedllm.com', Icons.cloud_rounded),

            const SizedBox(height: 30),
            Center(child: Text('ContractLens v1.0.0 - AI Legal Intelligence', style: TextStyle(color: Colors.grey[700], fontSize: 12))),
            const SizedBox(height: 8),
            Center(child: Text('Powered by SharedLLM', style: TextStyle(color: Colors.grey[700], fontSize: 12))),
          ],
        ),
      ),
    );
  }

  Widget _buildToggle(String title, IconData icon, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlowingCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFE53935), size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15))),
            Switch(value: value, onChanged: onChanged, activeColor: const Color(0xFFE53935)),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String title, IconData icon, String value, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlowingCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFE53935), size: 22),
            const SizedBox(width: 14),
            Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15))),
            DropdownButton<String>(
              value: value, dropdownColor: const Color(0xFF141018),
              style: const TextStyle(color: Color(0xFFE53935)), underline: const SizedBox(),
              items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: GlowingCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFFE53935), size: 22),
            const SizedBox(width: 14),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 15)),
            const Spacer(),
            Text(value, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
