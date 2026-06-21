import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/main.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiggerUserService {
  static String? get currentUid =>
      FirebaseAuth.instance.currentUser?.uid ?? box.read('uid')?.toString();

  /// Reads `/digger_users/{authUid}` — matches Firestore security rules.
  static Stream<DocumentSnapshot> profileStream() {
    final uid = currentUid;
    if (uid == null || uid.isEmpty) {
      return Stream<DocumentSnapshot>.empty();
    }
    return FirebaseFirestore.instance
        .collection('digger_users')
        .doc(uid)
        .snapshots();
  }

  static String userItemDocId(String productId) {
    final uid = currentUid;
    if (uid == null || uid.isEmpty) {
      throw StateError('User is not signed in.');
    }
    return '${uid}_$productId';
  }
}
