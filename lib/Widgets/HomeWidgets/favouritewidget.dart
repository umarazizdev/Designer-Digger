import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavouriteWidget extends StatefulWidget {
  final String docid, image, productname, productprice;

  const FavouriteWidget(
      {required this.docid,
      required this.image,
      required this.productname,
      required this.productprice});

  @override
  _FavouriteWidgetState createState() => _FavouriteWidgetState();
}

class _FavouriteWidgetState extends State<FavouriteWidget> {
  bool isLiked = false;

  @override
  void initState() {
    checkLikeStatus();
    super.initState();
  }

  void checkLikeStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('favourites')
        .doc(widget.docid)
        .get();

    setState(() {
      isLiked = snapshot.exists;
    });
  }

  Future<void> deleteLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    return FirebaseFirestore.instance
        .collection('favourites')
        .doc(widget.docid)
        .delete()
        .catchError((error) => Utils.flushBarErrorMessage(
            "Failed to delete user: $error", context));
  }

  Future<void> addLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    return FirebaseFirestore.instance
        .collection('favourites')
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

  void toggleLike() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return;
    }

    setState(() {
      isLiked = !isLiked;
    });

    if (isLiked) {
      await addLike();
    } else {
      await deleteLike();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : greyclr,
      ),
      onPressed: toggleLike,
    );
  }
}
