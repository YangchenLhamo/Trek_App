import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trekking_guide/components/bottomnav.dart';

import 'package:trekking_guide/mainScreens/loginpage.dart';
import 'package:trekking_guide/profileImage/save_image.dart';

import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';

import 'package:trekking_guide/utils/text_styles.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();

  bool isEmailValid = false;
  bool isNameValid = false;
  bool isPhoneNumberValid = false;
  bool isDateValid = false;
  XFile? file;
  bool _showPassword = true;
  bool _showPassword1 = true;

  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _togglevisibility2() {
    setState(() {
      _showPassword1 = !_showPassword1;
    });
  }

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateEmail);
    nameController.addListener(_validateName);
    phoneNumberController.addListener(_validatePhoneNumber);
    dateController.addListener(_validateDate);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final isValid = EmailValidator.validate(emailController.text);
    setState(() {
      isEmailValid = isValid;
    });
  }

  void _validateName() {
    if (nameController.text != '') {
      setState(() {
        isNameValid = true;
      });
    } else {
      setState(() {
        isNameValid = false;
      });
    }
  }

  void _validatePhoneNumber() {
    final phoneNumber = phoneNumberController.text;
    if ((phoneNumber.length) == 10) {
      setState(() {
        isPhoneNumberValid = true;
      });
    } else {
      setState(() {
        isPhoneNumberValid = false;
      });
    }
  }

  void _validateDate() {
    if (selectedDate != null) {
      // Calculate age based on the selected date
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - selectedDate!.year;

      // Adjust age if the birthday hasn't occurred yet this year
      if (currentDate.month < selectedDate!.month ||
          (currentDate.month == selectedDate!.month &&
              currentDate.day < selectedDate!.day)) {
        age--;
      }

      // Check if age is 18 or greater
      if (age >= 18) {
        setState(() {
          isDateValid = true;
        });
      } else {
        setState(() {
          isDateValid = false;
        });
      }
    } else {
      // Handle the case where no date is selected
      setState(() {
        isDateValid = false;
      });
    }
  }

  bool get _isFormValid =>
      isEmailValid &&
      isNameValid &&
      isPhoneNumberValid &&
      isDateValid &&
      (passwordController.text.length) >= 6 &&
      passwordController.text == confirmpasswordController.text;

  DateTime? selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = '${selectedDate?.toLocal()}'.split(' ')[0];
      });
    }
  }

  Uint8List? _image;
  // pickImage(ImageSource source) async {
  //   final ImagePicker _imagePicker = ImagePicker();
  //   file = await _imagePicker.pickImage(source: source);
  //   if (file != null) {
  //     return await file!.readAsBytes();
  //   }
  //   print("No image Selected");
  // }

  // void selectImage() async {
  //   Uint8List img = await pickImage(ImageSource.gallery);
  //   setState(() {
  //     _image = img;
  //   });
  // }
  void selectImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? imageFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      setState(() {
        file = imageFile;
        _image = File(imageFile.path).readAsBytesSync();
      });
    } else {
      print("No image selected");
    }
  }

  Future<String> saveProfileImage() async {
    if (_image != null) {
      String? imageUrl = await StoreData().saveData(file: _image!);
      return imageUrl ?? '';
    } else {
      print("No image to save");
      return '';
    }
  }

  // Future<String> saveProfileImage() async {
  //   // String resp = await StoreData().saveData(file: _image!);
  //   // return resp;
  //   String? resp = await StoreData().saveData(file: _image!);
  //   return resp ?? '';
  // }
  // Future<String> spdateProfileImage() async {
  //   String resp = await UpdateData().saveData(file: _image!);
  //   return resp;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: getVerticalSize(50),
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: getSize(80),
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: getSize(80),
                          backgroundImage:
                              const AssetImage('assets/annapurna_trek.jpg'),
                        ),
                  Positioned(
                    bottom: getVerticalSize(-10),
                    left: getHorizontalSize(80),
                    child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(
                          Icons.add_a_photo,
                          size: getSize(35),
                          color: CustomColors.primaryColor,
                        )),
                  )
                ],
              ),
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(getHorizontalSize(10),
                      getVerticalSize(30), getHorizontalSize(10), 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: getVerticalSize(10),
                            bottom: getVerticalSize(20)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Register Here!', style: Styles.textBlack40B)
                            ]),
                      ),
                      SizedBox(
                        height: getVerticalSize(20),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            getVerticalSize(15),
                            getHorizontalSize(5),
                            getVerticalSize(15),
                            getHorizontalSize(5)),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                              label: const Text('Name'),
                              labelStyle: Styles.textBlack20,
                              hintText: "UserName",
                              hintStyle: Styles.hintTextStyle20,
                              errorStyle: Styles.errorTextStyl14,
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(getSize(20)),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(getSize(20)),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                              prefixIcon: const Icon(Icons.person,
                                  color: Color.fromARGB(255, 20, 123, 90))),
                          validator: (value) {
                            if (!isNameValid) {
                              return 'Name is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: getVerticalSize(10)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            getVerticalSize(15),
                            getHorizontalSize(5),
                            getVerticalSize(15),
                            getHorizontalSize(5)),
                        child: TextFormField(
                          controller: emailController,

                          decoration: InputDecoration(
                            label: const Text('Email'),
                            labelStyle: Styles.textBlack20,
                            hintText: "Your Email",
                            hintStyle: Styles.hintTextStyle20,
                            errorStyle: Styles.errorTextStyl14,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(20)),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(20)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            prefixIcon: const Icon(Icons.email_outlined,
                                color: Color.fromARGB(255, 20, 123, 90)),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (!isEmailValid) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },

                          // keyboardType: TextInputType.emailAddress,
                          // validator: (value) {
                          //   if (!_isEmailValid) {
                          //     return 'Enter a valid email';
                          //   }
                          //   return null;
                          // },
                        ),
                      ),
                      SizedBox(height: getVerticalSize(10)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            getVerticalSize(15),
                            getHorizontalSize(5),
                            getVerticalSize(15),
                            getHorizontalSize(5)),
                        child: TextFormField(
                          controller: phoneNumberController,
                          decoration: InputDecoration(
                              label: const Text('Phone Number'),
                              labelStyle: Styles.textBlack20,
                              hintText: "Phone Number",
                              hintStyle: Styles.hintTextStyle20,
                              errorStyle: Styles.errorTextStyl14,
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(getSize(20)),
                                  borderSide:
                                      const BorderSide(color: Colors.white)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(getSize(20)),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade300)),
                              prefixIcon: const Icon(
                                  Icons.phone_callback_rounded,
                                  color: Color.fromARGB(255, 20, 123, 90))),
                          validator: (value) {
                            if (!isPhoneNumberValid) {
                              return 'Phone Number must be 10 character long.';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: getVerticalSize(10)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            getVerticalSize(15),
                            getHorizontalSize(5),
                            getVerticalSize(15),
                            getHorizontalSize(5)),
                        child: TextFormField(
                          controller: dateController,
                          decoration: InputDecoration(
                            label: const Text('Date of Birth'),
                            labelStyle: Styles.textBlack20,
                            hintText: "Date of Birth",
                            hintStyle: Styles.hintTextStyle20,
                            errorStyle: Styles.errorTextStyl14,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(20)),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(20)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            // prefixIcon: const Icon(Icons.calendar_today,
                            //     color: CustomColors.primaryColor),
                            prefixIcon: IconButton(
                              onPressed: () => _selectDate(context),
                              icon: const Icon(
                                Icons.calendar_today,
                                color: CustomColors.primaryColor,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (!isDateValid) {
                              return 'Must be 18 years or elder';
                            }
                            return null;
                          },
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      SizedBox(height: getVerticalSize(10)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            getVerticalSize(15),
                            getHorizontalSize(5),
                            getVerticalSize(15),
                            getHorizontalSize(5)),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            label: const Text('Password'),
                            labelStyle: Styles.textBlack20,
                            hintText: "Password",
                            hintStyle: Styles.hintTextStyle20,
                            errorStyle: Styles.errorTextStyl14,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(20)),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(20)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            prefixIcon: const Icon(Icons.key_rounded,
                                color: Color.fromARGB(255, 20, 123, 90)),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // ToastMessage.showMessage("Click");
                                _togglevisibility();
                              },
                              child: Icon(
                                  _showPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: CustomColors.primaryColor),
                            ),
                          ),
                          obscureText: _showPassword,
                          validator: (value) {
                            if (value == null || value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: getVerticalSize(10)),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            getVerticalSize(15),
                            getHorizontalSize(5),
                            getVerticalSize(15),
                            getHorizontalSize(5)),
                        child: TextFormField(
                          controller: confirmpasswordController,
                          decoration: InputDecoration(
                            label: const Text('Confirm'),
                            labelStyle: Styles.textBlack20,
                            hintText: "Confirm Password",
                            hintStyle: Styles.hintTextStyle20,
                            errorStyle: Styles.errorTextStyl14,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(20)),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(20)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300)),
                            prefixIcon: const Icon(Icons.key_sharp,
                                color: Color.fromARGB(255, 20, 123, 90)),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // ToastMessage.showMessage("Click");
                                _togglevisibility2();
                              },
                              child: Icon(
                                  _showPassword1
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: CustomColors.primaryColor),
                            ),
                          ),
                          obscureText: _showPassword1,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the password confirmation';
                            } else if (value != passwordController.text) {
                              return 'Password does not match';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: getVerticalSize(10)),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            saveProfileImage()
                                .then((value) => {registerUser(value)});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Enter all essential data correctly'),
                              ),
                            );
                          }
                        },
                        // onPressed: () {
                        //   Navigator.of(context).push(
                        //       MaterialPageRoute(builder: (context) => BottomNav()));
                        // },
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
                          child: Text('Sign Up', style: Styles.textWhite20),
                        ),
                      ),
                      SizedBox(height: getVerticalSize(30)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an Account?",
                              style: Styles.textBlack18),
                          SizedBox(
                            width: getHorizontalSize(1),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                              },
                              child: Text(
                                "SignIn",
                                style: Styles.textBlack18,
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future registerUser(String url) async {
    FirebaseAuth auth = FirebaseAuth.instance;


    auth
        .createUserWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((signedInUser) => FirebaseFirestore.instance
                .collection("Users")
                .doc(signedInUser.user!.uid)
                .set({
              "name": nameController.text,
              "email": emailController.text,
              "Phone": phoneNumberController.text,
              "favourites": [],
              'Date of Birth': dateController.text,
              'imageLink': url
            }))
        .then((value) {
      print('created a new account');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNav()),
      );
    }).onError((error, stackTrace) {
      print('Error ${error.toString()}');
      Fluttertoast.showToast(msg: error.toString());
    });
  }
}
