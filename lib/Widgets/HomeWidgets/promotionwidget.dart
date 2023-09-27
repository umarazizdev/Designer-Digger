import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:flutter/material.dart';

class PromotionWidget extends StatelessWidget {
  final Stream<QuerySnapshot> _promotionsStream =
      FirebaseFirestore.instance.collection('promotions').snapshots();

  PromotionWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Promotions",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _promotionsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: sc.height / 4.5,
              );
            }
            return SizedBox(
              height: sc.height / 4.45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var categorydata = snapshot.data!.docs[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: sc.width * 0.05,
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  whiteclr.withOpacity(0.2), BlendMode.srcATop),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: sc.height * 0.019,
                                ),
                                child: Container(
                                  height: sc.height / 5.5,
                                  width: sc.width / 1.1,
                                  decoration: BoxDecoration(
                                    color: buttonclr,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          categorydata['title'],
                                          style: const TextStyle(
                                              color: whiteclr, fontSize: 16),
                                        ),
                                        SizedBox(height: sc.height * 0.0015),
                                        Text(
                                          categorydata['heading'],
                                          style: const TextStyle(
                                              color: whiteclr,
                                              fontSize: 17.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: sc.height * 0.0015),
                                        SizedBox(
                                          width: sc.width * .5,
                                          child: Text(
                                            categorydata['subtitle'],
                                            style: const TextStyle(
                                                color: whiteclr, fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: -45,
                          top: -55,
                          child: Image.asset(
                            "assets/bannerfries.png",
                            height: sc.height * 0.25,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
