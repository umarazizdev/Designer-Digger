import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  bool isLoading = false;
  XFile? singleImage;
  chooseImage() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  String getImageName(XFile image) {
    return image.path.split("/").last;
  }

  Future<String> uploadImage(XFile image) async {
    setState(() {
      isLoading = true;
    });
    Reference db = FirebaseStorage.instance.ref("image/${getImageName(image)}");

    await db.putFile(File(image.path));
    return await db.getDownloadURL().then((value) async {
      users
          .add({
            'image': value,
            'productname': nameController.text,
            'productprice': priceController.text,
            'description': descriptionController.text,
            "category": selectcategory,
            'star1': 0,
            'star2': 0,
            'star3': 0,
            'star4': 0,
            'star5': 0,
            'publish': false,
            'uid': box.read('uid')
          })
          .then((value) => print('Product Edited'))
          .whenComplete(() {
            Utils.toastmessage("Product Added");
            context.pop();
            setState(() {
              isLoading = false;
            });
          })
          .catchError((error) {
            Utils.flushBarErrorMessage("failedtoadduser: $error", context);
            setState(() {
              isLoading = false;
            });
          });

      return '';
    });
  }

  bool isopen = false;
  String selectcategory = 'Select Category';
  List<String> category = [
    'Burger',
    'Pizza',
    'Icrecream',
    'Noodles',
  ];
  final _formkey = GlobalKey<FormState>();
  CollectionReference users = FirebaseFirestore.instance.collection('products');

  var nameController = TextEditingController();
  var priceController = TextEditingController();
  var descriptionController = TextEditingController();
  var categoryController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? darkbackgroundclr
          : whiteclr,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? darkbackgroundclr
            : whiteclr,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Add Products",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? whiteclr
                : blackclr,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Center(
                  child: InkWell(
                    onTap: () async {
                      singleImage = await chooseImage();
                      if (singleImage != null && singleImage!.path.isNotEmpty) {
                        setState(() {});
                      }
                    },
                    child: Container(
                      height: sc.height / 4,
                      width: sc.width / 1.17,
                      decoration: BoxDecoration(
                        image: singleImage != null
                            ? DecorationImage(
                                image: FileImage(File(singleImage!.path)),
                              )
                            : const DecorationImage(
                                image: AssetImage(
                                  "assets/camera-simple-outline-icon-vector-19230878-removebg-preview.png",
                                ),
                              ),
                        color: Theme.of(context).brightness == Brightness.dark
                            ? darkbackgroundclr
                            : whiteclr,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: greyclr),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.02,
                ),
                SizedBox(
                  height: sc.height * 0.07,
                  width: sc.width / 1.17,
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        Utils.flushBarErrorMessage(
                            "Please enter product name", context);
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Product Name",
                      filled: true,
                      fillColor: lonboardingclr.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: greyclr),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: greyclr),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.02,
                ),
                SizedBox(
                  height: sc.height * 0.07,
                  width: sc.width / 1.17,
                  child: TextFormField(
                    controller: priceController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        Utils.flushBarErrorMessage(
                            "Please enter product name", context);
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: "Product Price",
                      filled: true,
                      fillColor: lonboardingclr.withOpacity(0.1),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: greyclr),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: greyclr),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.01,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Product Description",
                        style: TextStyle(fontSize: 14.5),
                      ),
                    ),
                    Container(
                      height: sc.height / 9,
                      width: sc.width / 1.17,
                      decoration: BoxDecoration(
                        color: lonboardingclr.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: greyclr),
                      ),
                      child: TextFormField(
                        maxLines: 4,
                        validator: (value) {
                          if (value!.isEmpty) {
                            Utils.flushBarErrorMessage(
                                "Please enter product Description", context);
                          }
                          return null;
                        },
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 8),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: sc.height * 0.03,
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        isopen = !isopen;
                        setState(() {});
                      },
                      child: Container(
                        height: sc.height * 0.05,
                        width: sc.width / 1.17,
                        decoration: BoxDecoration(
                          color: lonboardingclr.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: greyclr,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                selectcategory,
                                style: const TextStyle(fontSize: 13),
                              ),
                              Icon(
                                isopen
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isopen)
                      ListView(
                        shrinkWrap: true,
                        primary: true,
                        children: category
                            .map((e) => Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: sc.width * 0.04),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: selectcategory == e
                                          ? onboardingclr.withOpacity(0.5)
                                          : lonboardingclr.withOpacity(0.1),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 6),
                                      child: InkWell(
                                        onTap: () {
                                          selectcategory = e;
                                          isopen = false;
                                          setState(() {});
                                        },
                                        child: Text(
                                          e,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                  ],
                ),
                SizedBox(
                  height: sc.height * 0.03,
                ),
                InkWell(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      setState(() {
                        isLoading = false;
                      });
                      if (nameController.text.isEmpty) {
                      } else if (nameController.text.isEmpty) {
                      } else if (descriptionController.text.isEmpty) {
                      } else if (priceController.text.isEmpty) {
                      } else {
                        uploadImage(singleImage!);
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      height: sc.height * 0.07,
                      width: sc.width / 1.17,
                      decoration: BoxDecoration(
                        color: onboardingclr,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: whiteclr,
                              ),
                            )
                          : const Center(
                              child: Text(
                                "Add Products",
                                style: TextStyle(
                                    color: whiteclr,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
