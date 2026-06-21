import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/digger_user_service.dart';
import 'package:designerdigger/Utilities/profile_image_service.dart';
import 'package:designerdigger/Utilities/user_document_utils.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  final String name;
  const EditProfile({super.key, required this.name});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  XFile? singleImage;
  bool isUploadingImage = false;

  Future<void> chooseAndUploadImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null || !mounted) return;

    setState(() {
      singleImage = image;
      isUploadingImage = true;
    });

    try {
      final url = await ProfileImageService.uploadProfileImage(image);
      await ProfileImageService.saveAvatar(url);
      if (mounted) {
        Utils.toastmessage('Profile photo updated');
      }
    } on FirebaseException catch (e) {
      if (mounted) {
        Utils.flushBarErrorMessage(
          e.code == 'unauthorized'
              ? 'Upload denied. Add digger_app/ rules from storage.rules.digger-snippet in Firebase Console.'
              : 'Failed to upload photo: ${e.message ?? e.code}',
          context,
        );
      }
    } catch (e) {
      if (mounted) {
        Utils.flushBarErrorMessage('Failed to upload photo.', context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isUploadingImage = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addresscontroller = TextEditingController(text: '');
    namecontroller = TextEditingController(text: widget.name);
  }

  @override
  void dispose() {
    addresscontroller.dispose();
    namecontroller.dispose();
    super.dispose();
  }

  late TextEditingController addresscontroller;
  late TextEditingController namecontroller;
  final _formkey = GlobalKey<FormState>();
  Stream<DocumentSnapshot> get _usersStream =>
      DiggerUserService.profileStream();

  Future<void> addData() async {
    final uid = box.read('uid')?.toString();
    if (uid == null || uid.isEmpty) return;

    await FirebaseFirestore.instance.collection('digger_users').doc(uid).set(
      {
        'address': addresscontroller.text.trim(),
        'name': namecontroller.text.trim(),
      },
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: onboardingclr,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: whiteclr),
        backgroundColor: onboardingclr,
        elevation: 0,
        title: const Text(
          'Profile Setting',
          style: TextStyle(color: whiteclr),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
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
                  final ImageProvider avatarImage = singleImage != null
                      ? FileImage(File(singleImage!.path))
                      : NetworkImage(avatarUrl) as ImageProvider;

                  return SizedBox(
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              SizedBox(
                                height: sc.height / 5.5,
                                width: sc.width / 3.5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: avatarImage,
                                    ),
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? darkbackgroundclr
                                        : whiteclr,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 15,
                                child: Container(
                                  height: sc.height * 0.055,
                                  width: sc.width * 0.085,
                                  decoration: const BoxDecoration(
                                    color: whiteclr,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: isUploadingImage
                                        ? SizedBox(
                                            height: sc.height * 0.025,
                                            width: sc.height * 0.025,
                                            child:
                                                const CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: chooseAndUploadImage,
                                            icon: Icon(
                                              Icons.edit,
                                              size: sc.height * 0.03,
                                              color: blackclr,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: sc.height * 0.025,
                        ),
                        Container(
                          padding: const EdgeInsets.all(4),
                          width: sc.width,
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness ==
                                    Brightness.dark
                                ? darkbackgroundclr
                                : whiteclr,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 30.0,
                              horizontal: 35,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Name',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? whiteclr
                                        : greyclr,
                                  ),
                                ),
                                TextFormField(
                                  controller: namecontroller,
                                  validator: (value) {
                                    final trimmed = value?.trim() ?? '';
                                    if (trimmed.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: sc.height * 0.015,
                                ),
                                Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? whiteclr
                                        : greyclr,
                                  ),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: hasProfile
                                        ? UserDocumentUtils.phoneNumber(data)
                                        : 'Not provided',
                                  ),
                                ),
                                SizedBox(
                                  height: sc.height * 0.015,
                                ),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? whiteclr
                                        : greyclr,
                                  ),
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: hasProfile
                                        ? UserDocumentUtils.email(data)
                                        : '',
                                  ),
                                ),
                                SizedBox(
                                  height: sc.height * 0.015,
                                ),
                                Text(
                                  'Address',
                                  style: TextStyle(
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? whiteclr
                                        : greyclr,
                                  ),
                                ),
                                TextFormField(
                                  controller: addresscontroller,
                                  decoration: const InputDecoration(
                                    hintText: 'Add Address',
                                  ),
                                ),
                                SizedBox(
                                  height: sc.height * 0.05,
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (!_formkey.currentState!.validate()) {
                                      return;
                                    }
                                    await addData();
                                    if (mounted) {
                                      context.pop();
                                      Utils.toastmessage('Profile Edited');
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Container(
                                      height: sc.height * 0.07,
                                      width: sc.width / 1.17,
                                      decoration: BoxDecoration(
                                        color: onboardingclr,
                                        borderRadius:
                                            BorderRadius.circular(18),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                              color: whiteclr,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                100.ph,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
