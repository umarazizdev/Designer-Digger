import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/digger_storage_service.dart';
import 'package:designerdigger/Utilities/user_document_utils.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageService {
  static Future<String> uploadProfileImage(XFile image) {
    return DiggerStorageService.uploadProfilePhoto(image);
  }

  static Future<void> saveAvatar(String avatarUrl) async {
    final uid = DiggerStorageService.requireAuthUid();

    await FirebaseFirestore.instance.collection('digger_users').doc(uid).set(
      {'avatar': avatarUrl},
      SetOptions(merge: true),
    );
  }

  static Future<void> saveDefaultAvatar() {
    return saveAvatar(UserDocumentUtils.defaultAvatar);
  }
}
