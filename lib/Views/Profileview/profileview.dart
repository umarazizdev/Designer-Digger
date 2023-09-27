import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
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
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();

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
                  StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("");
                      }

                      return ListView.builder(
                        itemCount: 1,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          return Stack(
                            children: [
                              Center(
                                child: SizedBox(
                                  height: sc.height / 4,
                                  width: sc.width / 2,
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(data['avatar']),
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
                                          var name = data['name'];
                                          context.push('/editprofileview',
                                              extra: name);
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
                      );
                    },
                  ),
                ],
              ))
            ],
          ),
          const Spacer(),
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
                    "Add Promotions",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          10.ph,
          const Divider(
            color: greyclr,
          ),
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
                    "Add Products",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          10.ph,
          const Divider(
            color: greyclr,
          ),
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
                    "Shopping Cart",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          10.ph,
          const Divider(
            color: greyclr,
          ),
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
                    "Dark Mode",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          10.ph,
          const Divider(
            color: greyclr,
          ),
          InkWell(
            onTap: () async {
              box.write('islogin', false);
              await FirebaseAuth.instance.signOut();
              GoRouter.of(context).go('/signin');
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
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          10.ph,
          const Spacer(),
        ],
      ),
    );
  }
}
