import 'package:image_picker/image_picker.dart';

/// Firebase Storage paths for Designer-Digger only.
/// Prefix `digger_app/` keeps this app isolated from other apps in the same project.
class DiggerStoragePaths {
  static const String root = 'digger_app';

  static String fileName(XFile image) {
    return image.path.split('/').last;
  }

  static String profilePhoto(String uid, XFile image) {
    final name =
        '${DateTime.now().millisecondsSinceEpoch}_${fileName(image)}';
    return '$root/users/$uid/$name';
  }

  static String productImage(String uid, XFile image) {
    final name =
        '${DateTime.now().millisecondsSinceEpoch}_${fileName(image)}';
    return '$root/products/$uid/$name';
  }

  static String promotionImage(String uid, XFile image) {
    final name =
        '${DateTime.now().millisecondsSinceEpoch}_${fileName(image)}';
    return '$root/promotions/$uid/$name';
  }
}
