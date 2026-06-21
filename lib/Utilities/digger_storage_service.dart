import 'dart:io';

import 'package:designerdigger/Utilities/digger_storage_paths.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class DiggerStorageService {
  static String requireAuthUid() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      throw StateError('User is not signed in with Firebase Auth.');
    }
    return uid;
  }

  static String imageContentType(XFile image) {
    final mime = image.mimeType;
    if (mime != null && mime.startsWith('image/')) {
      return mime;
    }

    final path = image.path.toLowerCase();
    if (path.endsWith('.png')) return 'image/png';
    if (path.endsWith('.webp')) return 'image/webp';
    if (path.endsWith('.gif')) return 'image/gif';
    if (path.endsWith('.heic')) return 'image/heic';
    return 'image/jpeg';
  }

  static Future<String> uploadProfilePhoto(XFile image) {
    return _upload(
      image: image,
      path: (uid) => DiggerStoragePaths.profilePhoto(uid, image),
    );
  }

  static Future<String> uploadProductImage(XFile image) {
    return _upload(
      image: image,
      path: (uid) => DiggerStoragePaths.productImage(uid, image),
    );
  }

  static Future<String> uploadPromotionImage(XFile image) {
    return _upload(
      image: image,
      path: (uid) => DiggerStoragePaths.promotionImage(uid, image),
    );
  }

  static Future<String> _upload({
    required XFile image,
    required String Function(String uid) path,
  }) async {
    final uid = requireAuthUid();
    final storagePath = path(uid);
    final contentType = imageContentType(image);
    final ref = FirebaseStorage.instance.ref(storagePath);

    if (kDebugMode) {
      debugPrint(
        'DiggerStorage upload: uid=$uid path=$storagePath contentType=$contentType',
      );
    }

    try {
      await ref.putFile(
        File(image.path),
        SettableMetadata(contentType: contentType),
      );
      return ref.getDownloadURL();
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        debugPrint(
          'DiggerStorage upload failed: code=${e.code} message=${e.message}',
        );
      }
      rethrow;
    }
  }
}
