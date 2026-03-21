import 'package:flutter/material.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_Page> _pages = [
    _Page(icon: Icons.policy_rounded, title: 'Smart Contract Analysis', description: 'Upload any contract and get instant AI-powered analysis of key terms, obligations, and potential risks.', color: const Color(0xFFE53935)),
    _Page(icon: Icons.shield_rounded, title: 'Risk Assessment', description: 'Comprehensive risk scoring across financial, legal, operational, and compliance dimensions.', color: const Color(0xFFFF5252)),
    _Page(icon: Icons.translate_rounded, title: 'Plain Language', description: 'Complex legal jargon translated into simple, understandable language that anyone can follow.', color: const Color(0xFFFF8A80)),
  ];

  void _goToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0A0E),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topRight,
                child: TextButton(onPressed: _goToHome, child: const Text('Skip', style: TextStyle(color: Color(0xFFE53935), fontSize: 16))),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) {
                  final page = _pages[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140, height: 140,
                          decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [page.color.withOpacity(0.3), page.color.withOpacity(0.05)])),
                          child: Icon(page.icon, size: 70, color: page.color),
                        ),
                        const SizedBox(height: 50),
                        Text(page.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 20),
                        Text(page.description, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400], fontSize: 16, height: 1.6)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: List.generate(_pages.length, (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 8),
                    width: _currentPage == i ? 28 : 10, height: 10,
                    decoration: BoxDecoration(color: _currentPage == i ? const Color(0xFFE53935) : const Color(0xFF2A1F30), borderRadius: BorderRadius.circular(5)),
                  ))),
                  ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) _goToHome();
                      else _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
                    },
                    child: Text(_currentPage == _pages.length - 1 ? 'Get Started' : 'Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Page {
  final IconData icon; final String title; final String description; final Color color;
  _Page({required this.icon, required this.title, required this.description, required this.color});
}
