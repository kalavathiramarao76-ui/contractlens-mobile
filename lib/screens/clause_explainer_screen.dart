import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../widgets/app_widgets.dart';

class ClauseExplainerScreen extends StatefulWidget {
  const ClauseExplainerScreen({super.key});

  @override
  State<ClauseExplainerScreen> createState() => _ClauseExplainerScreenState();
}

class _ClauseExplainerScreenState extends State<ClauseExplainerScreen> {
  final _clauseController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _explain() async {
    if (_clauseController.text.trim().isEmpty) return;
    setState(() { _isLoading = true; _result = ''; });
    final result = await AIService.explainClause(_clauseController.text.trim());
    if (mounted) setState(() { _result = result; _isLoading = false; });
  }

  @override
  void dispose() { _clauseController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0A0E),
      appBar: AppBar(title: const Text('Clause Explainer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlowingCard(
              glowColor: const Color(0xFFFF8A80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.translate_rounded, color: Color(0xFFFF8A80)),
                    SizedBox(width: 10),
                    Text('Clause Explainer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 6),
                  Text('Legal jargon to plain language in seconds', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _clauseController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Paste a legal clause here...\n\nE.g., "Notwithstanding the foregoing..."',
                prefixIcon: Padding(padding: EdgeInsets.only(bottom: 100), child: Icon(Icons.gavel_rounded)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _explain,
                icon: const Icon(Icons.lightbulb_rounded),
                label: Text(_isLoading ? 'Explaining...' : 'Explain in Plain English'),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading || _result.isNotEmpty)
              AIResponseCard(response: _result, isLoading: _isLoading),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Common Clauses', icon: Icons.bookmark_rounded),
            ..._buildCommonClauses(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCommonClauses() {
    final clauses = [
      {'title': 'Force Majeure', 'text': 'Neither party shall be liable for failure to perform due to causes beyond reasonable control, including but not limited to acts of God, war, terrorism, epidemics, or governmental actions.'},
      {'title': 'Indemnification', 'text': 'The indemnifying party agrees to defend, indemnify, and hold harmless the other party from any claims, damages, losses, or expenses arising from breach of this agreement.'},
      {'title': 'Non-Compete', 'text': 'For a period of 24 months following termination, the employee shall not engage in any business competitive with the employer within a 50-mile radius.'},
    ];
    return clauses.map((c) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          _clauseController.text = c['text']!;
          _explain();
        },
        borderRadius: BorderRadius.circular(12),
        child: GlowingCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c['title']!, style: const TextStyle(color: Color(0xFFFF5252), fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 6),
              Text(c['text']!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            ],
          ),
        ),
      ),
    )).toList();
  }
}
