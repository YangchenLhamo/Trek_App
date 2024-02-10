// // import 'package:curved_navigation_bar/curved_navigation_bar.dart';

// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:trekking_guide/Styles/drawerpage.dart';

// import 'package:trekking_guide/pages/famousPlaces/destinations.dart';
// import 'package:trekking_guide/profileImage/profile.dart';
// import 'package:trekking_guide/pages/trekkingPlaces/basecamp.dart';

// import 'package:trekking_guide/utils/custom_colors.dart';

// import 'package:trekking_guide/utils/size_utils.dart';
// import 'package:trekking_guide/utils/text_styles.dart';

// class FamousLocation {
//   String id;
//   String name;
//   String description;

//   FamousLocation(
//       {required this.id, required this.name, required this.description});
// }

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int index = 0;
//   List<String> trekImages = [
//     'assets/annapurna_trek.jpg',
//     'assets/sagarmatha.jpg',
//     'assets/mardi.jpg'
//   ];
//   int index2 = 0;
//   List<String> destinationImages = [
//     'assets/Pokhara_at_dawn.jpg',
//     'assets/Boudha.jpg',
//     'assets/mountains.jpg'
//   ];
//   List allData = [];

//   final controller = CarouselController();

//   List<String> placeName = ['Pokhara', 'kathmandu', 'Mustang'];
//   List<String> trekName = [
//     'Annapurna Base Camp',
//     'Sagarmatha Base Camp',
//     'Mardi Himal'
//   ];

//   @override
//   void init() {
//     // fetchData();
//     getData();
//     super.initState();
//   }

//   String desc = '';

//   List<FamousLocation?> locations = [];
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//   final CollectionReference _collectionRef =
//       FirebaseFirestore.instance.collection('FamousLocation');

//   Future<void> getData() async {
//     // Get docs from collection reference
//     QuerySnapshot querySnapshot = await _collectionRef.get();

//     // Get data from docs and convert map to List
//     allData = querySnapshot.docs.map((doc) => doc.data()).toList();

//     print(allData);
//   }

//   // Future<void> fetchData() async {
//   //   QuerySnapshot querySnapshot =
//   //       await FirebaseFirestore.instance.collection('FamousPlaces').get();
//   //   debugPrint('the snapshot data is $querySnapshot');

//   //   setState(() {
//   //     locations = querySnapshot.docs.map((doc) {
//   //       return FamousLocation(
//   //         id: doc.id,
//   //         name: doc['name'],
//   //         description: doc['description'],
//   //       );
//   //     }).toList();

//   //     debugPrint('the locations data is $locations');
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _scaffoldKey,
//       drawer: const DrawerWidget(),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             CarouselSlider.builder(
//                 carouselController: controller,
//                 itemCount: destinationImages.length,
//                 itemBuilder: (context, index, realIndex) {
//                   return Stack(children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) => BasecampMountainPage(
//                                   data: [trekName[index]],
//                                 )));
//                       },
//                       child: Container(
//                         // margin: const EdgeInsets.all(3.0),
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage(trekImages[index]),
//                             fit: BoxFit
//                                 .cover, // Adjust the fit property as needed
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(getHorizontalSize(20),
//                           getVerticalSize(40), getHorizontalSize(20), 0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               _scaffoldKey.currentState?.openDrawer();
//                             },
//                             child: Material(
//                               elevation: 5,
//                               borderRadius: BorderRadius.circular(100),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   height: getVerticalSize(25),
//                                   width: getHorizontalSize(25),
//                                   decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.circle),
//                                   child: const Center(
//                                     child: Icon(
//                                       Icons.menu,
//                                       color: CustomColors.primaryColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           GestureDetector(
//                             onTap: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => ProfilePage()));
//                             },
//                             child: Material(
//                               elevation: 5,
//                               borderRadius: BorderRadius.circular(100),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   height: getVerticalSize(25),
//                                   width: getHorizontalSize(25),
//                                   decoration: const BoxDecoration(
//                                       color: Colors.white,
//                                       shape: BoxShape.circle),
//                                   child: const Center(
//                                     child: Icon(
//                                       Icons.person,
//                                       color: CustomColors.primaryColor,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                     Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         trekName[index],
//                         style: Styles.textWhite20,
//                       ),
//                     ),
//                     Container(
//                       margin: EdgeInsets.fromLTRB(
//                           getHorizontalSize(20), 0, 0, getVerticalSize(30)),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {},
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: CustomColors.primaryColor,
//                                 padding: EdgeInsets.zero,
//                                 fixedSize: Size(getHorizontalSize(100),
//                                     getVerticalSize(40))),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(
//                                   Icons.bookmark_add,
//                                   color: Colors.white,
//                                   size: getSize(20),
//                                 ),
//                                 Text(
//                                   'Save Now',
//                                   style: Styles.textWhite15,
//                                 )
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     )
//                   ]);
//                 },
//                 options: CarouselOptions(
//                     height: getVerticalSize(500),
//                     aspectRatio:
//                         getHorizontalSize(350), // Adjust the aspect ratio
//                     viewportFraction: 1.0, //
//                     // autoPlay: true,
//                     enableInfiniteScroll: true,
//                     autoPlayAnimationDuration: const Duration(seconds: 2),
//                     // enlargeCenterPage: true,
//                     onPageChanged: (index, reason) =>
//                         setState(() => index2 = index))),
//             SafeArea(
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.6,
//                   ),
//                   AnimatedSmoothIndicator(
//                     activeIndex: index2,
//                     count: destinationImages.length,
//                     effect: WormEffect(
//                         dotHeight: getVerticalSize(8),
//                         dotWidth: getHorizontalSize(8),
//                         spacing: getSize(10),
//                         dotColor: Colors.grey.shade200,
//                         activeDotColor: Colors.grey.shade500,
//                         paintStyle: PaintingStyle.fill),
//                   ),
//                   SizedBox(
//                     height: getVerticalSize(40),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.fromLTRB(
//                         getHorizontalSize(8), 0, getHorizontalSize(200), 0),
//                     child: Text(
//                       "Popular Destination",
//                       style: Styles.textBlack20B,
//                     ),
//                   ),
//                   SizedBox(
//                     height: getVerticalSize(30),
//                   ),
//                   ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: destinationImages.length,
//                       shrinkWrap: true,
//                       itemBuilder: (BuildContext context, int index) {
//                         // Access the data from famousPlacesList
//                         // String placeName = famousPlacesList[index]['placeName'];
//                         return Padding(
//                             padding: const EdgeInsets.only(
//                                 bottom: 15, left: 20, right: 20),
//                             child: Stack(
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     Navigator.of(context).push(
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 DestinationPage(
//                                                   data: [placeName[index]],
//                                                   // data: [locations[index]],
//                                                 )));
//                                     // navigateToPage(index, context);
//                                   },
//                                   child: Container(
//                                     height: getVerticalSize(300),
//                                     decoration: BoxDecoration(
//                                       color: Colors.black,
//                                       borderRadius: BorderRadius.circular(20),
//                                       image: DecorationImage(
//                                           image: AssetImage(
//                                               destinationImages[index]),
//                                           fit: BoxFit.cover,
//                                           opacity: 0.8),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                   margin: EdgeInsets.fromLTRB(
//                                       getHorizontalSize(20),
//                                       getVerticalSize(240),
//                                       0,
//                                       0),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: [
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           Navigator.of(context).push(
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       DestinationPage(
//                                                         data: [
//                                                           [
//                                                             allData[index]
//                                                                 .toString(),
//                                                             allData[index][
//                                                                     'Description']
//                                                                 .toString(),
//                                                           ]
//                                                         ],
//                                                       )));
//                                         },
//                                         style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.white,
//                                             padding: EdgeInsets.zero,
//                                             fixedSize: Size(
//                                                 getHorizontalSize(100),
//                                                 getVerticalSize(40))),
//                                         child: Text(
//                                           // placeName[index],
//                                           desc,
//                                           style: Styles.textBlack16,
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 )
//                               ],
//                             ));
//                       })
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trekking_guide/components/drawerpage.dart';
import 'package:trekking_guide/authFiles/all_data.dart';

import 'package:trekking_guide/pages/famousPlaces/famousPlace.dart';

import 'package:trekking_guide/pages/ForAdminSide/add_trekkingPlaces.dart';
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

  List<String> trekImages = [
    'assets/annapurna_trek.jpg',
    'assets/gokyo.jpeg',
    'assets/poonhillTrek.jpg',
    'assets/langtang-valley-with-lakes.jpg',
    'assets/manaslu.jpeg',
    'assets/Mardi-Himal.jpg',
    'assets/dhaulagiri.jpg',
    'assets/sagarmatha.jpg',
    'assets/tsum.jpg',
    'assets/upper-mustang-trek.jpeg'
  ];

  List<String> imageList2 = [
    'assets/annapurna_trek.jpg',
    'assets/sagarmatha.jpg',
    'assets/mardi.jpg'
  ];
  List<String> trekName = [
    'Annapurna Base Camp',
    'Sagarmatha Base Camp',
    'Mardi Himal'
  ];

  final controller = CarouselController();

  // @override
  // void init() {
  //   super.initState();
  // }

  String desc = '';
  bool isLoading = true;
  // late List<dynamic> images;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: const DrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Padding(
            //   padding: EdgeInsets.fromLTRB(getHorizontalSize(20),
            //       getVerticalSize(30), getHorizontalSize(20), 0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           _scaffoldKey.currentState?.openDrawer();
            //         },
            //         child: Material(
            //           elevation: 5,
            //           borderRadius: BorderRadius.circular(100),
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Container(
            //               height: getVerticalSize(25),
            //               width: getHorizontalSize(25),
            //               decoration: const BoxDecoration(
            //                   color: Colors.white, shape: BoxShape.circle),
            //               child: const Center(
            //                 child: Icon(
            //                   Icons.menu,
            //                   color: CustomColors.primaryColor,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //       // Add Search Bar here

            //       //                     SizedBox(
            //       //                       height: getVerticalSize(40),
            //       //                       width: getHorizontalSize(230),
            //       //                       // padding: EdgeInsets.fromLTRB(0,0, 0, getVerticalSize(10)),
            //       //                       child: TextField(
            //       //                         decoration: InputDecoration(
            //       //                           contentPadding: EdgeInsets.all(5),
            //       //                           hintText: 'Search...',
            //       //                           hintStyle: Styles.hintTextStyle20,
            //       //                           border: OutlineInputBorder(
            //       //                             borderRadius:
            //       //                                 BorderRadius.circular(10.0),
            //       //                           ),
            //       //                           filled: true,
            //       //                           fillColor: Colors.white,
            //       //                         ),
            //       //                       ),
            //       //                     ),
            //       GestureDetector(
            //         onTap: () {
            //           Navigator.of(context).push(MaterialPageRoute(
            //               builder: (context) => ProfilePage()));
            //         },
            //         child: Material(
            //           elevation: 5,
            //           borderRadius: BorderRadius.circular(100),
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Container(
            //               height: getVerticalSize(25),
            //               width: getHorizontalSize(25),
            //               decoration: const BoxDecoration(
            //                   color: Colors.white, shape: BoxShape.circle),
            //               child: const Center(
            //                 child: Icon(
            //                   Icons.person,
            //                   color: CustomColors.primaryColor,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('TrekkingPlaces')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) =>
                  CarouselSlider.builder(
                      carouselController: controller,
                      itemCount: snapshot.data?.docs.length ?? 0,
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
                                        image: AssetImage('assets/load.png'),
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
                                // Add Search Bar here

                                //                     SizedBox(
                                //                       height: getVerticalSize(40),
                                //                       width: getHorizontalSize(230),
                                //                       // padding: EdgeInsets.fromLTRB(0,0, 0, getVerticalSize(10)),
                                //                       child: TextField(
                                //                         decoration: InputDecoration(
                                //                           contentPadding: EdgeInsets.all(5),
                                //                           hintText: 'Search...',
                                //                           hintStyle: Styles.hintTextStyle20,
                                //                           border: OutlineInputBorder(
                                //                             borderRadius:
                                //                                 BorderRadius.circular(10.0),
                                //                           ),
                                //                           filled: true,
                                //                           fillColor: Colors.white,
                                //                         ),
                                //                       ),
                                //                     ),
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
                                getVerticalSize(320), 0, 0),
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
                          Container(
                            margin: EdgeInsets.fromLTRB(getHorizontalSize(20),
                                0, 0, getVerticalSize(30)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          CustomColors.primaryColor,
                                      padding: EdgeInsets.zero,
                                      fixedSize: Size(getHorizontalSize(100),
                                          getVerticalSize(40))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                        size: getSize(20),
                                      ),
                                      Text(
                                        'Add to list',
                                        style: Styles.textWhite15,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
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
                    AnimatedSmoothIndicator(
                      activeIndex: index2,
                      count: trekImages.length,
                      effect: WormEffect(
                          dotHeight: getVerticalSize(8),
                          dotWidth: getHorizontalSize(8),
                          spacing: getSize(10),
                          dotColor: Colors.grey.shade200,
                          activeDotColor: Colors.grey.shade500,
                          paintStyle: PaintingStyle.fill),
                    ),
                    SizedBox(
                      height: getVerticalSize(20),
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
                                getHorizontalSize(140), getVerticalSize(50)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add More',
                                style: Styles.textWhite24,
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
                                // physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data?.docs.length,
                                // itemCount: 3,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  var placedesc = snapshot.data?.docs;
                                  // Access the data from famousPlacesList
                                  // String placeName = famousPlacesList[index]['placeName'];
                                  return Padding(
                                      padding:  EdgeInsets.only(top: getVerticalSize(10),
                                          bottom: getVerticalSize(10), left: getHorizontalSize(20), ),
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
                                            margin: EdgeInsets.fromLTRB(
                                                getHorizontalSize(30),
                                                getVerticalSize(150),
                                                0,
                                                getVerticalSize(20)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Navigator.of(context).push(
                                                    //     MaterialPageRoute(
                                                    //         builder: (context) => DestinationPage(
                                                    //             title: placedesc?[index]
                                                    //                     .id ??
                                                    //                 "NA",
                                                    //             description:
                                                    //                 placedesc?[index]["Description"] ??
                                                    //                     "NA",
                                                    //             images: placedesc?[index][
                                                    //                     "Images"] ??
                                                    //                 [],
                                                    //             price: placedesc?[index][
                                                    //                     "price"] ??
                                                    //                 "NA",
                                                    //             likes: placedesc?[index]
                                                    //                     ["price"] ??
                                                    //                 []

                                                    //             // data: [locations[index]],
                                                    //             )));
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Colors.white,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          fixedSize: Size(
                                                              getHorizontalSize(
                                                                  100),
                                                              getVerticalSize(
                                                                  40))),
                                                  child: Text(
                                                    placedesc?[index].id ?? "",
                                                    // allData,

                                                    style: Styles.textBlack18,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
                                }),
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(15),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //         builder: (context) => SeeAllPage()));
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //       backgroundColor: CustomColors.primaryColor,
                    //       padding: EdgeInsets.zero,
                    //       fixedSize: Size(
                    //           getHorizontalSize(120), getVerticalSize(50))),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Text(
                    //         'See All',
                    //         style: Styles.textWhite24,
                    //       ),
                    //       Icon(
                    //         Icons.arrow_forward,
                    //         color: Colors.white,
                    //         size: getSize(20),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    
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
