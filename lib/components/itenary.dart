// // import 'package:flutter/material.dart';
// // import 'package:pdfx/pdfx.dart';

// // class ItenaryPage extends StatefulWidget {
// //   const ItenaryPage({Key? key}) : super(key: key);

// //   @override
// //   State<ItenaryPage> createState() => _ItenaryPageState();
// // }

// // class _ItenaryPageState extends State<ItenaryPage> {
// //   late PdfControllerPinch pdfControllerPinch;

// //   int totalPageCount = 0, currentPage = 1;

// //   @override
// //   void initState() {
// //     super.initState();
// //     pdfControllerPinch = PdfControllerPinch(
// //         document: PdfDocument.openAsset('assets/EverestBAseCamp.pdf'));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text(
// //           "PDF Viewer",
// //           style: TextStyle(
// //             color: Colors.white,
// //           ),
// //         ),
// //         backgroundColor: Colors.red,
// //       ),
// //       body: _buildUI(),
// //     );
// //   }

// //   Widget _buildUI() {
// //     return Column(
// //       children: [
// //         Row(
// //           mainAxisSize: MainAxisSize.max,
// //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           crossAxisAlignment: CrossAxisAlignment.center,
// //           children: [
// //             Text("Total Pages: $totalPageCount"),
// //             IconButton(
// //               onPressed: () {
// //                 pdfControllerPinch.previousPage(
// //                   duration: const Duration(
// //                     milliseconds: 500,
// //                   ),
// //                   curve: Curves.linear,
// //                 );
// //               },
// //               icon: const Icon(
// //                 Icons.arrow_back,
// //               ),
// //             ),
// //             Text("Current Page: $currentPage"),
// //             IconButton(
// //               onPressed: () {
// //                 pdfControllerPinch.nextPage(
// //                   duration: const Duration(
// //                     milliseconds: 500,
// //                   ),
// //                   curve: Curves.linear,
// //                 );
// //               },
// //               icon: const Icon(
// //                 Icons.arrow_forward,
// //               ),
// //             ),
// //           ],
// //         ),
// //         _pdfView(),
// //       ],
// //     );
// //   }

// //   Widget _pdfView() {
// //     return Expanded(
// //       child: PdfViewPinch(
// //         scrollDirection: Axis.vertical,
// //         controller: pdfControllerPinch,
// //         onDocumentLoaded: (doc) {
// //           setState(() {
// //             totalPageCount = doc.pagesCount;
// //           });
// //         },
// //         onPageChanged: (page) {
// //           setState(() {
// //             currentPage = page;
// //           });
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void showFullScreenImageDialog(BuildContext context, String imageName) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       var widget;
//       return Dialog(
//         insetPadding: EdgeInsets.zero, // Remove default dialog padding
//         child: GestureDetector(
//           onTap: () {
//             Navigator.of(context).pop(); // Close the dialog on tap
//           },
//           child: Container(
//             width: double.infinity, // Make container full width
//             height: double.infinity, // Make container full height
//             child: StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('TrekkingPlaces')
//                   .doc(widget.title)
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }

//                 if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 }

//                 if (!snapshot.hasData || !snapshot.data!.exists) {
//                   return Center(child: Text('Image not found'));
//                 }

//                 // Extract the image URL from the document
//                 String imageUrl = snapshot.data!.get('itenary');

//                 return Image.network(
//                   imageUrl,
//                   fit: BoxFit.fitHeight,
//                 );
//               },
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
