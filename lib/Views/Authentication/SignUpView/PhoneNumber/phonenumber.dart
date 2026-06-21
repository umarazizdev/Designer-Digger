// DISABLED: Phone verification is not used.
// Original flow: SignUp → phone → OTP → /profilepic → /mainview
// Current flow: SignUp → /profilepic → /mainview

import 'package:designerdigger/Utilities/auth_validators.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class PhoneNumberView extends StatefulWidget {
  const PhoneNumberView({super.key});

  @override
  State<PhoneNumberView> createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<PhoneNumberView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNumber = '';
  String verificationId = '';

  void registerWithPhoneNumber(String phoneNumber) async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      await _auth.verifyPhoneNumber(
        phoneNumber: "+92$phoneNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            isLoading = false;
          });

          Utils.toastmessage('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            this.verificationId = verificationId;
          });
          Utils.toastmessage('Verification code sent');
          var id = verificationId;
          var phonenumb = "+92${PhonenumberController.text}";

          context.push("/verifyphonenumberview?id=$id", extra: phonenumb);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            this.verificationId = verificationId;
          });
        },
      );
    } catch (e) {}
  }

  bool isLoading = false;
  final _formkey = GlobalKey<FormState>();
  var PhonenumberController = TextEditingController();
  var verifyPhonenumberController = TextEditingController();
  var addresscontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: onboardingclr,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              SizedBox(
                height: sc.height / 3.2,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
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
                        height: sc.height * 0.035,
                      ),
                      const Text(
                        "Add Phone Number",
                        style: TextStyle(
                          color: onboardingclr,
                          fontSize: 21.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: sc.height * 0.035,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 15),
                        child: Row(
                          children: [
                            Container(
                              height: sc.height * 0.06,
                              width: sc.width * 0.12,
                              decoration: BoxDecoration(
                                  color: whiteclr,
                                  border: Border.all(
                                    color: greyclr,
                                  ),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  )),
                              child: const Center(
                                child: Text("+92 "),
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: PhonenumberController,
                                validator: AuthValidators.pakistaniPhone,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    phoneNumber = value;
                                  });
                                },
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: "Enter Phone Number",
                                  hintStyle:
                                      TextStyle(fontWeight: FontWeight.w400),
                                  contentPadding: EdgeInsets.all(6),
                                  fillColor: whiteclr,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: greyclr),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: greyclr),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sc.height * 0.015,
                      ),
                      InkWell(
                        onTap: isLoading
                            ? null
                            : () => registerWithPhoneNumber(
                                  PhonenumberController.text.trim(),
                                ),
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
                                      "Next",
                                      style: TextStyle(
                                          color: whiteclr,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sc.height * 0.015,
                      ),
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
