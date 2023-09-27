import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
          margin: const EdgeInsets.all(12),
          flushbarPosition: FlushbarPosition.TOP,
          borderRadius: BorderRadius.circular(8),
          forwardAnimationCurve: Curves.decelerate,
          message: message,
          duration: const Duration(seconds: 15),
          messageColor: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(Icons.error),
        )..show(context));
  }

  static toastmessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: blackclr,
      textColor: whiteclr,
      fontSize: 16.0,
    );
  }
}

// ignore: camel_case_extensions
extension retur on num {
  SizedBox get ph => SizedBox(
        height: toDouble(),
      );
  SizedBox get pw => SizedBox(
        width: toDouble(),
      );
}
