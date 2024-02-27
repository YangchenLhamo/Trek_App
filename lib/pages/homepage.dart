import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trekking_guide/components/drawerpage.dart';
import 'package:trekking_guide/authFiles/all_data.dart';
import 'package:trekking_guide/pages/ForAdminSide/add_destination.dart';

import 'package:trekking_guide/pages/famousPlaces/famousPlace.dart';

import 'package:trekking_guide/pages/ForAdminSide/add_trekkingPlaces.dart';
import 'package:trekking_guide/pages/trekkingPlaces/see_all_page.dart';
import 'package:trekking_guide/profileImage/profile.dart';
import 'package:trekking_guide/pages/trekkingPlaces/trekkingPlaces.dart';

import 'package:trekking_guide/utils/custom_colors.dart';

import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class FamousLocation {
  String id;
  String name;
  String description;

  FamousLocation(
      {required this.id, required this.name, required this.description});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index2 = 0;

  final controller = CarouselController();

  String desc = '';
 
  // late List<dynamic> images;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    bool _isLoading = true;
   void initState() {
    super.initState();
    // Simulate loading for 1 second
    Future.delayed(const Duration(seconds:2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerWidget(),
      body: 
        _isLoading
          ? const Center(
              // Show loading indicator
              child: CircularProgressIndicator(),
            )
      :SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('TrekkingPlaces')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) =>
                  CarouselSlider.builder(
                      carouselController: controller,
                      itemCount: 4,
                      itemBuilder: (context, index, realIndex) {
                        var placedesc = snapshot.data?.docs;
                        return Stack(children: [
                          GestureDetector(
                            onTap: () {
                              // when the pages are open then they will be stored in the alldata collection
                              AllData().addAllData(
                                  placedesc?[index].id ?? "NA",
                                  placedesc?[index]["Description"] ?? "NA",
                                  placedesc?[index]["Images"] ?? [],
                                  placedesc?[index]["price"] ?? '',
                                  placedesc?[index]["itenary"] ?? '');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => BasecampMountainPage(
                                        title: placedesc?[index].id ?? "NA",
                                        description: placedesc?[index]
                                                ["Description"] ??
                                            "NA",
                                        images:
                                            placedesc?[index]["Images"] ?? [],
                                        itenary:
                                            placedesc?[index]["itenary"] ?? " ",
                                        likes: placedesc?[index]["likes"] ?? "",
                                        price: placedesc?[index]["price"] ?? "",
                                      )));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                image: placedesc?[index]['Images'] != null &&
                                        placedesc?[index]['Images']!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(
                                            placedesc?[index]['Images'][0]),
                                        fit: BoxFit.cover,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage('assets/loading.png'),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(getHorizontalSize(20),
                                getVerticalSize(40), getHorizontalSize(20), 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _scaffoldKey.currentState?.openDrawer();
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
                                        child: const Center(
                                          child: Icon(
                                            Icons.menu,
                                            color: CustomColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfilePage()));
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
                                        child: const Center(
                                          child: Icon(
                                            Icons.person,
                                            color: CustomColors.primaryColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: getVerticalSize(50),
                            width: getHorizontalSize(260),
                            margin: EdgeInsets.fromLTRB(getHorizontalSize(50),
                                getVerticalSize(380), 0, 0),
                            padding: EdgeInsets.only(top: getVerticalSize(10)),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              placedesc?[index].id ?? "",
                              textAlign: TextAlign.center,
                              style: Styles.textBlack20,
                            ),
                          ),
                        ]);
                      },
                      options: CarouselOptions(
                          height: getVerticalSize(500),
                          aspectRatio:
                              getHorizontalSize(350), // Adjust the aspect ratio
                          viewportFraction: 1.0, //
                          // autoPlay: true,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration: const Duration(seconds: 2),
                          // enlargeCenterPage: true,
                          onPageChanged: (index, reason) =>
                              setState(() => index2 = index))),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedSmoothIndicator(
                          activeIndex: index2,
                          count: 4,
                          effect: WormEffect(
                              dotHeight: getVerticalSize(8),
                              dotWidth: getHorizontalSize(8),
                              spacing: getSize(10),
                              dotColor: Colors.grey.shade200,
                              activeDotColor: Colors.grey.shade500,
                              paintStyle: PaintingStyle.fill),
                        ),
                        SizedBox(
                          width: getHorizontalSize(80),
                        ),
                        MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SeeAllPage(
                                        title: '',
                                      )));
                            },
                            color: CustomColors.primaryColor,
                            padding: EdgeInsets.all(5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text('See All ', style: Styles.textWhite18)),
                        SizedBox(
                          width: getHorizontalSize(10),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: getVerticalSize(15),
                    ),
                    // show only when the user is admin

                    if (FirebaseAuth.instance.currentUser?.email ==
                        'admin@gmail.com') // Check if the current user is admin
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddTrekkingPlaces(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.primaryColor,
                            padding: EdgeInsets.zero,
                            fixedSize: Size(
                                getHorizontalSize(250), getVerticalSize(40)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add More Trekking Places',
                                style: Styles.textWhite20,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: getSize(20),
                              ),
                            ],
                          )),

                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    Text(
                      "Popular Destination",
                      style: Styles.textBlack26B,
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: getVerticalSize(30),
                    ),
                    SizedBox(
                      height: getVerticalSize(280),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('FamousPlaces')
                            .snapshots(),
                        builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) =>
                            ListView.builder(
                                itemCount: snapshot.data?.docs.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  var placedesc = snapshot.data?.docs;

                                  return Padding(
                                      padding: EdgeInsets.only(
                                        top: getVerticalSize(10),
                                        bottom: getVerticalSize(10),
                                        left: getHorizontalSize(20),
                                      ),
                                      child: Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              AllData().addAllData(
                                                placedesc?[index].id ?? "NA",
                                                placedesc?[index]
                                                        ["Description"] ??
                                                    "NA",
                                                placedesc?[index]["Images"] ??
                                                    [],
                                                placedesc?[index]["price"] ??
                                                    '',
                                                placedesc?[index]["itenary"] ??
                                                    '',
                                                // placedesc?[index]["likes"] ?? []
                                              );
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) => DestinationPage(
                                                          title:
                                                              placedesc?[index]
                                                                      .id ??
                                                                  "NA",
                                                          description:
                                                              placedesc?[index][
                                                                      "Description"] ??
                                                                  "NA",
                                                          images: placedesc?[index]
                                                                  ["Images"] ??
                                                              [],
                                                          price: placedesc?[index]
                                                                  ["price"] ??
                                                              "NA",
                                                          likes: placedesc?[index]
                                                                  ["likes"] ??
                                                              []

                                                          // data: [locations[index]],
                                                          )));
                                              // navigateToPage(index, context);
                                            },
                                            child: Container(
                                              height: getVerticalSize(250),
                                              width: getHorizontalSize(250),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: placedesc?[index]
                                                                ['Images'] !=
                                                            null &&
                                                        placedesc?[index]
                                                                ['Images']!
                                                            .isNotEmpty
                                                    ? DecorationImage(
                                                        image: NetworkImage(
                                                            placedesc?[index]
                                                                ['Images'][0]),
                                                        fit: BoxFit.cover,
                                                      )
                                                    : const DecorationImage(
                                                        image: AssetImage(
                                                            'assets/load.png'),
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            height: getVerticalSize(35),
                                            width: getHorizontalSize(100),
                                            padding: EdgeInsets.only(
                                                bottom: getVerticalSize(6)),
                                            margin: EdgeInsets.fromLTRB(
                                                getHorizontalSize(30),
                                                getVerticalSize(190),
                                                0,
                                                getVerticalSize(20)),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  placedesc?[index].id ?? "",
                                                  // allData,

                                                  style: Styles.textBlack18,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
                                }),
                      ),
                    ),
                    if (FirebaseAuth.instance.currentUser?.email ==
                        'admin@gmail.com') // Check if the current user is admin
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddDestinationPlaces(),
                            ));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.primaryColor,
                            padding: EdgeInsets.zero,
                            fixedSize: Size(
                                getHorizontalSize(200), getVerticalSize(40)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add More Destination',
                                style: Styles.textWhite18,
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: getSize(20),
                              ),
                            ],
                          )),
                    SizedBox(
                      height: getVerticalSize(15),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
