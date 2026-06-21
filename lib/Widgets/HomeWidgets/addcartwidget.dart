import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/digger_user_service.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
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

  String get _cartDocId => DiggerUserService.userItemDocId(widget.docid);

  @override
  void initState() {
    super.initState();
    checkCartStatus();
  }

  Future<void> checkCartStatus() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('digger_cartitems')
          .doc(_cartDocId)
          .get();

      if (!mounted) return;
      setState(() {
        isCartItem = snapshot.exists;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isCartItem = false;
      });
    }
  }

  Future<void> deleteCart() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('digger_cartitems')
        .doc(_cartDocId)
        .delete();
    if (mounted) {
      Utils.toastmessage('${widget.productname} removed from cart');
    }
  }

  Future<void> addCart() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    await FirebaseFirestore.instance.collection('digger_cartitems').doc(_cartDocId).set({
      'image': widget.image,
      'productname': widget.productname,
      'productprice': widget.productprice,
      'productId': widget.docid,
      'uid': DiggerUserService.currentUid ?? box.read('uid'),
    });
    if (mounted) {
      Utils.toastmessage('${widget.productname} added to cart');
    }
  }

  Future<void> toggleCart() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    final wasInCart = isCartItem;
    setState(() {
      isCartItem = !isCartItem;
    });

    try {
      if (!wasInCart) {
        await addCart();
      } else {
        await deleteCart();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isCartItem = wasInCart;
      });
      Utils.flushBarErrorMessage('Could not update cart.', context);
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
