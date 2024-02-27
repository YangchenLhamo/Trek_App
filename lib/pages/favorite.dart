// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:trekking_guide/profileImage/save_image.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  int index = 0;

  final controller = CarouselController();

// to delete favouritedata from the UI and Firestore
  Future<void> deleteData(String itemId) async {
    User? user = FirebaseAuth.instance.currentUser;

    // Step 1: Retrieve the current user's document
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.uid)
        .get();

    // Step 2: Modify the "favourites" field by removing the item
    List<dynamic> favData = userSnapshot['favourites'] ?? [];
    favData.remove(itemId);

    // Step 3: Update the Firestore document with the modified data
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.uid)
        .update({'favourites': favData});
  }
    bool _isLoading = true;
   void initState() {
    super.initState();
    // Simulate loading for 1 second
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text(
          "Favourites",
          style: Styles.textWhite34B,
        ),
        centerTitle: true,
      ),
      body:
      _isLoading
          ? Center(
              // Show loading indicator
              child: CircularProgressIndicator(),
            )
       :FutureBuilder(
        future:
            FirebaseFirestore.instance.collection('Users').doc(user?.uid).get(),
        builder: (context, snapUser) {
          List<dynamic> favData = snapUser.data?["favourites"] ?? [];

          return StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('AllData').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                // compare the list of pages from alldata collection and user favourite
                // and store it to likedPage
                List<QueryDocumentSnapshot> likedPage =
                    snapshot.data?.docs.where((docs) {
                          var placeName = docs['name'].toString().toLowerCase();
                          return favData.any((name) => placeName
                              .contains(name.toString().toLowerCase()));
                        }).toList() ??
                        [];

                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      // shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: likedPage.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(getHorizontalSize(20),
                              getVerticalSize(30), getHorizontalSize(20), 0),
                          padding: EdgeInsets.only(bottom: getVerticalSize(10)),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            children: [
                              Container(
                                height: getVerticalSize(120),
                                width: getHorizontalSize(130),
                                margin: EdgeInsets.only(
                                    right: getHorizontalSize(5)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  image: likedPage[index]['Images'] != null &&
                                          likedPage[index]['Images']!.isNotEmpty
                                      ? DecorationImage(
                                          image: NetworkImage(
                                              likedPage[index]['Images'][0]),
                                          fit: BoxFit.cover,
                                        )
                                      : const DecorationImage(
                                          image:
                                              AssetImage('assets/loading.png'),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: getVerticalSize(10),
                                  ),
                                  Text(
                                    likedPage[index].id,
                                    style: Styles.textBlack20B,
                                  ),
                                  // Text(favData.toString()),
                                  SizedBox(
                                    height: getVerticalSize(20),
                                  ),
                                  Row(
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
                                      SizedBox(
                                        width: getHorizontalSize(40),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Color.fromARGB(
                                                255, 254, 235, 65),
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
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      
                                      SizedBox(
                                        width: getHorizontalSize(20),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          // Step 4: Call deleteData to remove the item from favourites
                                          await deleteData(likedPage[index].id);

                                          // Remove the item from the UI list immediately
                                          setState(() {
                                            likedPage.removeAt(index);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Item deleted successfully'),
                                              ),
                                            );
                                          });
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          size: getSize(40),
                                          color: CustomColors.primaryColor,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                );
              });
        },
      ),
    );
  }
}
