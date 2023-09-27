import 'package:designerdigger/Utilities/Provider/themeprovider.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DarkTheme extends StatefulWidget {
  const DarkTheme({super.key});

  @override
  State<DarkTheme> createState() => _DarkThemeState();
}

class _DarkThemeState extends State<DarkTheme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? darkbackgroundclr
          : whiteclr,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? darkbackgroundclr
            : whiteclr,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).brightness == Brightness.dark
                ? whiteclr
                : blackclr),
        title: Text(
          "Dark Mode",
          style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? whiteclr
                  : blackclr,
              fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          Consumer<ThemeChanger>(
            builder: (context, value, child) {
              return RadioListTile<ThemeMode>(
                  title: const Text("Light Mode"),
                  value: ThemeMode.light,
                  groupValue: value.themeMode,
                  onChanged: value.setTheme);
            },
          ),
          Consumer<ThemeChanger>(
            builder: (context, value, child) {
              return RadioListTile<ThemeMode>(
                  title: const Text("Dark Mode"),
                  value: ThemeMode.dark,
                  groupValue: value.themeMode,
                  onChanged: value.setTheme);
            },
          ),
          Consumer<ThemeChanger>(
            builder: (context, value, child) {
              return RadioListTile<ThemeMode>(
                  title: const Text("System Mode"),
                  value: ThemeMode.system,
                  groupValue: value.themeMode,
                  onChanged: value.setTheme);
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "We'Will adjust your appearance based on your device's system settings",
              style: TextStyle(fontSize: 13, color: greyclr),
            ),
          )
        ],
      ),
    );
  }
}
