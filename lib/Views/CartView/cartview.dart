import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/Provider/itemquantityprovider.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('cartitems')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? darkbackgroundclr
            : whiteclr,
        appBar: AppBar(
          title: const Text(
            "Items in Cart",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _usersStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('No cartitems yet! lets order'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index];
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: sc.height / 5.8,
                                            width: sc.width / 3.5,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  data['image'],
                                                ),
                                              ),
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? ldarkbackgroundclr
                                                  : lgreyclr,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: sc.height * 0.015,
                                                  ),
                                                  child: SizedBox(
                                                    width: sc.width / 2.1,
                                                    child: Text(
                                                      data['productname'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 17.5,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: sc.height * 0.008,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: sc.height * 0.015,
                                                  ),
                                                  child: Text(
                                                    '\$${data['productprice']}',
                                                    style: const TextStyle(
                                                      fontSize: 17.5,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: yellowclr,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: -8,
                                    child: IconButton(
                                      onPressed: () {
                                        CollectionReference users =
                                            FirebaseFirestore.instance
                                                .collection('cartitems');
                                        users
                                            .doc(data.id)
                                            .delete()
                                            .then((value) => Utils.toastmessage(
                                                '${data['productname']} item removed from cartitems'))
                                            .catchError(
                                              (error) => Utils.flushBarErrorMessage(
                                                  "Failed to delete user: $error",
                                                  context),
                                            );
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        color:
                                            Color.fromARGB(255, 152, 103, 105),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  // const Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "Total",
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.w500,
                  //       ),
                  //     ),
                  //     Text(
                  //       "\$28",
                  //       style: TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.w500,
                  //         color: yellowclr,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  SizedBox(
                    height: sc.height * 0.015,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     // Navigator.pushAndRemoveUntil(
                  //     //     context,
                  //     //     MaterialPageRoute(
                  //     //       builder: (context) => const MainView(),
                  //     //     ),
                  //     //     (route) => false);
                  //   },
                  //   child: Container(
                  //     height: sc.height * 0.075,
                  //     width: sc.width / 1.1,
                  //     decoration: BoxDecoration(
                  //       color: buttonclr,
                  //       borderRadius: BorderRadius.circular(18),
                  //     ),
                  //     child: const Center(
                  //       child: Text(
                  //         "Checkout",
                  //         style: TextStyle(
                  //             color: lgreyclr,
                  //             fontSize: 18.5,
                  //             fontWeight: FontWeight.w500),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: sc.height * 0.01,
                  // ),
                ],
              ),
            );
          },
        ));
  }
}
