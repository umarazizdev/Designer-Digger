import 'package:designerdigger/Utilities/colors.dart';
import 'package:flutter/material.dart';

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key, required this.error}) : super(key: key);
  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? darkbackgroundclr
          : whiteclr,
      appBar: AppBar(
        title: const Text("Error Page"),
      ),
      body: Center(
        child: Text(error),
      ),
    );
  }
}
