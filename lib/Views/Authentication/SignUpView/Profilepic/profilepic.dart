import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class Profilepic extends StatefulWidget {
  const Profilepic({super.key});

  @override
  State<Profilepic> createState() => _ProfilepicState();
}

class _ProfilepicState extends State<Profilepic> {
  final DocumentReference users =
      FirebaseFirestore.instance.collection('users').doc(box.read('uid'));

  adddata() {
    final DocumentReference user =
        FirebaseFirestore.instance.collection('users').doc(box.read('uid'));
    final Map<String, dynamic> newData = {
      'avatar':
          "https://www.lightsong.net/wp-content/uploads/2020/12/blank-profile-circle.png",
    };
    user.set(
      newData,
      SetOptions(merge: true),
    );
  }

  XFile? singleImage;
  chooseImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  Future<String> uploadImage(XFile image) async {
    Reference db = FirebaseStorage.instance.ref("image/${getImageName(image)}");

    await db.putFile(File(image.path));
    return await db.getDownloadURL().then((value) async {
      final Map<String, dynamic> imageData = {'avatar': value};
      users.set(
        imageData,
        SetOptions(merge: true),
      );

      return '';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: onboardingclr,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: sc.height * 0.1,
              ),
              InkWell(
                onTap: () async {
                  singleImage = await chooseImage();
                  if (singleImage != null && singleImage!.path.isNotEmpty) {
                    setState(() {});
                  }
                },
                child: Container(
                  height: sc.height / 3,
                  width: sc.width / 2,
                  decoration: BoxDecoration(
                    color: whiteclr,
                    shape: BoxShape.circle,
                    image: singleImage != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: FileImage(File(singleImage!.path)),
                          )
                        : const DecorationImage(
                            image: NetworkImage(
                              "https://www.lightsong.net/wp-content/uploads/2020/12/blank-profile-circle.png",
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: sc.height * 0.3,
              ),
              InkWell(
                onTap: () {
                  adddata();
                  Utils.toastmessage("SignUp successfully");
                  GoRouter.of(context).go('/mainview');
                  box.write('islogin', true);
                },
                child: Container(
                  height: sc.height * 0.07,
                  width: sc.width / 1.25,
                  decoration: BoxDecoration(
                    color: lonboardingclr,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: whiteclr,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: sc.height * 0.05,
              ),
              InkWell(
                onTap: () {
                  uploadImage(singleImage!);
                  Utils.toastmessage("SignUp successfully");
                  GoRouter.of(context).go('/mainview');
                  box.write('islogin', true);
                },
                child: Container(
                  height: sc.height * 0.07,
                  width: sc.width / 1.25,
                  decoration: BoxDecoration(
                    color: whiteclr,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      "Next",
                      style: TextStyle(
                          color: onboardingclr,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: sc.height * 0.08,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
