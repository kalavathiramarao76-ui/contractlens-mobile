import 'package:flutter/material.dart';

class GlowingCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const GlowingCard({
    super.key,
    required this.child,
    this.glowColor = const Color(0xFFE53935),
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF141018),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: glowColor.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.06),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = const Color(0xFFE53935),
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return GlowingCard(
      glowColor: color,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(value, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w500)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle!, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const FeatureButton({
    super.key,
    required this.label,
    required this.icon,
    this.color = const Color(0xFFE53935),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: GlowingCard(
        glowColor: color,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class AIResponseCard extends StatelessWidget {
  final String response;
  final bool isLoading;

  const AIResponseCard({super.key, required this.response, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return GlowingCard(
      glowColor: const Color(0xFFE53935),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.gavel_rounded, color: Color(0xFFFF5252), size: 18),
              ),
              const SizedBox(width: 10),
              const Text('ContractLens AI', style: TextStyle(color: Color(0xFFFF5252), fontSize: 15, fontWeight: FontWeight.w700)),
              const Spacer(),
              if (isLoading)
                const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFE53935))),
            ],
          ),
          const SizedBox(height: 14),
          if (isLoading)
            ...List.generate(4, (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                height: 14,
                width: [280.0, 240.0, 260.0, 180.0][i],
                decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)),
              ),
            ))
          else
            Text(response, style: const TextStyle(color: Color(0xFFD1C4D8), fontSize: 14, height: 1.6)),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.icon, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: const Color(0xFFE53935), size: 20),
            const SizedBox(width: 8),
          ],
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class RiskBadge extends StatelessWidget {
  final String level;

  const RiskBadge({super.key, required this.level});

  Color get _color {
    switch (level.toLowerCase()) {
      case 'high': return Colors.redAccent;
      case 'medium': return Colors.orangeAccent;
      case 'low': return Colors.greenAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Text(
        level.toUpperCase(),
        style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1),
      ),
    );
  }
}
