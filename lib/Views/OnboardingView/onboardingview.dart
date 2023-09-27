import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: onboardingclr,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: sc.height / 6,
          ),
          Image.asset(
            'assets/Untitled_design__1_-removebg-preview.png',
          ),
          const Spacer(),
          Center(
            child: Text(
              "      Enjoy\n Your Food",
              style: TextStyle(
                color: textclr,
                fontSize: sc.height * 0.06,
              ),
            ),
          ),
          SizedBox(
            height: sc.height / 18,
          ),
          InkWell(
            onTap: () {
              if (box.read('islogin') == true) {
                setState(() {
                  isLoading = true;
                });
                Future.delayed(const Duration(seconds: 2), () {
                  GoRouter.of(context).go('/mainview');
                  setState(() {
                    isLoading = false;
                  });
                });
              } else {
                GoRouter.of(context).go('/signin');
              }
            },
            child: Container(
              height: sc.height * 0.07,
              width: sc.width / 2.1,
              decoration: BoxDecoration(
                color: whiteclr,
                borderRadius: BorderRadius.circular(18),
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : const Center(
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          color: onboardingclr,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
