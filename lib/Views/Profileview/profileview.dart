import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/digger_user_service.dart';
import 'package:designerdigger/Utilities/user_document_utils.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Stream<DocumentSnapshot> get _usersStream =>
      DiggerUserService.profileStream();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? ldarkbackgroundclr : whiteclr;
    final pageColor = isDark ? darkbackgroundclr : lgreyclr;

    return Scaffold(
      backgroundColor: pageColor,
      body: StreamBuilder<DocumentSnapshot>(
        stream: _usersStream,
        builder: (context, snapshot) {
          final data = snapshot.data;
          final hasProfile = data != null && data.exists && !snapshot.hasError;

          final avatarUrl = hasProfile
              ? UserDocumentUtils.avatar(data)
              : UserDocumentUtils.defaultAvatar;
          final name = hasProfile
              ? UserDocumentUtils.name(data)
              : (box.read('name')?.toString() ?? 'User');
          final email = hasProfile
              ? UserDocumentUtils.email(data)
              : (box.read('email')?.toString() ?? '');
          final address = hasProfile ? UserDocumentUtils.address(data) : '';
          final hasAddress = address.trim().isNotEmpty;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                _ProfileHeader(
                  avatarUrl: avatarUrl,
                  name: name,
                  isDark: isDark,
                  onEdit: () => context.push('/editprofileview', extra: name),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    children: [
                      _ProfileCard(
                        color: surfaceColor,
                        child: Column(
                          children: [
                            _InfoTile(
                              icon: Icons.email_outlined,
                              label: 'Email',
                              value: email.isEmpty ? 'Not available' : email,
                              isDark: isDark,
                              isPlaceholder: email.isEmpty,
                            ),
                            Divider(
                              height: 1,
                              color: isDark
                                  ? Colors.white12
                                  : greyclr.withValues(alpha: 0.25),
                            ),
                            _InfoTile(
                              icon: Icons.location_on_outlined,
                              label: 'Address',
                              value: hasAddress
                                  ? address
                                  : 'Tap edit button along with profile pic to add address',
                              isDark: isDark,
                              isPlaceholder: !hasAddress,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      _ProfileCard(
                        color: surfaceColor,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () => context.push('/settingsview'),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 44,
                                    width: 44,
                                    decoration: BoxDecoration(
                                      color:
                                          onboardingclr.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.settings_outlined,
                                      color: onboardingclr,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Settings',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? whiteclr : blackclr,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Account, appearance & more',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                greyclr.withValues(alpha: 0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: greyclr.withValues(alpha: 0.8),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final bool isDark;
  final VoidCallback onEdit;

  const _ProfileHeader({
    required this.avatarUrl,
    required this.name,
    required this.isDark,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 148,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [onboardingclr, lonboardingclr],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 56, bottom: 20),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: whiteclr,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundImage: NetworkImage(avatarUrl),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Material(
                        color: whiteclr,
                        shape: const CircleBorder(),
                        elevation: 2,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: onEdit,
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.edit_outlined,
                              size: 18,
                              color: onboardingclr,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? whiteclr : blackclr,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'My Profile',
                  style: TextStyle(
                    fontSize: 14,
                    color: greyclr.withValues(alpha: 0.85),
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

class _ProfileCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const _ProfileCard({
    required this.child,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final bool isPlaceholder;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.isPlaceholder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: onboardingclr.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: onboardingclr),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: greyclr.withValues(alpha: 0.95),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    fontStyle:
                        isPlaceholder ? FontStyle.italic : FontStyle.normal,
                    color: isPlaceholder
                        ? greyclr
                        : (isDark ? whiteclr : blackclr),
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
