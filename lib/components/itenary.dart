// // import 'package:flutter/material.dart';
// // import 'package:trekking_guide/utils/size_utils.dart';

// // class ItenaryData{
// //   // bool showImage = false;
// //   void showFullScreenImageDialog(BuildContext context) {
// //     showDialog(
// //       context: context,
// //       builder: (BuildContext context) {
// //         return Dialog(
// //           child: GestureDetector(
// //             onTap: () {
// //               Navigator.of(context).pop(); // Close the dialog on tap
// //             },
// //             child: Container(
// //               width: getHorizontalSize(250),
// //               height: getVerticalSize(400),
              
// //               child: Image.asset(
// //                 'assets/itenary.png',
// //                 fit: BoxFit.fill,
// //               ),
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:trekking_guide/utils/size_utils.dart';

// class ItenaryData {
//   void showFullScreenImageDialog(BuildContext context, String imageName) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           child: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop(); // Close the dialog on tap
//             },
//             child: Container(
//               width: getHorizontalSize(250),
//               height: getVerticalSize(400),
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance
//                     .collection('TrekkingPlaces')
//                     .doc()
//                     .snapshots(),
//                 builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }

//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }

//                   if (!snapshot.hasData || !snapshot.data!.exists) {
//                     return Center(child: Text('Image not found'));
//                   }

//                   // Extract the image URL from the document
//                   String imageUrl = snapshot.data!.get('itenary');

//                   return Image.network(
//                     imageUrl,
//                     fit: BoxFit.fill,
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
