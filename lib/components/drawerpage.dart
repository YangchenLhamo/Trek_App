import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:trekking_guide/mainScreens/loginpage.dart';
import 'package:trekking_guide/pages/ForAdminSide/manage_profile.dart';
import 'package:trekking_guide/pages/about_us.dart';
import 'package:trekking_guide/pages/tips_faq.dart';

import 'package:trekking_guide/profileImage/profile.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
// import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  String name = "name";
  String email = "email";
  String profileImageUrl = "";

  @override
  void initState() {
    getUserData();

    super.initState();
  }

// creating user and storing it in a collection 'users'
  void getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var value = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get();
    if (value.exists) {
      setState(() {
        name = value.data()!['name'];
        email = value.data()!['email'];
        profileImageUrl = value.data()!['imageLink'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: getVerticalSize(220),
            child: DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                      radius: getSize(60),
                      backgroundImage: profileImageUrl.isNotEmpty
                          ? NetworkImage(profileImageUrl)
                          : null,
                      child: profileImageUrl.isEmpty
                          ? CircleAvatar(
                              radius: getSize(60),
                              backgroundImage:
                                  const AssetImage('assets/annapurna_trek.jpg'),
                            )
                          : null
            
                      // const AssetImage('assets/annapurna_trek.jpg'),
                      ),
                  const SizedBox(height: 20),
                  Text(name, // Replace with the user's name
                      style: Styles.textBlack20B),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.info,size: getSize(30), color: CustomColors.primaryColor,),
            title:  Text('About Us', style: Styles.textBlack20,),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => AboutUsPage()));
            },
          ),
          ListTile(
            leading:  Icon(Icons.home,size: getSize(30), color: CustomColors.primaryColor,),
            title:  Text('Home',style: Styles.textBlack20,),
            onTap: () {
              // Navigate to the dashboard page (same page)
              Navigator.pop(context);
            },
          ),
          
          ListTile(
            leading: Icon(Icons.person, size: getSize(30), color: CustomColors.primaryColor,),
            title: Text(FirebaseAuth.instance.currentUser?.email ==
                        'admin@gmail.com' ? 'Profiles' : 'Profile',style: Styles.textBlack20,),
            onTap: () {
              if(FirebaseAuth.instance.currentUser?.email ==
                        'admin@gmail.com') {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManageProfilePage()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.home,size: getSize(30), color: CustomColors.primaryColor,),
            title:  Text('Tips/FAQs', style: Styles.textBlack20,),
            onTap: () {
             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>TipsFaqPage()));
            },
          ),
          const SizedBox(
            height: 210,
          ),
          ListTile(
            leading:  Icon(Icons.logout,size: getSize(30), color: CustomColors.primaryColor,),
            title:  Text('LogOut',style: Styles.textBlack20,),
            onTap: () async {
              FirebaseAuth auth = FirebaseAuth.instance;
              await auth.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (route) => false);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('LogOut Sucessfully'),
                ),
              );
              
            },
          )
        ],
      ),
    );
  }
}
