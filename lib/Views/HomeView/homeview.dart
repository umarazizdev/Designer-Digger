import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/Provider/categoryprovider.dart';
import 'package:designerdigger/Utilities/Provider/favouriteprovider.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Widgets/HomeWidgets/addcartwidget.dart';
import 'package:designerdigger/Widgets/HomeWidgets/categorywidget.dart';
import 'package:designerdigger/Widgets/HomeWidgets/favouritewidget.dart';
import 'package:designerdigger/Widgets/HomeWidgets/promotionwidget.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Stream<QuerySnapshot> _profileStream = FirebaseFirestore.instance
      .collection('users')
      .where('uid', isEqualTo: box.read('uid'))
      .snapshots();

  List allresults = [];
  List resultList = [];
  final CategoryProvider categoryProvider = CategoryProvider();

  getClientStream() async {
    var dat = await FirebaseFirestore.instance
        .collection('products')
        .orderBy('productname')
        .get();

    setState(() {
      allresults = dat.docs;
    });
    searchResultList();
  }

  @override
  void initState() {
    searchController.addListener(onSearchChanged);
    super.initState();
  }

  onSearchChanged() {
    print(searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (searchController.text != '') {
      for (var clientSnapshot in allresults) {
        var productname =
            clientSnapshot['productname'].toString().toLowerCase();
        if (productname.contains(searchController.text.toLowerCase())) {
          showResults.add(clientSnapshot);
        }
      }
    } else {
      // showResults = List.from(allresults);
    }
    setState(() {
      resultList = showResults;
    });
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.removeListener(onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(box.read('uid'));
    Size sc = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? darkbackgroundclr
          : whiteclr,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _profileStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("");
                    }

                    return SizedBox(
                      height: sc.height * 0.067,
                      child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          final data = snapshot.data!.docs[index];
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Menu",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? whiteclr
                                        : blackclr,
                                    fontSize: sc.height * 0.05),
                              ),
                              InkWell(
                                onTap: () {
                                  var name = data['name'];
                                  context.push('/editprofileview', extra: name);
                                },
                                child: CircleAvatar(
                                  foregroundImage: NetworkImage(data['avatar']),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: sc.height * 0.02,
                ),
                Container(
                  height: sc.height * 0.065,
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? ldarkbackgroundclr
                        : lgreyclr,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextFormField(
                    controller: searchController,
                    cursorColor: buttonclr,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8),
                      hintText: "Search",
                      hintStyle: TextStyle(
                        color: greyclr,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: greyclr,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: sc.height * 0.02,
                ),
                const Row(
                  children: [
                    CategoryWidget(
                      asset: "assets/onboarding.png",
                      activecatvalue: 'All',
                    ),
                    CategoryWidget(
                      asset: "assets/burger.png",
                      activecatvalue: 'Burger',
                    ),
                    CategoryWidget(
                      asset: "assets/pizza.png",
                      activecatvalue: 'Pizza',
                    ),
                    CategoryWidget(
                      asset: "assets/icecream.png",
                      activecatvalue: 'Icrecream',
                    ),
                  ],
                ),
                Column(
                  children: [
                    PromotionWidget(),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Popular",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: sc.height * 0.01,
                    ),
                    if (searchController.text != '') ...[
                      AlignedGridView.count(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 10,
                        itemCount: resultList.length,
                        crossAxisCount: 2,
                        itemBuilder: (context, index) {
                          final resultData = resultList[index];
                          return ChangeNotifierProvider(
                            create: (_) => FavouriteProvider(),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: sc.height / 4.3,
                                      width: sc.width / 2.3,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? ldarkbackgroundclr
                                            : lgreyclr,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                var documentId = resultData.id;
                                                context.push('/detailview',
                                                    extra: documentId);
                                              },
                                              child: Container(
                                                height: sc.height / 6.5,
                                                width: sc.width,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                      resultData['image'],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: sc.height * 0.025,
                                              child: Text(
                                                resultData['productname'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\$${resultData['productprice']}",
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: yellowclr,
                                                  ),
                                                ),
                                                CartItemWidget(
                                                  docid: resultData.id,
                                                  image: resultData['image'],
                                                  productname:
                                                      resultData['productname'],
                                                  productprice: resultData[
                                                      'productprice'],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -3,
                                      right: 0,
                                      child: FavouriteWidget(
                                        docid: resultData.id,
                                        image: resultData['image'],
                                        productname: resultData['productname'],
                                        productprice:
                                            resultData['productprice'],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      Consumer<CategoryProvider>(
                        builder: (context, value, child) {
                          return StreamBuilder<QuerySnapshot>(
                            stream: value.activecat == 'All'
                                ? FirebaseFirestore.instance
                                    .collection('products')
                                    .snapshots()
                                : FirebaseFirestore.instance
                                    .collection('products')
                                    .where('category',
                                        isEqualTo: value.activecat)
                                    .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("");
                              }
                              return AlignedGridView.count(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 13,
                                itemCount: snapshot.data!.docs.length,
                                crossAxisCount: 2,
                                itemBuilder: (context, index) {
                                  final resultData = snapshot.data!.docs[index];
                                  return ChangeNotifierProvider(
                                    create: (_) => FavouriteProvider(),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: sc.height / 4.3,
                                              width: sc.width / 2.3,
                                              decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.dark
                                                    ? ldarkbackgroundclr
                                                    : lgreyclr,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 12),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        var documentId =
                                                            resultData.id;
                                                        context.push(
                                                            '/detailview',
                                                            extra: documentId);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 12.0),
                                                        child: Container(
                                                          height:
                                                              sc.height / 6.5,
                                                          width: sc.width,
                                                          decoration:
                                                              BoxDecoration(
                                                            image:
                                                                DecorationImage(
                                                              image:
                                                                  NetworkImage(
                                                                resultData[
                                                                    'image'],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: sc.height * 0.04,
                                                      child: Text(
                                                        resultData[
                                                            'productname'],
                                                        style: const TextStyle(
                                                          height: 1,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: sc.height * 0.025,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 12.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "\$${resultData['productprice']}",
                                                              style:
                                                                  const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    yellowclr,
                                                              ),
                                                            ),
                                                            CartItemWidget(
                                                              docid:
                                                                  resultData.id,
                                                              image: resultData[
                                                                  'image'],
                                                              productname:
                                                                  resultData[
                                                                      'productname'],
                                                              productprice:
                                                                  resultData[
                                                                      'productprice'],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: -3,
                                              right: 0,
                                              child: FavouriteWidget(
                                                docid: resultData.id,
                                                image: resultData['image'],
                                                productname:
                                                    resultData['productname'],
                                                productprice:
                                                    resultData['productprice'],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      )
                    ],
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
