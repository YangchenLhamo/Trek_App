import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:trekking_guide/components/dateformatter.dart';

import 'package:trekking_guide/pages/trekkingPlaces/expense_calc.dart';
import 'package:trekking_guide/profileImage/save_image.dart';
import 'package:trekking_guide/services/comments_log.dart';

import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';
// import 'dart:developer';

// ignore: must_be_immutable
class BasecampMountainPage extends StatefulWidget {
  BasecampMountainPage(
      {super.key,
      required this.title,
      required this.description,
      required this.images,
      required this.price,
      this.itenary,
      this.likes});
  String title;
  String description;
  List<dynamic> images;
  String price;
  String? itenary;
  List<dynamic>? likes;
  // bool? hasItenary;

  @override
  State<BasecampMountainPage> createState() => _BasecampMountainPageState();
}

class _BasecampMountainPageState extends State<BasecampMountainPage> {
  bool isSeeMore = false;
  String? name;

  final controller = CarouselController();

  bool showImage = false;
  TextEditingController _commentTextController = TextEditingController();
  List<String> commentIds = [];

  bool _isFavourite = false;

  @override
  void initState() {
    bool issaved = widget.likes!.contains(user?.email ?? 'Na');
    _isFavourite = issaved;
    super.initState();

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
              .collection("TrekkingPlaces")
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
              .collection("TrekkingPlaces")
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
                    Row(
                      children: [
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
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: Icon(
                                      _isFavourite
                                          ? Icons.favorite
                                          : Icons.favorite_outline_outlined,
                                      color: _isFavourite
                                          ? Colors.red
                                          : CustomColors.primaryColor),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
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
                                    ),
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
                                ),
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
                            // Image(image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/trekguide-73723.appspot.com/o/Trekking%20Places%2FMardi%2FMardi-Himal-.jpg?alt=media&token=590a4ead-40f7-413d-a426-6c6d387d2dfc'))

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ExpenseCalculatorScreen(title: widget.title,)));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          CustomColors.primaryColor,
                                      padding: EdgeInsets.zero,
                                      fixedSize: Size(getHorizontalSize(150),
                                          getVerticalSize(40))),
                                  child: Text(
                                    'Book Now',
                                    style: Styles.textWhite20,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      showImage = !showImage;
                                    });
                                    if (showImage) {
                                      showFullScreenImageDialog(
                                          context, widget.itenary ?? 'NA');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          CustomColors.primaryColor,
                                      padding: EdgeInsets.only(
                                          left: getHorizontalSize(30)),
                                      fixedSize: Size(getHorizontalSize(150),
                                          getVerticalSize(40))),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Itenary',
                                        style: Styles.textWhite20,
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: getSize(25),
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                                  "Comments",
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

                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("TrekkingPlaces")
                                  .doc(widget.title)
                                  .collection("Comments")
                                  .orderBy("CommentTime", descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.data!.docs.isNotEmpty) {
                                  return Container(
                                    height: getVerticalSize(200),
                                    width: getHorizontalSize(650),
                                    decoration: ShapeDecoration(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: getSize(2),
                                            color: CustomColors.primaryColor),
                                        borderRadius:
                                            BorderRadius.circular(getSize(10)),
                                      ),
                                    ),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      // physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        final commentData =
                                            snapshot.data!.docs[index].data()
                                                as Map<String, dynamic>;
                                        final commentId =
                                            snapshot.data!.docs[index].id;

                                        commentIds.add(
                                            commentId); // Add comment ID to the list

                                        // Check if the comment was made by the current user
                                        final currentUserEmail = FirebaseAuth
                                            .instance.currentUser!.email;
                                        final commentOwnerEmail =
                                            commentData['CommentedBy'];
                                        final isCurrentUserComment =
                                            currentUserEmail ==
                                                commentOwnerEmail;

                                        // Only show the delete icon if the comment was made by the current user
                                        final shouldShowDeleteIcon =
                                            isCurrentUserComment;

                                        return Container(
                                          // height: getVerticalSize(80),
                                          margin: EdgeInsets.only(
                                              left: getHorizontalSize(5),
                                              right: getHorizontalSize(5),
                                              top: getVerticalSize(15)),
                                          padding: EdgeInsets.only(
                                            top: getVerticalSize(8),
                                            left: getHorizontalSize(8),
                                            bottom: getVerticalSize(15),
                                          ),
                                          decoration: BoxDecoration(
                                            color: CustomColors.primaryColor
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      commentData[
                                                          'CommentText'],
                                                      style: Styles.textBlack16,
                                                      maxLines:
                                                          3, // Limit to 3 lines
                                                      overflow: TextOverflow
                                                          .ellipsis, // Show ellipsis for overflow
                                                    ),
                                                  ),
                                                  if (shouldShowDeleteIcon)
                                                    GestureDetector(
                                                      onTap: () {
                                                        // Call function to delete comment
                                                        deleteComment(
                                                            widget.title,
                                                            commentId);
                                                      },
                                                      child: SizedBox(
                                                        width:
                                                            getVerticalSize(40),
                                                        child: Icon(
                                                          Icons.delete,
                                                          size: getSize(20),
                                                        ),
                                                      ),
                                                    ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        showCommentDialog(
                                                            context,
                                                            _commentTextController,
                                                            widget.title);
                                                      },
                                                      child: Icon(Icons.reply)),
                                                  SizedBox(
                                                    width:
                                                        getHorizontalSize(20),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                  height: getVerticalSize(10)),
                                              Row(
                                                children: [
                                                  Text(
                                                    commentData['CommentedBy'],
                                                    style: Styles.commentText16,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        getHorizontalSize(15),
                                                  ),
                                                  Text(
                                                    ".",
                                                    style: Styles.commentText16,
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        getHorizontalSize(15),
                                                  ),
                                                  Text(
                                                    formatDate(commentData[
                                                        'CommentTime']),
                                                    style: Styles.commentText16,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
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

  // to show itenary images
  void showFullScreenImageDialog(BuildContext context, String imageName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog on tap
            },
            child: Container(
              width: getHorizontalSize(350),
              height: getVerticalSize(400),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('TrekkingPlaces')
                    .doc(widget.title)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Center(child: Text('Image not found'));
                  }

                  // Extract the image URL from the document
                  String imageUrl = snapshot.data!.get('itenary');

                  return Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
