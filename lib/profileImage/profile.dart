import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trekking_guide/profileImage/save_image.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "name";
  String email = "email";
  bool isImagePickerActive = false;
  String phoneNumber = 'Phone';
  String dateofbirth = 'Date Of Birth';
  String profileImageUrl = "";
  User? usermain = FirebaseAuth.instance.currentUser;

  TextEditingController dateController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool isLoading = true;
  XFile? file;

  @override
  void initState() {
    getUserData();

    super.initState();
    // Simulate a loading delay
    Future.delayed(const Duration(seconds: 1), () {
      getUserData();
      setState(() {
        isLoading = false;
      });
    });
  }

  Uint8List? _image;
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    file = await _imagePicker.pickImage(source: source);
    if (file != null) {
      return await file!.readAsBytes();
    }
    print("No image Selected");
  }

  void selectImage() async {
    if (!isImagePickerActive) {
      isImagePickerActive = true;

      Uint8List img = await pickImage(ImageSource.gallery);

      setState(() {
        _image = img;
      });

      // After image picking is complete, set isImagePickerActive to false
      isImagePickerActive = false;
    }
  }

  Future<String> saveProfileImage() async {
    // String resp = await StoreData().saveData(file: _image!);
    // return resp;
    String? resp = await StoreData().saveData(file: _image!);
    return resp ?? '';
  }

// creating user and storing it in a collection 'users'
  void getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var value = await FirebaseFirestore.instance
        .collection("Users")
        .doc(user!.uid)
        .get();
    if (value.exists) {
      print('the value that came is $value');
      setState(() {
        name = value.data()!['name'];
        email = value.data()!['email'];
        dateofbirth = value.data()!['Date of Birth'];
        phoneNumber = value.data()!['Phone'];
        profileImageUrl = value.data()!['imageLink'];
      });
    }
  }

  void updateData(String name, String email, String dateofbirth,
      String phoneNumber, String profileImageUrl) async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection("Users").doc(user!.uid).update({
      "name": nameController.text,
      "email": emailController.text,
      "Date of Birth": dateController.text,
      "Phone": phoneNumberController.text,
      'imageLink': _image == null ? profileImageUrl : profileImageUrl,
    });
  }

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
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text(
          "Profile",
          style: Styles.textWhite34B,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          CircleAvatar(
                            radius: getSize(80),
                            backgroundImage: profileImageUrl.isNotEmpty
                                ? _image == null
                                    ? NetworkImage(profileImageUrl)
                                    : null
                                : null,
                            child: profileImageUrl.isNotEmpty
                                ? _image == null
                                    ? null
                                    : CircleAvatar(
                                        radius: getSize(80),
                                        backgroundImage: MemoryImage(_image!),
                                      )
                                : _image == null
                                    ? CircleAvatar(
                                        radius: getSize(80),
                                        backgroundImage: const AssetImage(
                                            'assets/annapurna_trek.jpg'),
                                      )
                                    : CircleAvatar(
                                        radius: getSize(80),
                                        backgroundImage: MemoryImage(_image!),
                                      ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                                icon: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white
                                            .withOpacity(0.8), // Shadow color
                                        spreadRadius: 5, // Spread radius
                                        blurRadius: 6, // Blur radius
                                        offset: Offset(0, 4), // Offset
                                      ),
                                    ],
                                    shape: BoxShape
                                        .circle, // Shape of the container (circle in this case)
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: CustomColors.primaryColor,
                                  ),
                                ),
                                onPressed: selectImage),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getVerticalSize(20),
                      ),
                      Text(
                        name,
                        style: Styles.textBlack20B,
                      ),
                      SizedBox(
                        height: getVerticalSize(15),
                      ),
                      Container(
                        width: double.infinity,
                        height: getVerticalSize(90),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.only(
                            top: getVerticalSize(5),
                            left: getHorizontalSize(10),
                            right: getHorizontalSize(10),
                            bottom: getVerticalSize(10)),
                        margin: EdgeInsets.only(
                            left: getHorizontalSize(20),
                            right: getHorizontalSize(20),
                            top: getVerticalSize(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: nameController,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Title can't be empty";

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: CustomColors.primaryColor,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: CustomColors.primaryColor,
                                  width: 2,
                                )),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: CustomColors.primaryColor,
                                ),
                                labelText: "Username",
                                hintText: "Your Name",
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: getVerticalSize(90),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.only(
                            top: getVerticalSize(5),
                            left: getHorizontalSize(10),
                            right: getHorizontalSize(10),
                            bottom: getVerticalSize(10)),
                        margin: EdgeInsets.only(
                            left: getHorizontalSize(20),
                            right: getHorizontalSize(20),
                            top: getVerticalSize(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Title can't be empty";

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: CustomColors.primaryColor,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: CustomColors.primaryColor,
                                  width: 2,
                                )),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: CustomColors.primaryColor,
                                ),
                                labelText: "Email",
                                hintText: "Your Email Address",
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: getVerticalSize(90),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.only(
                            top: getVerticalSize(5),
                            left: getHorizontalSize(10),
                            right: getHorizontalSize(10),
                            bottom: getVerticalSize(10)),
                        margin: EdgeInsets.only(
                            left: getHorizontalSize(20),
                            right: getHorizontalSize(20),
                            top: getVerticalSize(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: phoneNumberController,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Title can't be empty";

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: CustomColors.primaryColor,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: CustomColors.primaryColor,
                                  width: 2,
                                )),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: CustomColors.primaryColor,
                                ),
                                labelText: "PhoneNumber",
                                hintText: "Your Phone Number",
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: getVerticalSize(90),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.only(
                            top: getVerticalSize(5),
                            left: getHorizontalSize(10),
                            right: getHorizontalSize(10),
                            bottom: getVerticalSize(10)),
                        margin: EdgeInsets.only(
                            left: getHorizontalSize(20),
                            right: getHorizontalSize(20),
                            top: getVerticalSize(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: dateController,
                              validator: (value) {
                                if (value!.isEmpty)
                                  return "Title can't be empty";

                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: CustomColors.primaryColor,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: CustomColors.primaryColor,
                                  width: 2,
                                )),
                                prefixIcon: Icon(
                                  Icons.calendar_month,
                                  color: CustomColors.primaryColor,
                                ),
                                labelText: "DateOfBirth",
                                hintText: "Your Date Of Birth",
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getVerticalSize(30),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Reference ref = _storage.ref().child(usermain!.uid);

                          try {
                            ListResult result = await ref.listAll();

                            // Check if the reference exists in the list
                            if (result.items.isNotEmpty) {
                              // Reference exists
                              ref.delete().then((value) => {
                                    saveProfileImage().then(
                                      (value) {
                                        print('the new image url is $value');
                                        updateData(
                                            nameController.text,
                                            emailController.text,
                                            dateController.text,
                                            phoneNumberController.text,
                                            value);
                                      },
                                    ),

                                    // Update appointment logic here
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Details Updated'),
                                      ),
                                    ),
                                    getUserData(),
                                    // Navigator.pop(context);
                                  });
                            } else {
                              // Reference does not exist

                              saveProfileImage().then(
                                (value) {
                                  print('the new image url is $value');
                                  updateData(
                                      nameController.text,
                                      emailController.text,
                                      dateController.text,
                                      phoneNumberController.text,
                                      value);
                                },
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Details Updated'),
                                ),
                              );
                              getUserData();
                              // Navigator.pop(context);
                            }
                          } catch (e) {
                            // Handle the error
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error Occured $e'),
                            ));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.primaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: getVerticalSize(15),
                                horizontal: getHorizontalSize(120)),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(15)))),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text('Update', style: Styles.textWhite20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
