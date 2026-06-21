import 'package:cloud_firestore/cloud_firestore.dart';

class UserDocumentUtils {
  static const defaultAvatar =
      'https://www.lightsong.net/wp-content/uploads/2020/12/blank-profile-circle.png';

  static Map<String, dynamic>? _asMap(DocumentSnapshot doc) {
    return doc.data() as Map<String, dynamic>?;
  }

  static String field(
    DocumentSnapshot doc,
    String key, {
    String fallback = '',
  }) {
    final value = _asMap(doc)?[key];
    if (value == null) return fallback;
    return value.toString();
  }

  static String avatar(DocumentSnapshot doc) {
    return field(doc, 'avatar', fallback: defaultAvatar);
  }

  static String name(DocumentSnapshot doc) {
    return field(doc, 'name', fallback: 'User');
  }

  static String email(DocumentSnapshot doc) {
    return field(doc, 'email', fallback: '');
  }

  static String address(DocumentSnapshot doc) {
    return field(doc, 'address', fallback: '');
  }

  static String phoneNumber(DocumentSnapshot doc) {
    return field(doc, 'phonenumber', fallback: 'Not provided');
  }

  static bool isAdmin(DocumentSnapshot? doc) {
    if (doc == null || !doc.exists) return false;

    try {
      final map = doc.data();
      if (map is! Map<String, dynamic>) return false;
      if (!map.containsKey('is_admin')) return false;

      final value = map['is_admin'];
      if (value == null) return false;
      if (value is bool) return value;
      if (value is num) return value == 1;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
