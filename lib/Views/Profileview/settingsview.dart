import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/digger_user_service.dart';
import 'package:designerdigger/Utilities/user_document_utils.dart';
import 'package:designerdigger/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageColor = isDark ? darkbackgroundclr : lgreyclr;
    final cardColor = isDark ? ldarkbackgroundclr : whiteclr;

    return Scaffold(
      backgroundColor: pageColor,
      appBar: AppBar(
        backgroundColor: onboardingclr,
        foregroundColor: whiteclr,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: DiggerUserService.profileStream(),
        builder: (context, snapshot) {
          final isAdmin = snapshot.hasError
              ? false
              : UserDocumentUtils.isAdmin(snapshot.data);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              if (isAdmin) ...[
                _SectionTitle(title: 'Admin'),
                _SettingsCard(
                  color: cardColor,
                  children: [
                    _SettingsTile(
                      icon: Icons.campaign_outlined,
                      title: 'Add Promotions',
                      subtitle: 'Create promotional banners',
                      onTap: () => context.push('/addpromotionsview'),
                      showDivider: true,
                    ),
                    _SettingsTile(
                      icon: Icons.restaurant_menu_outlined,
                      title: 'Add Products',
                      subtitle: 'Manage menu items',
                      onTap: () => context.push('/addproductsview'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
              _SectionTitle(title: 'General'),
              _SettingsCard(
                color: cardColor,
                children: [
                  _SettingsTile(
                    icon: Icons.shopping_cart_outlined,
                    title: 'Shopping Cart',
                    subtitle: 'View items in your cart',
                    onTap: () => context.push('/cartview'),
                    showDivider: true,
                  ),
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: 'Dark Mode',
                    subtitle: 'Change app appearance',
                    onTap: () => context.push('/darkview'),
                    showDivider: true,
                  ),
                  _SettingsTile(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    subtitle: 'Learn about Designer Digger',
                    onTap: () => context.push('/aboutusview'),
                    showDivider: true,
                  ),
                  _SettingsTile(
                    icon: Icons.mail_outline,
                    title: 'Contact Us',
                    subtitle: 'Get in touch with support',
                    onTap: () => context.push('/contactusview'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SectionTitle(title: 'Account'),
              _SettingsCard(
                color: cardColor,
                children: [
                  _SettingsTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Sign out of your account',
                    iconColor: Colors.red.shade400,
                    onTap: () async {
                      box.write('islogin', false);
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        context.go('/signin');
                      }
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: greyclr.withValues(alpha: 0.9),
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final Color color;
  final List<Widget> children;

  const _SettingsCard({
    required this.color,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool showDivider;
  final Color? iconColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.showDivider = false,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = iconColor ?? onboardingclr;

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: tint.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: tint, size: 22),
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
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: greyclr.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: greyclr.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 72,
            color: isDark ? Colors.white12 : greyclr.withValues(alpha: 0.2),
          ),
      ],
    );
  }
}
