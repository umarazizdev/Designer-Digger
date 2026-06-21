import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/Provider/securepass.dart';
import 'package:designerdigger/Utilities/auth_validators.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/user_document_utils.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  CollectionReference users = FirebaseFirestore.instance.collection('digger_users');
  bool isLoading = false;

  Future<void> SignUp() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      await users.doc(credential.user!.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'uid': credential.user!.uid,
        'avatar': UserDocumentUtils.defaultAvatar,
      });

      box.write('uid', credential.user!.uid);
      box.write('name', nameController.text.trim());
      box.write('islogin', true);

      if (mounted) {
        GoRouter.of(context).go('/profilepic');
      }
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      if (e.code == 'weak-password') {
        Utils.flushBarErrorMessage(
            'The password provided is too weak.', context);
      } else if (e.code == 'email-already-in-use') {
        Utils.flushBarErrorMessage(
            'The account already exists for that email.', context);
      } else if (e.code == 'invalid-email') {
        Utils.flushBarErrorMessage('Please enter a valid email.', context);
      } else {
        Utils.flushBarErrorMessage(
            e.message ?? 'Sign up failed. Please try again.', context);
      }
    } catch (e) {
      if (mounted) {
        Utils.flushBarErrorMessage(e.toString(), context);
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  final _formkey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: onboardingclr,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: sc.height / 5,
              ),
              Center(
                child: Container(
                  height: sc.height / 1.7,
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
                        "Sign Up",
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
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: AuthValidators.name,
                          decoration: InputDecoration(
                            hintText: "Enter Name",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 15),
                        child: TextFormField(
                          validator: AuthValidators.email,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              obscureText: !value.securepass,
                              validator: AuthValidators.password,
                              controller: passwordController,
                              textInputAction: TextInputAction.done,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onFieldSubmitted: (_) => SignUp(),
                              decoration: InputDecoration(
                                hintText: "Enter password",
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
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w400),
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
                        onTap: isLoading ? null : SignUp,
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
                                      "Sign Up",
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
                          context.push('/signin');
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: blackclr,
                            ),
                            children: [
                              TextSpan(
                                text: "SignIn",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
