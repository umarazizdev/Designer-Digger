import 'dart:io';

import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/profile_image_service.dart';
import 'package:designerdigger/Utilities/user_document_utils.dart';
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
  XFile? singleImage;
  bool isLoading = false;

  Future<void> chooseImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      setState(() {
        singleImage = image;
      });
    }
  }

  Future<void> completeProfile({required bool skip}) async {
    if (isLoading) return;

    if (!skip && singleImage == null) {
      Utils.flushBarErrorMessage(
        'Please select a photo or tap Skip to continue.',
        context,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      if (skip) {
        await ProfileImageService.saveDefaultAvatar();
      } else {
        try {
          final url =
              await ProfileImageService.uploadProfileImage(singleImage!);
          await ProfileImageService.saveAvatar(url);
        } on FirebaseException catch (e) {
          await ProfileImageService.saveDefaultAvatar();
          if (mounted) {
            final isAuthIssue = e.code == 'unauthorized' ||
                e.code == 'permission-denied' ||
                e.code == 'storage/unauthorized';
            Utils.flushBarErrorMessage(
              isAuthIssue
                  ? 'Upload denied. Confirm digger_app/ rules are published and you are signed in.'
                  : 'Upload failed (${e.code}). Using default photo.',
              context,
            );
          }
        }
      }

      box.write('islogin', true);

      if (mounted) {
        Utils.toastmessage('SignUp successfully');
        GoRouter.of(context).go('/mainview');
      }
    } catch (e) {
      if (mounted) {
        Utils.flushBarErrorMessage(
          'Could not save profile. Please try again.',
          context,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
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
                onTap: chooseImage,
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
                              UserDocumentUtils.defaultAvatar,
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: sc.height * 0.3,
              ),
              InkWell(
                onTap: isLoading ? null : () => completeProfile(skip: true),
                child: Container(
                  height: sc.height * 0.07,
                  width: sc.width / 1.25,
                  decoration: BoxDecoration(
                    color: lonboardingclr,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: whiteclr,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Skip',
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
                onTap: isLoading ? null : () => completeProfile(skip: false),
                child: Container(
                  height: sc.height * 0.07,
                  width: sc.width / 1.25,
                  decoration: BoxDecoration(
                    color: whiteclr,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      'Next',
                      style: TextStyle(
                        color: onboardingclr,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
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
