import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/Provider/adonesprovider.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DetailView extends StatefulWidget {
  final String detail;
  const DetailView({super.key, required this.detail});

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  String activecatt = '';
  CollectionReference users =
      FirebaseFirestore.instance.collection('cartitems');
  Future<void> addUser(
    String image,
    productname,
    productprice,
    quantity,
  ) {
    return users
        .doc(widget.detail.toString())
        .set({
          'image': image,
          'productname': productname,
          'productprice': productprice,
          'adones': quantity,
          'uid': box.read('uid'),
        })
        .then((value) => print(""))
        .catchError(
          (error) =>
              Utils.flushBarErrorMessage("Failed to add user: $error", context),
        );
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    CollectionReference users =
        FirebaseFirestore.instance.collection('products');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.detail.toString()).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: onboardingclr,
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: sc.height * 0.02935,
                    ),
                    SizedBox(
                      height: sc.height / 2.8,
                      child: Container(
                        height: sc.height / 6,
                        decoration: BoxDecoration(
                          color: onboardingclr,
                          image: DecorationImage(
                            image: NetworkImage(
                              data['image'],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: sc.height / 1.63,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? darkbackgroundclr
                            : whiteclr,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(45),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 25),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: sc.height * 0.073,
                                  width: sc.width / 4.3,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(26),
                                      color: onboardingclr),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: sc.width * 0.03,
                                        ),
                                        Icon(
                                          Icons.star,
                                          color: Colors.yellow.withOpacity(0.8),
                                        ),
                                        SizedBox(
                                          width: sc.width * 0.01,
                                        ),
                                        const Text(
                                          "4.8",
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: whiteclr,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  "\$${data['productprice']}",
                                  style: const TextStyle(
                                    fontSize: 19,
                                    color: yellowclr,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: sc.height * 0.014,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data['productname'],
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: sc.height * 0.0075,
                            ),
                            SizedBox(
                              height: sc.height * 0.125,
                              child: Text(
                                data['description'],
                                maxLines: 5,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: greyclr,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: sc.height * 0.01,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Add Ons",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? whiteclr
                                      : blackclr.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: sc.height * 0.01,
                            ),
                            Consumer<AdOnesProvider>(
                              builder: (context, value, child) {
                                return Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        value.setactivecat('Ketchup');
                                      },
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8.0, right: 8),
                                            child: Container(
                                              height: sc.height * 0.105,
                                              width: sc.width / 5.1,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        "assets/Ketchup.png")),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? ldarkbackgroundclr
                                                    : lgreyclr,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 2,
                                            right: -1,
                                            child: value.activecatt == 'Ketchup'
                                                ? const Icon(
                                                    Icons.check_circle,
                                                    color: greenclr,
                                                  )
                                                : const Icon(
                                                    Icons.add_circle,
                                                    color: greenclr,
                                                  ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: sc.width / 18,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        value.setactivecat('carrorraita');
                                      },
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: sc.height * 0.105,
                                              width: sc.width / 5.1,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                    'assets/carrorraita.png',
                                                  ),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? ldarkbackgroundclr
                                                    : lgreyclr,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 2,
                                              right: -1,
                                              child: value.activecatt ==
                                                      'carrorraita'
                                                  ? const Icon(
                                                      Icons.check_circle,
                                                      color: greenclr,
                                                    )
                                                  : const Icon(
                                                      Icons.add_circle,
                                                      color: greenclr,
                                                    )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: sc.width / 18,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        value.setactivecat('Ketchu');
                                      },
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              height: sc.height * 0.105,
                                              width: sc.width / 5.1,
                                              decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/Ketchup.png'),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? ldarkbackgroundclr
                                                    : lgreyclr,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 2,
                                              right: -1,
                                              child:
                                                  value.activecatt == 'Ketchu'
                                                      ? const Icon(
                                                          Icons.check_circle,
                                                          color: greenclr,
                                                        )
                                                      : const Icon(
                                                          Icons.add_circle,
                                                          color: greenclr,
                                                        )),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const Spacer(),
                            Consumer<AdOnesProvider>(
                                builder: (context, value, child) {
                              return InkWell(
                                onTap: () {
                                  addUser(
                                    data['image'],
                                    data['productname'],
                                    data['productprice'],
                                    value.activecatt,
                                  );
                                  Utils.toastmessage(
                                      "${data['productname']} added to cartitems");
                                  context.pop();
                                },
                                child: Container(
                                  height: sc.height * 0.075,
                                  width: sc.width / 1.1,
                                  decoration: BoxDecoration(
                                    color: buttonclr,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "Add to Cart",
                                      style: TextStyle(
                                          color: lgreyclr,
                                          fontSize: 18.5,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  top: 35,
                  left: 20,
                  child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: whiteclr,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
