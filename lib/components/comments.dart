// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:trekking_guide/utils/size_utils.dart';

// class CommentsField extends StatefulWidget {
//   final String title;
//   final String text;
//   final String user;
//   final String time;
//   CommentsField(
//       {super.key,
//       required this.text,
//       required this.user,
//       required this.time,
//       required this.title});

//   @override
//   State<CommentsField> createState() => _CommentsFieldState();
// }

// final currentUser = FirebaseAuth.instance.currentUser!;
// final _commentTextController = TextEditingController();
// // add comment
// void addComment(String commentText) {
//   // write the comment to firestore under the comments collection
//   // String? name;
//   FirebaseFirestore.instance
//       .collection("TrekkingPlaces")
//       .doc(widget.title)
//       .collection("Comments")
//       .add({
//     "CommentText": commentText,
//     "CommentedBy": currentUser.email,
//     "CommentTime": Timestamp.now()
//   });
// }

// void showCommentDialog(BuildContext context) {
//   showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//             title: Text("Add Comment"),
//             content: TextField(
//               controller: _commentTextController,
//               decoration: InputDecoration(hintText: "Write a comment.."),
//             ),
//             actions: [
//               // post button
//               TextButton(
//                   onPressed: () {
//                     // add comment
//                     addComment(_commentTextController.text,);
//                     Navigator.pop(context);

//                     // clear controller
//                     _commentTextController.clear();
//                   },
//                   child: Text("Post")),

//               // cancel button
//               TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                     // clear controller
//                     _commentTextController.clear();
//                   },
//                   child: Text("Cancel"))
//             ],
//           ));
// }

// class _CommentsFieldState extends State<CommentsField> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // decoration: BoxDecoration(
//         //   color: Colors.pink,
//         //   borderRadius: BorderRadius.circular(4),
//         // ),
//         // child: Container(
//         //   height: getVerticalSize(200),
//         //   width: getHorizontalSize(200),
//         //   decoration: BoxDecoration(
//         //     color: Colors.black
//         //   ),
//         //   child: Column(
//         //     children: [
//         //       Text(widget.text),
//         //       Row(children: [Text('.'), Text(widget.user), Text(widget.time)])
//         //     ],
//         //   ),
//         // ),
//         );
//   }
// }
