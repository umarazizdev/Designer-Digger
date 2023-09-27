import 'package:designerdigger/Utilities/Provider/securepass.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool isLoading = false;
  signin() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      box.write('uid', credential.user!.uid);
      box.write('islogin', true);
      GoRouter.of(context).go('/mainview');
      Utils.toastmessage("Login Succesfully");
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Utils.flushBarErrorMessage('No user found for that email.', context);
      } else if (e.code == 'wrong-password') {
        Utils.flushBarErrorMessage(
            'Wrong password provided for that user.', context);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: onboardingclr,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: sc.height / 2,
                width: sc.width / 1.3,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 234, 228, 228),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      colors: authbackgroundcontainer,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: sc.height * 0.025,
                    ),
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        color: onboardingclr,
                        fontSize: 21.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: sc.height * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 15),
                      child: TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return Utils.flushBarErrorMessage(
                                "Please Enter Email", context);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Email",
                          hintStyle:
                              const TextStyle(fontWeight: FontWeight.w400),
                          contentPadding: const EdgeInsets.all(6),
                          fillColor: whiteclr,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: greyclr),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: greyclr),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    Consumer<SecurePass>(
                      builder: (context, value, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 15),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return Utils.flushBarErrorMessage(
                                    "Please Enter password", context);
                              }
                              return null;
                            },
                            controller: passwordController,
                            obscureText: !value.securepass,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {
                                  value.setLoading();
                                },
                                child: Icon(
                                  value.securepass
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: value.securepass
                                      ? onboardingclr
                                      : greyclr,
                                ),
                              ),
                              hintText: "Enter password",
                              hintStyle:
                                  const TextStyle(fontWeight: FontWeight.w400),
                              contentPadding: const EdgeInsets.all(6),
                              fillColor: whiteclr,
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: greyclr),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: greyclr),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = false;
                          });
                          signin();
                          GoRouter.of(context).go('/mainview');
                          Utils.toastmessage("Login Succesfully");
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: sc.height * 0.07,
                          decoration: BoxDecoration(
                            color: onboardingclr,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: whiteclr,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                        color: whiteclr,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).go('/signup');
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            color: blackclr,
                          ),
                          children: [
                            TextSpan(
                              text: "SignUp",
                              style: TextStyle(
                                color: onboardingclr,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
