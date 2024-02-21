import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trekking_guide/components/comment_files.dart';
import 'package:trekking_guide/components/comments_log.dart';

import 'package:trekking_guide/profileImage/save_image.dart';

import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

// ignore: must_be_immutable
class DestinationPage extends StatefulWidget {
  DestinationPage({
    super.key,
    required this.title,
    required this.description,
    required this.images,
    required this.price,
    required this.likes,
    this.itenary,
    // required this.likes
  });
  String title;
  String description;
  String price;
  String? itenary;
  List<dynamic> images;
  List<dynamic> likes;

  @override
  State<DestinationPage> createState() => _DestinationPageState();
}

class _DestinationPageState extends State<DestinationPage> {
  bool isSeeMore = false;
  String? name;
  Map<String, dynamic> placeData = {};
  final controller = CarouselController();
  String userid = FirebaseAuth.instance.currentUser!.uid.toString();

  bool _isFavourite = false;

  TextEditingController _commentTextController = TextEditingController();
  List<String> commentIds = [];
  @override
  void initState() {
    // name = widget.data[0];
    getFavorites(userid);
    placeData = {
      "title": widget.title,
      "description": widget.description,
      "images": widget.images,
      "price": widget.price
    };
    bool issaved = widget.likes.contains(user?.email ?? 'Na');
    _isFavourite = issaved;

    super.initState();
    // log(widget.images.toList().toString());
    FirebaseFirestore.instance
        .collection("TrekkingPlaces")
        .doc(widget.title)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Map<String, dynamic>? data = documentSnapshot.data()
            as Map<String, dynamic>?; // Explicit casting
        if (data != null && data.containsKey('favourites')) {
          setState(() {
            _isFavourite = data['favourites'].contains(widget.title) ?? false;
          });
        }
      }
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFavorites(
      String userId) async {
    DocumentSnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance
            .collection('favorites')
            .doc(userId)
            .collection('places')
            .doc(widget.title)
            .get();

    return querySnapshot;
  }

  @override
  Widget build(BuildContext context) {
    _toggleFavourite(String favorite) {
      setState(() {
        _isFavourite = !_isFavourite;
        if (_isFavourite) {
          User? user = FirebaseAuth.instance.currentUser;
          FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({
            "favourites": FieldValue.arrayUnion([favorite]),
          }).then((value) => (_isFavourite = true));
          FirebaseFirestore.instance
              .collection("FamousPlaces")
              .doc(widget.title)
              .update({
            'likes': FieldValue.arrayUnion([user.email])
          });
        } else {
          // FirebaseAuth auth = FirebaseAuth.instance;
          User? user = FirebaseAuth.instance.currentUser;
          FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({
            "favourites": FieldValue.arrayRemove([favorite]),
          }).then((value) => (_isFavourite = false));
          FirebaseFirestore.instance
              .collection("FamousPlaces")
              .doc(widget.title)
              .update({
            'likes': FieldValue.arrayRemove([user.email])
          });
        }
      });
    }

    final lines = isSeeMore ? null : 3;
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: NetworkImage(widget.images[0]),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(context);
                      },
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: getVerticalSize(25),
                            width: getHorizontalSize(25),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: const Center(
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: CustomColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _toggleFavourite(widget.title);
                      },
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(100),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: getVerticalSize(25),
                            width: getHorizontalSize(25),
                            decoration: const BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Center(
                              child: Icon(
                                _isFavourite
                                    ? Icons.favorite
                                    : Icons.favorite_outlined,
                                color: _isFavourite
                                    ? Colors.red
                                    : CustomColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Expanded(
                child: Container(
                  height: getVerticalSize(300),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(getSize(50)),
                          topRight: Radius.circular(getSize(50)))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: getHorizontalSize(20),
                        vertical: getVerticalSize(30)),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: getVerticalSize(20),
                            ),
                            Text(
                              widget.title,
                              style: Styles.textBlack32B,
                            ),
                            SizedBox(
                              height: getVerticalSize(25),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: CustomColors.primaryColor,
                                    ),
                                    Text(
                                      'Nepal',
                                      style: Styles.textBlack20,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.price,
                                      style: Styles.textBlack30B,
                                    ),
                                    Text(
                                      '/Person',
                                      style: Styles.textBlack16,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: getVerticalSize(25),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Trip Details",
                                  style: Styles.textBlack20B,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: Color.fromARGB(255, 254, 235, 65),
                                    ),
                                    Text(
                                      '4.5',
                                      style: Styles.textBlack16,
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: getVerticalSize(20),
                            ),
                            Text(
                              widget.description,
                              maxLines: lines,
                              overflow: isSeeMore
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                              style: Styles.textBlack18,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSeeMore = !isSeeMore;
                                });
                              },
                              child: Text(
                                (isSeeMore ? 'See Less' : 'See More'),
                                style: const TextStyle(
                                    color: CustomColors.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: getVerticalSize(40),
                            ),
                            Text(
                              'Preview',
                              style: Styles.textBlack20B,
                            ),
                            SizedBox(
                              height: getVerticalSize(20),
                            ),
                            CarouselSlider.builder(
                                carouselController: controller,
                                itemCount: widget.images.length,
                                itemBuilder: (context, index, realIndex) {
                                  return Container(
                                    margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(widget.images[
                                              index]), //length of images not working(image not taking th length from database)
                                          fit: BoxFit
                                              .cover, // Adjust the fit property as needed
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  );
                                },
                                options: CarouselOptions(
                                    height: getVerticalSize(200),
                                    aspectRatio: getHorizontalSize(
                                        250), // Adjust the aspect ratio
                                    viewportFraction: 1.0, //
                                    // autoPlay: true,
                                    enableInfiniteScroll: true,
                                    autoPlayAnimationDuration:
                                        const Duration(seconds: 1),
                                    // enlargeCenterPage: true,
                                    onPageChanged: (index, reason) =>
                                        setState(() => index = index))),
                            SizedBox(
                              height: getVerticalSize(10),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(getHorizontalSize(20),
                                  0, 0, getVerticalSize(30)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  SizedBox(
                                    height: getVerticalSize(20),
                                  ),
                                  Divider(
                                    color: CustomColors.primaryColor,
                                    height: getVerticalSize(2),
                                  ),
                                  SizedBox(
                                    height: getVerticalSize(20),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Feedbacks",
                                        style: Styles.textBlack20,
                                      ),
                                      Icon(
                                        Icons.mode_comment,
                                        size: getSize(20),
                                        color: CustomColors.primaryColor,
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: getVerticalSize(10),
                                  ),
                                  CommentsWidget(title: widget.title),
                                  SizedBox(
                                    height: getVerticalSize(20),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      showCommentDialog(context,
                                          _commentTextController, widget.title);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        fixedSize: Size(getHorizontalSize(160),
                                            getVerticalSize(50))),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Add yours...",
                                          style: Styles.textBlack18,
                                        ),
                                        Icon(
                                          Icons.add,
                                          size: getSize(20),
                                          color: CustomColors.primaryColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
