import 'package:flutter/material.dart';
import '../services/ai_service.dart';
import '../widgets/app_widgets.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({super.key});

  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final _contract1Controller = TextEditingController();
  final _contract2Controller = TextEditingController();
  String _result = '';
  bool _isLoading = false;

  Future<void> _compare() async {
    if (_contract1Controller.text.trim().isEmpty || _contract2Controller.text.trim().isEmpty) return;
    setState(() { _isLoading = true; _result = ''; });
    final result = await AIService.compareContracts(_contract1Controller.text.trim(), _contract2Controller.text.trim());
    if (mounted) setState(() { _result = result; _isLoading = false; });
  }

  @override
  void dispose() { _contract1Controller.dispose(); _contract2Controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0A0E),
      appBar: AppBar(title: const Text('Contract Comparison')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GlowingCard(
              glowColor: Colors.orangeAccent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.compare_arrows_rounded, color: Colors.orangeAccent),
                    SizedBox(width: 10),
                    Text('Compare Contracts', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  ]),
                  const SizedBox(height: 6),
                  Text('AI-powered side-by-side contract analysis', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const SectionHeader(title: 'Contract A', icon: Icons.looks_one_rounded),
            TextField(
              controller: _contract1Controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 6,
              decoration: const InputDecoration(hintText: 'Paste first contract or clause...'),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.orangeAccent.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.swap_vert_rounded, color: Colors.orangeAccent, size: 24),
              ),
            ),
            const SizedBox(height: 16),
            const SectionHeader(title: 'Contract B', icon: Icons.looks_two_rounded),
            TextField(
              controller: _contract2Controller,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              maxLines: 6,
              decoration: const InputDecoration(hintText: 'Paste second contract or clause...'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _compare,
                icon: const Icon(Icons.compare_rounded),
                label: Text(_isLoading ? 'Comparing...' : 'Compare Contracts'),
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
}
