// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';
// import 'package:trekking_guide/utils/custom_colors.dart';

// import 'package:trekking_guide/utils/size_utils.dart';
// import 'package:trekking_guide/utils/text_styles.dart';

// class ManageProfilePage extends StatefulWidget {
//   const ManageProfilePage({super.key});

//   @override
//   State<ManageProfilePage> createState() => _ManageProfilePageState();
// }

// class _ManageProfilePageState extends State<ManageProfilePage> {
//   String name = "name";
//   String email = "email";

//   String phoneNumber = 'Phone';
//   String dateofbirth = 'Date Of Birth';

//   TextEditingController dateController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneNumberController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     phoneNumberController.text = phoneNumber;
//     emailController.text = email;
//     dateController.text = dateofbirth;
//     nameController.text = name;
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
//           "Manage Profiles",
//           style: Styles.textWhite34B,
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection('Users').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView(
//                   children:
//                       snapshot.data!.docs.map((DocumentSnapshot document) {
//                     Map<String, dynamic> data =
//                         document.data() as Map<String, dynamic>;
//                     return Container(
//                       margin: EdgeInsets.only(
//                           left: getHorizontalSize(20),
//                           right: getHorizontalSize(20),
//                           top: getVerticalSize(20)),
//                       child: Card(
//                         color: CustomColors.primaryColor.withOpacity(0.5),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                             side: BorderSide(
//                               color: Colors.black, // Set the border color
//                               width: getSize(1),
//                             )),
//                         margin: EdgeInsets.all(10),
//                         child: Padding(
//                           padding: EdgeInsets.all(10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: getSize(40),
//                                     backgroundImage:
//                                         NetworkImage(data['imageLink']),
//                                   ),
//                                   SizedBox(
//                                     width: getHorizontalSize(160),
//                                   ),
//                                   GestureDetector(
//                                       onTap: () {},
//                                       child: Icon(
//                                         Icons.delete,
//                                         size: getSize(40),
//                                       ))
//                                 ],
//                               ),
//                               SizedBox(height: getVerticalSize(20)),
//                               Text('Name : ${data['name']}',
//                                   style: Styles.textBlack18B),
//                               SizedBox(height: getVerticalSize(10)),
//                               Text('Email: ${data['email']}',
//                                   style: Styles.textBlack18),
//                               SizedBox(
//                                 height: getVerticalSize(10),
//                               ),
//                               Text(
//                                 'Phone: ${data['Phone']}',
//                                 style: Styles.textBlack18,
//                               ),
//                               SizedBox(
//                                 height: getVerticalSize(10),
//                               ),
//                               Text(
//                                 'Date of Birth: ${data['Date of Birth']}',
//                                 style: Styles.textBlack18,
//                               ),
//                               // You can add more user details here
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:trekking_guide/utils/custom_colors.dart';

import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class ManageProfilePage extends StatefulWidget {
  const ManageProfilePage({super.key});

  @override
  State<ManageProfilePage> createState() => _ManageProfilePageState();
}

class _ManageProfilePageState extends State<ManageProfilePage> {
  String name = "name";
  String email = "email";

  String phoneNumber = 'Phone';
  String dateofbirth = 'Date Of Birth';

  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    phoneNumberController.text = phoneNumber;
    emailController.text = email;
    dateController.text = dateofbirth;
    nameController.text = name;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_sharp,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              // _scaffoldKey.currentState?.openDrawer();
            },
          ),
        title: Text(
          "Manage Profiles",
          style: Styles.textWhite34B,
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                        
                    return Container(
                      margin: EdgeInsets.only(
                          left: getHorizontalSize(20),
                          right: getHorizontalSize(20),
                          top: getVerticalSize(20)),
                      child: Card(
                        color: CustomColors.primaryColor.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Colors.black, // Set the border color
                              width: getSize(1),
                            )),
                        margin: EdgeInsets.all(10),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: getSize(40),
                                    backgroundImage:
                                        NetworkImage(data['imageLink']),
                                  ),
                                  SizedBox(
                                    width: getHorizontalSize(160),
                                  ),
                                  // GestureDetector(
                                  //     onTap: () async {
                                  //       // Delete user from Firestore
                                  //       await FirebaseFirestore.instance
                                  //           .collection('Users')
                                  //           .doc(document.id)
                                  //           .delete();

                                  //       // Remove user from Firebase Authentication
                                  //       // Remove user from Firebase Authentication
                                  //       User? currentUser =
                                  //           FirebaseAuth.instance.currentUser;
                                  //       if (currentUser != null &&
                                  //           currentUser.uid == document.id) {
                                  //         try {
                                  //           await currentUser.delete();
                                  //           print(
                                  //               'User deleted from Firebase Authentication');
                                  //         } catch (e) {
                                  //           print(
                                  //               'Error deleting user from Firebase Authentication: $e');
                                  //           // Handle error deleting user
                                  //         }
                                  //       }
                                  //       // Remove user from UI by updating the state
                                  //       setState(() {
                                  //         // Remove the deleted user from the snapshot data
                                  //         snapshot.data!.docs.remove(document);
                                  //       });
                                  //     },
                                  //     child: Icon(
                                  //       Icons.delete,
                                  //       size: getSize(40),
                                  //     ))
                                  GestureDetector(
                                      onTap: () async {
                                        // Delete user from Firestore
                                        await FirebaseFirestore.instance
                                            .collection('Users')
                                            .doc(document.id)
                                            .delete()
                                            .then((_) async {
                                          // Remove user from Firebase Authentication
                                          User? currentUser =
                                              FirebaseAuth.instance.currentUser;
                                          if (currentUser != null &&
                                              currentUser.uid == document.id) {
                                            try {
                                              await currentUser.delete();
                                              print(
                                                  'User deleted from Firebase Authentication');
                                            } catch (e) {
                                              print(
                                                  'Error deleting user from Firebase Authentication: $e');
                                              // Handle error deleting user
                                            }
                                          }
                                        }).catchError((error) {
                                          print(
                                              'Error deleting user from Firestore: $error');
                                          // Handle error deleting user from Firestore
                                        });

                                        // Remove user from UI by updating the state
                                        setState(() {
                                          // Remove the deleted user from the snapshot data
                                          snapshot.data!.docs.remove(document);
                                        });
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        size: getSize(40),
                                      ))
                                ],
                              ),
                              SizedBox(height: getVerticalSize(20)),
                              Text('Name : ${data['name']}',
                                  style: Styles.textBlack18B),
                              SizedBox(height: getVerticalSize(10)),
                              Text('Email: ${data['email']}',
                                  style: Styles.textBlack18),
                              SizedBox(
                                height: getVerticalSize(10),
                              ),
                              Text(
                                'Phone: ${data['Phone']}',
                                style: Styles.textBlack18,
                              ),
                              SizedBox(
                                height: getVerticalSize(10),
                              ),
                              Text(
                                'Date of Birth: ${data['Date of Birth']}',
                                style: Styles.textBlack18,
                              ),
                              // You can add more user details here
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
