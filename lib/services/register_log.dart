// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// Future registerUser({
//   required String name,
//   required String email,
//   required String phoneNumber,
//   required String dateOfBirth,
//   required String password,
//   required String imageUrl,
//   required BuildContext context,
// }) async {
//   FirebaseAuth auth = FirebaseAuth.instance;

//   auth
//       .createUserWithEmailAndPassword(email: email, password: password)
//       .then((signedInUser) => FirebaseFirestore.instance
//               .collection("Users")
//               .doc(signedInUser.user!.uid)
//               .set({
//             "name": name,
//             "email": email,
//             "Phone": phoneNumber,
//             "favourites": [],
//             'Date of Birth': dateOfBirth,
//             'imageLink': imageUrl,
//           }))
//       .then((value) {
//     print('created a new account');
//     Navigator.pushReplacementNamed(context, '/bottom_nav'); // Assuming route name for BottomNav is '/bottom_nav'
//   }).onError((error, stackTrace) {
//     print('Error ${error.toString()}');
//     Fluttertoast.showToast(msg: error.toString());
//   });
// }
