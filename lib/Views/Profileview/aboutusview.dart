import 'package:designerdigger/Utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  static const _features = [
    (
      icon: Icons.restaurant_menu_outlined,
      title: 'Browse the Menu',
      description:
          'Explore burgers, pizza, ice cream, and more from our fast food collection.',
    ),
    (
      icon: Icons.shopping_cart_outlined,
      title: 'Easy Ordering',
      description:
          'Add items to your cart and checkout in just a few taps.',
    ),
    (
      icon: Icons.favorite_outline,
      title: 'Favorites',
      description:
          'Save your go-to meals for quick access whenever you order again.',
    ),
    (
      icon: Icons.person_outline,
      title: 'Personalized Profile',
      description:
          'Register, sign in, and customize your profile for a tailored experience.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageColor = isDark ? darkbackgroundclr : lgreyclr;
    final cardColor = isDark ? ldarkbackgroundclr : whiteclr;
    final textColor = isDark ? whiteclr : blackclr;

    return Scaffold(
      backgroundColor: pageColor,
      appBar: AppBar(
        backgroundColor: onboardingclr,
        foregroundColor: whiteclr,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'About Us',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [onboardingclr, lonboardingclr],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: whiteclr.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/Untitled_design__1_-removebg-preview.png',
                    height: 72,
                    width: 72,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Designer Digger',
                  style: TextStyle(
                    color: whiteclr,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Fast food delivery, made simple',
                  style: TextStyle(
                    color: whiteclr.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Our Story',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Designer Digger is a Flutter-based food delivery app built to make ordering fast food quick, easy, and enjoyable. Whether you are craving burgers, pizza, or ice cream, we bring your favorites to your fingertips with a clean, modern experience.',
            style: TextStyle(
              fontSize: 15,
              height: 1.55,
              color: greyclr.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'What You Can Do',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ..._features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _FeatureCard(
                color: cardColor,
                icon: feature.icon,
                title: feature.title,
                description: feature.description,
                isDark: isDark,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: onboardingclr.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.info_outline,
                    color: onboardingclr,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Version 1.0.0',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => context.push('/contactusview'),
              icon: const Icon(Icons.mail_outline),
              label: const Text('Contact Us'),
              style: OutlinedButton.styleFrom(
                foregroundColor: onboardingclr,
                side: const BorderSide(color: onboardingclr),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final bool isDark;

  const _FeatureCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: onboardingclr.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: onboardingclr, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? whiteclr : blackclr,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: greyclr.withValues(alpha: 0.95),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
