import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../widgets/app_widgets.dart';

class AnalyzerScreen extends StatefulWidget {
  const AnalyzerScreen({super.key});

  @override
  State<AnalyzerScreen> createState() => _AnalyzerScreenState();
}

class _AnalyzerScreenState extends State<AnalyzerScreen> {
  final _contractController = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _analyze() async {
    if (_contractController.text.trim().isEmpty) return;
    setState(() { _isLoading = true; _result = ''; });
    final result = await AIService.analyzeContract(_contractController.text.trim());
    if (mounted) setState(() { _result = result; _isLoading = false; });
  }

  @override
  void dispose() { _contractController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0A0E),
      appBar: AppBar(title: const Text('Contract Analyzer')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlowingCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.description_rounded, color: Color(0xFFFF5252)),
                    SizedBox(width: 10),
                    Text('Analyze Contract', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 6),
                  Text('Paste contract text for comprehensive AI analysis', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contractController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 10,
              decoration: const InputDecoration(
                hintText: 'Paste your contract text here...\n\nInclude all clauses, terms, and conditions for comprehensive analysis.',
                prefixIcon: Padding(padding: EdgeInsets.only(bottom: 180), child: Icon(Icons.article_rounded)),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _analyze,
                icon: const Icon(Icons.search_rounded),
                label: Text(_isLoading ? 'Analyzing...' : 'Analyze Contract'),
              ),
            ),
            const SizedBox(height: 24),
            if (_isLoading || _result.isNotEmpty)
              AIResponseCard(response: _result, isLoading: _isLoading),
            const SizedBox(height: 24),
            const SectionHeader(title: 'Quick Templates', icon: Icons.bookmark_rounded),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: ['NDA', 'Employment', 'SaaS License', 'Lease', 'Freelance', 'Partnership'].map((tag) {
                return ActionChip(
                  label: Text(tag),
                  labelStyle: const TextStyle(color: Color(0xFFE53935), fontSize: 13),
                  backgroundColor: const Color(0xFF141018),
                  side: const BorderSide(color: Color(0xFF2A1F30)),
                  onPressed: () {
                    _contractController.text = 'This is a sample $tag agreement between Party A and Party B. Please analyze the key terms, obligations, and potential risks.';
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
