import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:trekking_guide/authFiles/all_data.dart';
import 'package:trekking_guide/pages/trekkingPlaces/trekkingPlaces.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

// class SeeAllPage extends StatefulWidget {
//   const SeeAllPage({super.key});

//   @override
//   State<SeeAllPage> createState() => _SeeAllPageState();
// }

// class _SeeAllPageState extends State<SeeAllPage> {
//   // String name = "name";
//   @override
//   void initState() {
//     super.initState();
//   }
//   void _runFilter(String enteredKeyword) async {
//     QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('TrekkingPlaces') // Replace 'users' with your collection name
//         .where('title', isGreaterThanOrEqualTo: enteredKeyword)
//         .where('title', isLessThan: enteredKeyword + 'z')
//         .get();

//     List<Map<String, dynamic>> results = snapshot.docs.map((DocumentSnapshot document) {
//       return document.data() as Map<String, dynamic>;
//     }).toList();

//     // Refresh the UI
//     // setState(() {
//     //   // _foundUsers = results;
//     // });
//   }

 

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.white,
//         ),
//         title: Text(
//           'Trekking Routes',
//           style: Styles.textWhite28B,
//         ),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 20,
//           ),
//           Padding(
//             padding:  EdgeInsets.only(left: getHorizontalSize(15), right: getHorizontalSize(15)),
//             child: TextField(
//               onChanged: _runFilter,
//               decoration: InputDecoration(
//                 contentPadding:
//                     const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
//                 hintText: "Search",
//                 suffixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(20.0),
//                   borderSide: const BorderSide(),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           Expanded(
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('TrekkingPlaces')
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) =>
//                   ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: snapshot.data?.docs.length ?? 0,
//                 itemBuilder: (context, index) {
//                   var placedesc = snapshot.data?.docs;
//                   return Container(
//                     margin: EdgeInsets.fromLTRB(getHorizontalSize(20),
//                         getVerticalSize(30), getHorizontalSize(20), 0),
//                     padding: EdgeInsets.only(bottom: getVerticalSize(5)),
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10)),
//                     child: Row(
//                       children: [
//                         Container(
//                           height: getVerticalSize(150),
//                           width: getHorizontalSize(130),
//                           margin: EdgeInsets.only(right: getHorizontalSize(5)),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(20),
//                             image: placedesc?[index]['Images'] != null &&
//                                     placedesc?[index]['Images']!.isNotEmpty
//                                 ? DecorationImage(
//                                     image: NetworkImage(
//                                         placedesc?[index]['Images'][0]),
//                                     fit: BoxFit.cover,
//                                   )
//                                 : const DecorationImage(
//                                     image: AssetImage('assets/loading.png'),
//                                     fit: BoxFit.cover,
//                                   ),
//                           ),
//                         ),
//                         Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             SizedBox(
//                               height: getVerticalSize(10),
//                             ),
//                             Text(
//                               placedesc?[index].id ?? "",
//                               style: Styles.textBlack18B,
//                             ),
//                             SizedBox(
//                               height: getVerticalSize(20),
//                             ),
//                             Row(
//                               children: [
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.location_on,
//                                       color: CustomColors.primaryColor,
//                                     ),
//                                     Text(
//                                       'Nepal',
//                                       style: Styles.textBlack20,
//                                     )
//                                   ],
//                                 ),
//                                 SizedBox(
//                                   width: getHorizontalSize(40),
//                                 ),
//                                 Row(
//                                   children: [
//                                     const Icon(
//                                       Icons.star,
//                                       color: Color.fromARGB(255, 254, 235, 65),
//                                     ),
//                                     Text(
//                                       '4.5',
//                                       style: Styles.textBlack16,
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                             SizedBox(
//                               height: getVerticalSize(20),
//                             ),
//                             ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     backgroundColor: CustomColors
//                                         .primaryColor // Set the background color of the button
//                                     ),
//                                 onPressed: () {
//                                   AllData().addAllData(
//                                       placedesc?[index].id ?? "NA",
//                                       placedesc?[index]["Description"] ?? "NA",
//                                       placedesc?[index]["Images"] ?? [],
//                                       placedesc?[index]["price"] ?? '',
//                                       placedesc?[index]["itenary"] ?? '');
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                       builder: (context) =>
//                                           BasecampMountainPage(
//                                             title: placedesc?[index].id ?? "NA",
//                                             description: placedesc?[index]
//                                                     ["Description"] ??
//                                                 "NA",
//                                             images: placedesc?[index]
//                                                     ["Images"] ??
//                                                 [],
//                                             itenary: placedesc?[index]
//                                                     ["itenary"] ??
//                                                 " ",
//                                             likes: placedesc?[index]["likes"] ??
//                                                 "",
//                                             price: placedesc?[index]["price"] ??
//                                                 "",
//                                           )));
//                                 },
//                                 // },
//                                 child: Text(
//                                   "View More...",
//                                   style: Styles.textWhite16,
//                                 ))
//                           ],
//                         )
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
class SeeAllPage extends StatefulWidget {
  const SeeAllPage({super.key});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  // String name = "name";
  @override
  void initState() {
    super.initState();
  }

  void _runFilter(QuerySnapshot snapshot, String enteredKeyword) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('TrekkingPlaces') // Replace 'users' with your collection name
        .where('title', isGreaterThanOrEqualTo: enteredKeyword)
        .where('title', isLessThan: enteredKeyword + 'z')
        .get();

    List<Map<String, dynamic>> results = snapshot.docs.map((DocumentSnapshot document) {
      return document.data() as Map<String, dynamic>;
    }).toList();

    // Refresh the UI
    // setState(() {
    //   // _foundUsers = results;
    // });
  }

  String search = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text(
          'Trekking Routes',
          style: Styles.textWhite28B,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(left: getHorizontalSize(15), right: getHorizontalSize(15)),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  value = search;
                });
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                hintText: "Search",
                suffixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('TrekkingPlaces').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  List<QueryDocumentSnapshot> snapshot1 = snapshot.data?.docs.where((doc) {
                    final trekName = doc['title']?.toString().toLowerCase() ?? '';
                    return trekName.contains(search.toLowerCase());
                  }).toList()??[];
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot1.length,
                    itemBuilder: (context, index) {
                      var placedesc = snapshot1;
                      return Container(
                        margin: EdgeInsets.fromLTRB(getHorizontalSize(20), getVerticalSize(30), getHorizontalSize(20), 0),
                        padding: EdgeInsets.only(bottom: getVerticalSize(5)),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Container(
                              height: getVerticalSize(150),
                              width: getHorizontalSize(130),
                              margin: EdgeInsets.only(right: getHorizontalSize(5)),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: placedesc[index]['Images'] != null && placedesc[index]['Images']!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(placedesc[index]['Images'][0]),
                                        fit: BoxFit.cover,
                                      )
                                    : const DecorationImage(
                                        image: AssetImage('assets/loading.png'),
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
                                  placedesc?[index].id ?? "",
                                  style: Styles.textBlack18B,
                                ),
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
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: getHorizontalSize(40),
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
                                ElevatedButton(
                                    style:
                                        ElevatedButton.styleFrom(backgroundColor: CustomColors.primaryColor // Set the background color of the button
                                            ),
                                    onPressed: () {
                                      AllData().addAllData(placedesc[index].id , placedesc[index]["Description"] ?? "NA",
                                          placedesc[index]["Images"] ?? [], placedesc[index]["price"] ?? '', placedesc[index]["itenary"] ?? '');
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => BasecampMountainPage(
                                                title: placedesc[index].id ,
                                                description: placedesc[index]["Description"] ,
                                                images: placedesc[index]["Images"],
                                                itenary: placedesc[index]["itenary"] ,
                                                likes: placedesc[index]["likes"],
                                                price: placedesc[index]["price"],
                                              )));
                                    },
                                    // },
                                    child: Text(
                                      "View More...",
                                      style: Styles.textWhite16,
                                    ))
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }
}
