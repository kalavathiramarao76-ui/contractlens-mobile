import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../widgets/app_widgets.dart';

class RiskScorerScreen extends StatefulWidget {
  const RiskScorerScreen({super.key});

  @override
  State<RiskScorerScreen> createState() => _RiskScorerScreenState();
}

class _RiskScorerScreenState extends State<RiskScorerScreen> {
  final _contractController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _scoreRisk() async {
    if (_contractController.text.trim().isEmpty) return;
    setState(() { _isLoading = true; _result = ''; });
    final result = await AIService.scoreRisk(_contractController.text.trim());
    if (mounted) setState(() { _result = result; _isLoading = false; });
  }

  @override
  void dispose() { _contractController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0A0E),
      appBar: AppBar(title: const Text('Risk Scorer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlowingCard(
              glowColor: const Color(0xFFFF5252),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.shield_rounded, color: Color(0xFFFF5252)),
                    SizedBox(width: 10),
                    Text('Contract Risk Scorer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 6),
                  Text('AI-powered multi-dimensional risk assessment', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Risk categories
            const SectionHeader(title: 'Risk Categories', icon: Icons.category_rounded),
            Row(
              children: [
                _buildRiskCategory('Financial', Icons.account_balance_rounded, Colors.redAccent),
                const SizedBox(width: 10),
                _buildRiskCategory('Legal', Icons.gavel_rounded, Colors.orangeAccent),
                const SizedBox(width: 10),
                _buildRiskCategory('Operational', Icons.settings_rounded, Colors.amberAccent),
                const SizedBox(width: 10),
                _buildRiskCategory('Compliance', Icons.verified_rounded, Colors.greenAccent),
              ],
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _contractController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Paste contract text for risk assessment...',
                prefixIcon: Padding(padding: EdgeInsets.only(bottom: 140), child: Icon(Icons.article_rounded)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _scoreRisk,
                icon: const Icon(Icons.shield_rounded),
                label: Text(_isLoading ? 'Scoring...' : 'Score Risk'),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading || _result.isNotEmpty)
              AIResponseCard(response: _result, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskCategory(String label, IconData icon, Color color) {
    return Expanded(
      child: GlowingCard(
        glowColor: color,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
