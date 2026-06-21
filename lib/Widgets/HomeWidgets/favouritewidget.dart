import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:designerdigger/Utilities/digger_user_service.dart';
import 'package:designerdigger/Utilities/utils.dart';
import 'package:designerdigger/main.dart';
import 'package:flutter/material.dart';
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

  String get _favouriteDocId => DiggerUserService.userItemDocId(widget.docid);

  @override
  void initState() {
    super.initState();
    checkLikeStatus();
  }

  Future<void> checkLikeStatus() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('digger_favourites')
          .doc(_favouriteDocId)
          .get();

      if (!mounted) return;
      setState(() {
        isLiked = snapshot.exists;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        isLiked = false;
      });
    }
  }

  Future<void> deleteLike() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('digger_favourites')
        .doc(_favouriteDocId)
        .delete();
  }

  Future<void> addLike() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    await FirebaseFirestore.instance
        .collection('digger_favourites')
        .doc(_favouriteDocId)
        .set({
      'image': widget.image,
      'productname': widget.productname,
      'productprice': widget.productprice,
      'productId': widget.docid,
      'uid': DiggerUserService.currentUid ?? box.read('uid'),
    });
    if (mounted) {
      Utils.toastmessage('${widget.productname} added to favourites');
    }
  }

  Future<void> toggleLike() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    final wasLiked = isLiked;
    setState(() {
      isLiked = !isLiked;
    });

    try {
      if (!wasLiked) {
        await addLike();
      } else {
        await deleteLike();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLiked = wasLiked;
      });
      Utils.flushBarErrorMessage('Could not update favourites.', context);
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
