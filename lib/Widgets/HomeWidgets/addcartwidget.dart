import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartItemWidget extends StatefulWidget {
  final String docid, image, productname, productprice;

  const CartItemWidget(
      {required this.docid,
      required this.image,
      required this.productname,
      required this.productprice});

  @override
  _CartItemWidgetState createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  bool isCartItem = false;

  @override
  void initState() {
    super.initState();
    checkCartStatus();
  }

  void checkCartStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('cartitems')
        .doc(widget.docid)
        .get();

    setState(() {
      isCartItem = snapshot.exists;
    });
  }

  Future<void> deleteCart() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    return FirebaseFirestore.instance
        .collection('cartitems')
        .doc(widget.docid)
        .delete()
        .then((value) =>
            Utils.toastmessage("${widget.productname} removed from cartitems"))
        .catchError((error) => Utils.flushBarErrorMessage(
            "Failed to delete user: $error", context));
  }

  Future<void> addCart() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    return FirebaseFirestore.instance
        .collection('cartitems')
        .doc(widget.docid)
        .set({
          'image': widget.image,
          'productname': widget.productname,
          'productprice': widget.productprice,
          'uid': box.read('uid'),
        })
        .then((value) =>
            Utils.toastmessage("${widget.productname} added to favourites "))
        .catchError(
          (error) =>
              Utils.flushBarErrorMessage("Failed to add user: $error", context),
        );
  }

  void toggleCart() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    setState(() {
      isCartItem = !isCartItem;
    });

    if (isCartItem) {
      await addCart();
    } else {
      await deleteCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size sc = MediaQuery.of(context).size;
    return InkWell(
      onTap: toggleCart,
      child: Icon(
        isCartItem ? Icons.check_circle : Icons.add_circle,
        color: greenclr,
        size: sc.height * 0.031,
      ),
    );
  }
}
