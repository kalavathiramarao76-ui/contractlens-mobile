import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';
import '../widgets/auth_wall.dart';
import '../services/auth_service.dart';
import 'analyzer_screen.dart';
import 'risk_scorer_screen.dart';
import 'clause_explainer_screen.dart';
import 'comparison_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AuthService _authService = AuthService();
  bool _showAuthWall = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final needsAuth = await _authService.needsAuth();
    if (mounted) setState(() => _showAuthWall = needsAuth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0A0E),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: const [
              _HomeContent(),
              AnalyzerScreen(),
              RiskScorerScreen(),
              ClauseExplainerScreen(),
              SettingsScreen(),
            ],
          ),
          if (_showAuthWall)
            AuthWall(
              authService: _authService,
              onSignedIn: () => setState(() => _showAuthWall = false),
            ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) async {
          await _authService.incrementUsage();
          await _checkAuth();
          if (!_showAuthWall) setState(() => _selectedIndex = i);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.description_rounded), label: 'Analyze'),
          NavigationDestination(icon: Icon(Icons.shield_rounded), label: 'Risk'),
          NavigationDestination(icon: Icon(Icons.translate_rounded), label: 'Explain'),
          NavigationDestination(icon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('ContractLens', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text('AI Legal Intelligence', style: TextStyle(color: const Color(0xFFE53935), fontSize: 14, fontWeight: FontWeight.w500)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF141018), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF2A1F30))),
                  child: const Icon(Icons.policy_rounded, color: Color(0xFFFF5252), size: 28),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(child: StatCard(label: 'Contracts Analyzed', value: '1,284', icon: Icons.description_rounded)),
                const SizedBox(width: 14),
                Expanded(child: StatCard(label: 'Risks Found', value: '347', icon: Icons.warning_rounded, color: const Color(0xFFFF5252), subtitle: '27% rate')),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: StatCard(label: 'Clauses Explained', value: '5.2K', icon: Icons.translate_rounded, color: const Color(0xFFFF8A80))),
                const SizedBox(width: 14),
                Expanded(child: StatCard(label: 'Comparisons', value: '892', icon: Icons.compare_rounded, color: Colors.orangeAccent)),
              ],
            ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Quick Actions', icon: Icons.flash_on_rounded),
            const SizedBox(height: 8),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.15,
              children: [
                FeatureButton(label: 'Contract\nAnalyzer', icon: Icons.description_rounded, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyzerScreen()))),
                FeatureButton(label: 'Risk\nScorer', icon: Icons.shield_rounded, color: const Color(0xFFFF5252), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RiskScorerScreen()))),
                FeatureButton(label: 'Clause\nExplainer', icon: Icons.translate_rounded, color: const Color(0xFFFF8A80), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClauseExplainerScreen()))),
                FeatureButton(label: 'Contract\nComparison', icon: Icons.compare_arrows_rounded, color: Colors.orangeAccent, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComparisonScreen()))),
              ],
            ),
            const SizedBox(height: 28),
            const SectionHeader(title: 'Recent Activity', icon: Icons.history_rounded),
            ..._buildRecentItems(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRecentItems() {
    final items = [
      {'title': 'NDA Agreement - TechCorp', 'risk': 'Low', 'time': '2 hours ago', 'icon': Icons.handshake_rounded},
      {'title': 'SaaS License Agreement', 'risk': 'Medium', 'time': '5 hours ago', 'icon': Icons.computer_rounded},
      {'title': 'Employment Contract', 'risk': 'High', 'time': '1 day ago', 'icon': Icons.person_rounded},
    ];
    return items.map((item) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlowingCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFE53935).withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(item['icon'] as IconData, color: const Color(0xFFFF5252), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(item['time'] as String, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
            RiskBadge(level: item['risk'] as String),
          ],
        ),
      ),
    )).toList();
  }
}
