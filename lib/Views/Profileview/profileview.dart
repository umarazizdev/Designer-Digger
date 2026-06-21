import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/digger_user_service.dart';
import 'package:designerdigger/Utilities/user_document_utils.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? darkbackgroundclr
          : whiteclr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: sc.height / 4,
                width: sc.width,
                color: onboardingclr,
              ),
              Positioned(
                  child: Column(
                children: [
                  SizedBox(
                    height: sc.height * 0.07,
                  ),
                  StreamBuilder<DocumentSnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      final data = snapshot.data;
                      final hasProfile =
                          data != null && data.exists && !snapshot.hasError;
                      final avatarUrl = hasProfile
                          ? UserDocumentUtils.avatar(data)
                          : UserDocumentUtils.defaultAvatar;
                      final name = hasProfile
                          ? UserDocumentUtils.name(data)
                          : (box.read('name')?.toString() ?? 'User');

                      return Stack(
                        children: [
                          Center(
                            child: SizedBox(
                              height: sc.height / 4,
                              width: sc.width / 2,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(avatarUrl),
                              ),
                            ),
                          ),
                          Positioned(
                              right: 100,
                              top: 10,
                              child: Container(
                                height: sc.height * 0.065,
                                width: sc.width * 0.095,
                                decoration: const BoxDecoration(
                                  color: whiteclr,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      context.push(
                                        '/editprofileview',
                                        extra: name,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      color: blackclr,
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      );
                    },
                  ),
                ],
              ))
            ],
          ),
          const Spacer(),
          StreamBuilder<DocumentSnapshot>(
            stream: _usersStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return _settingsMenu(context, sc, isAdmin: false);
              }

              final isAdmin = UserDocumentUtils.isAdmin(snapshot.data);

              return _settingsMenu(context, sc, isAdmin: isAdmin);
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _settingsMenu(BuildContext context, Size sc, {required bool isAdmin}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isAdmin) ...[
          InkWell(
            onTap: () {
              GoRouter.of(context).push('/addpromotionsview');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: sc.height * 0.04,
                  ),
                  10.pw,
                  const Text(
                    'Add Promotions',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          10.ph,
          const Divider(color: greyclr),
          InkWell(
            onTap: () {
              GoRouter.of(context).push('/addproductsview');
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: sc.height * 0.04,
                  ),
                  10.pw,
                  const Text(
                    'Add Products',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          10.ph,
          const Divider(color: greyclr),
        ],
        InkWell(
          onTap: () {
            GoRouter.of(context).push('/cartview');
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Row(
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: sc.height * 0.04,
                ),
                10.pw,
                const Text(
                  'Shopping Cart',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        10.ph,
        const Divider(color: greyclr),
        InkWell(
          onTap: () {
            context.push('/darkview');
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Row(
              children: [
                Icon(
                  Icons.dark_mode_outlined,
                  size: sc.height * 0.04,
                ),
                10.pw,
                const Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        10.ph,
        const Divider(color: greyclr),
        InkWell(
          onTap: () async {
            box.write('islogin', false);
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              GoRouter.of(context).go('/signin');
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Row(
              children: [
                Icon(
                  Icons.logout,
                  size: sc.height * 0.04,
                ),
                10.pw,
                const Text(
                  'Logout',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        10.ph,
      ],
    );
  }
}
