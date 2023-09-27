import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
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
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      firestore.collection('users').doc(box.read('uid')).set(
            imageData,
            SetOptions(merge: true),
          );

      return '';
    });
  }

  Future<void> _uploadAndSaveImage() async {
    final XFile? image = await chooseImage();
    if (image != null) {
      final imageUrl = await uploadImage(image);
      if (imageUrl.isNotEmpty) {
        final Map<String, dynamic> imageData = {'avatar': imageUrl};
        final FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection('users').doc(box.read('uid')).set(
              imageData,
              SetOptions(merge: true),
            );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addresscontroller = TextEditingController(text: "");
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
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();
  addData() {
    final DocumentReference documentRef =
        FirebaseFirestore.instance.collection("users").doc(box.read('uid'));
    final Map<String, dynamic> newData = {
      'address': addresscontroller.text,
      'name': namecontroller.text,
    };
    documentRef.set(
      newData,
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
          "Profile Setting",
          style: TextStyle(color: whiteclr),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("");
                  }

                  return SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        final data = snapshot.data!.docs[index];
                        return Column(
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
                                        image: singleImage != null
                                            ? DecorationImage(
                                                image: FileImage(
                                                    File(singleImage!.path)),
                                              )
                                            : DecorationImage(
                                                image: NetworkImage(
                                                  data['avatar'],
                                                ),
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
                                        child: IconButton(
                                          onPressed: () {
                                            _uploadAndSaveImage();
                                          },
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
                                      "Name",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? whiteclr
                                            : greyclr,
                                      ),
                                    ),
                                    TextFormField(
                                      controller: namecontroller,
                                    ),
                                    SizedBox(
                                      height: sc.height * 0.015,
                                    ),
                                    Text(
                                      "Phone Number",
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
                                        hintText: data['phonenumber'],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sc.height * 0.015,
                                    ),
                                    Text(
                                      "Email",
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
                                        hintText: data['email'],
                                      ),
                                    ),
                                    SizedBox(
                                      height: sc.height * 0.015,
                                    ),
                                    Text(
                                      "Address",
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
                                        hintText: "Add Address",
                                      ),
                                    ),
                                    SizedBox(
                                      height: sc.height * 0.05,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        if (_formkey.currentState!.validate()) {
                                          addData();
                                          context.pop();
                                          Utils.toastmessage("Profile Edited");
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
                                              "Save",
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
                        );
                      },
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
