import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/Models/categorymodel.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FavouriteView extends StatefulWidget {
  const FavouriteView({super.key});

  @override
  State<FavouriteView> createState() => _FavouriteViewState();
}

class _FavouriteViewState extends State<FavouriteView> {
  CollectionReference removefavouritecollection =
      FirebaseFirestore.instance.collection('favourites');

  Future<void> deletefavourite(String docu, data) {
    print("documentid??????????? $docu ");
    return removefavouritecollection
        .doc(docu)
        .delete()
        .then((value) => Utils.toastmessage("${data} removed from favourite "))
        .catchError((error) => Utils.flushBarErrorMessage(
            "Failed to delete user: $error", context));
  }

  final Stream<QuerySnapshot> favouritecollection = FirebaseFirestore.instance
      .collection('favourites')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();

  @override
  Widget build(BuildContext context) {
    var searchController = TextEditingController();
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: sc.width * 0.04),
          child: Text(
            "Wishlist",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).brightness == Brightness.dark
                  ? whiteclr
                  : blackclr,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? darkbackgroundclr
            : whiteclr,
        elevation: 0,
      ),
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? darkbackgroundclr
          : whiteclr,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: favouritecollection,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }

                  return AlignedGridView.count(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    mainAxisSpacing: 10,
                    itemCount: snapshot.data!.docs.length,
                    crossAxisCount: 1,
                    itemBuilder: (context, index) {
                      var data = snapshot.data!.docs[index];
                      return SizedBox(
                        height: sc.height * 0.13,
                        child: Card(
                          elevation: 5,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? ldarkbackgroundclr
                              : Colors.white,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  deletefavourite(data.id, data['productname']);
                                },
                                icon: const Icon(
                                  Icons.close,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: sc.width * 0.23,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        data['image'],
                                      ),
                                    ),
                                    color: const Color.fromARGB(
                                        255, 212, 234, 245),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: sc.width * 0.04,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: sc.width * 0.4,
                                    child: Text(
                                      data['productname'],
                                      style: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? whiteclr
                                              : blackclr,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    '\$${data['productprice']}',
                                    style: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? whiteclr
                                            : blackclr,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
