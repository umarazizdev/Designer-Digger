import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VerifyPhoneNumberView extends StatefulWidget {
  final String phonenumb;
  final String id;
  const VerifyPhoneNumberView(
      {super.key, required this.phonenumb, required this.id});

  @override
  State<VerifyPhoneNumberView> createState() => _PhoneNumberViewState();
}

class _PhoneNumberViewState extends State<VerifyPhoneNumberView> {
  bool isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String phoneNumber = '';
  String verificationId = '';

  Future<void> signInWithPhoneNumber() async {
    setState(() {
      isLoading = true;
    });
    // final searchProvider = Provider.of<SearchProvider>(context, listen: false);

    // searchProvider.setLoading(true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.id,
        smsCode: PhonenumberController.text,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        // String token = await user.getIdToken(); // Retrieve the token
        // ignore: avoid_print
        final DocumentReference documentRef =
            FirebaseFirestore.instance.collection("users").doc(box.read('uid'));
        final Map<String, dynamic> newData = {
          'phonenumber': widget.phonenumb,
          'uid': box.read('uid')
        };
        documentRef
            .set(
              newData,
              SetOptions(merge: true),
            )
            .then((value) {})
            .whenComplete(() {
          // box.write('uid', box.read('uid'));
          box.write('islogin', true);
          context.push('/profilepic');
          setState(() {
            isLoading = false;
          });
          // searchProvider.setLoading(false);
        }).catchError((error) {
          setState(() {
            isLoading = false;
          });
          // searchProvider.setLoading(false);

          print("Failed to add user: $error");
        });
        // print("token id is :${user.getIdToken()}");
        // ignore: avoid_print
      } else {
        Utils.toastmessage('User registration failed');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // searchProvider.setLoading(false);

      Utils.toastmessage('Error occurred during registration: $e');
    }

    // ignore: avoid_returning_null_for_void
    return null;
  }

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
                  // height: sc.height / 1.5,
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
                        "Enter Otp",
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
                        child: TextFormField(
                          controller: PhonenumberController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return Utils.flushBarErrorMessage(
                                  "Please Enter Otp", context);
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              phoneNumber = value;
                            });
                          },
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Enter Otp",
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
                      SizedBox(
                        height: sc.height * 0.015,
                      ),
                      InkWell(
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              isLoading = false;
                            });
                            if (PhonenumberController.text.isEmpty) {
                              Utils.flushBarErrorMessage(
                                  'Please Enter Otp', context);
                            } else {
                              signInWithPhoneNumber();
                            }
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
                                      "Verify",
                                      style: TextStyle(
                                          color: whiteclr,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      // const Spacer(),
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
