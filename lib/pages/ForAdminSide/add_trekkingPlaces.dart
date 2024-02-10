// import 'dart:io';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:trekking_guide/utils/custom_colors.dart';
// import 'package:trekking_guide/utils/size_utils.dart';
// import 'package:trekking_guide/utils/text_styles.dart';

// class AddTrekkingPlaces extends StatefulWidget {
//   const AddTrekkingPlaces({super.key});

//   @override
//   State<AddTrekkingPlaces> createState() => _AddTrekkingPlacesState();
// }

// class _AddTrekkingPlacesState extends State<AddTrekkingPlaces> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController descriptionController = TextEditingController();
//   final TextEditingController priceController = TextEditingController();
//   List<File> _images = [];
//   List<String> images = []; // List to store image download URLs

//   Future<void> _pickImages() async {
//     List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
//     if (pickedFiles != null) {
//       setState(() {
//         _images = pickedFiles.map((file) => File(file.path)).toList();
//       });
//     }
//   }

//   Future<void> _uploadImagesToStorage() async {
//     try {
//       for (var imageFile in _images) {
//         Reference ref = FirebaseStorage.instance
//             .ref()
//             .child('images/${DateTime.now().millisecondsSinceEpoch}');
//         UploadTask uploadTask = ref.putFile(imageFile);
//         TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
//         String downloadUrl = await snapshot.ref.getDownloadURL();
//         images.add(downloadUrl);
//       }
//     } catch (e) {
//       print('Error uploading images: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           icon: const Icon(Icons.arrow_back),
//           color: Colors.white,
//         ),
//         title: Text(
//           'Add Trekking Places',
//           style: Styles.textWhite28B,
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Form(
//               key: _formKey,
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(getHorizontalSize(30),
//                     getVerticalSize(30), getHorizontalSize(20), 0),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(
//                           getVerticalSize(10),
//                           getHorizontalSize(5),
//                           getVerticalSize(10),
//                           getHorizontalSize(5)),
//                       child: TextFormField(
//                         controller: nameController,
//                         decoration: InputDecoration(
//                             label: const Text('Name'),
//                             labelStyle: Styles.textBlack20,
//                             hintText: "Name of the Trek",
//                             hintStyle: Styles.hintTextStyle16,
//                             errorStyle: Styles.errorTextStyl14,
//                             fillColor: Colors.grey.shade200,
//                             filled: true,
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(getSize(10)),
//                                 borderSide:
//                                     const BorderSide(color: Colors.white)),
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(getSize(10)),
//                                 borderSide:
//                                     BorderSide(color: Colors.grey.shade300))),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a description';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: getVerticalSize(20),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(
//                           getVerticalSize(10),
//                           getHorizontalSize(5),
//                           getVerticalSize(10),
//                           getHorizontalSize(5)),
//                       child: TextFormField(
//                         controller: descriptionController,
//                         maxLines: null,
//                         decoration: InputDecoration(
//                             label: const Text('Description'),
//                             labelStyle: Styles.textBlack20,
//                             hintText: "Write the description here",
//                             hintStyle: Styles.hintTextStyle16,
//                             errorStyle: Styles.errorTextStyl14,
//                             fillColor: Colors.grey.shade200,
//                             filled: true,
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(getSize(10)),
//                                 borderSide:
//                                     const BorderSide(color: Colors.white)),
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(getSize(10)),
//                                 borderSide:
//                                     BorderSide(color: Colors.grey.shade300))),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a name';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(
//                       height: getVerticalSize(20),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.fromLTRB(
//                           getVerticalSize(10),
//                           getHorizontalSize(5),
//                           getVerticalSize(10),
//                           getHorizontalSize(5)),
//                       child: TextFormField(
//                         controller: priceController,
//                         decoration: InputDecoration(
//                             label: const Text('Price'),
//                             labelStyle: Styles.textBlack20,
//                             hintText: "Price here",
//                             hintStyle: Styles.hintTextStyle16,
//                             errorStyle: Styles.errorTextStyl14,
//                             fillColor: Colors.grey.shade200,
//                             filled: true,
//                             focusedBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(getSize(10)),
//                                 borderSide:
//                                     const BorderSide(color: Colors.white)),
//                             enabledBorder: OutlineInputBorder(
//                                 borderRadius:
//                                     BorderRadius.circular(getSize(10)),
//                                 borderSide:
//                                     BorderSide(color: Colors.grey.shade300))),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter a price';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     SizedBox(height: getVerticalSize(20)),
//                     ElevatedButton(
//                       onPressed: _pickImages,
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: CustomColors.primaryColor),
//                       child: Text(
//                         'Pick Images',
//                         style: Styles.textWhite20,
//                       ),
//                     ),
//                     SizedBox(height: getVerticalSize(20)),
//                     _images.isNotEmpty
//                         ? Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Preview Images:',
//                                 style: Styles.textBlack20B,
//                               ),
//                               SizedBox(height: getVerticalSize(20)),
//                               Wrap(
//                                 spacing: 8.0,
//                                 runSpacing: 8.0,
//                                 children: _images.map((image) {
//                                   return Container(
//                                     width: getHorizontalSize(80),
//                                     height: getVerticalSize(80),
//                                     child: Image.file(
//                                       image,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   );
//                                 }).toList(),
//                               ),
//                             ],
//                           )
//                         : Container(),
//                     SizedBox(height: getVerticalSize(15)),
//                     ElevatedButton(
//                       onPressed: () async {
//                         if (_formKey.currentState?.validate() ?? false) {
//                           // Upload images to Firebase Storage
//                           await _uploadImagesToStorage();

//                           // Save data to Firestore
//                           try {
//                             await FirebaseFirestore.instance
//                                 .collection('TrekkingPlaces')
//                                 .doc(nameController
//                                     .text) // Use name as document name
//                                 .set({
//                               'name': nameController.text,
//                               'Description': descriptionController.text,
//                               'price': priceController.text,
//                               'Images': images, // Add image URLs to Firestore
//                             });
//                             // Process successful submission
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text('Data Submitted Successfully'),
//                               ),
//                             );
//                             // back to home page
//                             Navigator.of(context).pop();

//                             print('Data submitted successfully');
//                           } catch (e) {
//                             // Handle errors
//                             print('Error submitting data: $e');
//                           }
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: CustomColors.primaryColor),
//                       child: Text(
//                         'Submit',
//                         style: Styles.textWhite20,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class AddTrekkingPlaces extends StatefulWidget {
  const AddTrekkingPlaces({super.key});

  @override
  State<AddTrekkingPlaces> createState() => _AddTrekkingPlacesState();
}

class _AddTrekkingPlacesState extends State<AddTrekkingPlaces> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<File> _imagesPreview = [];
  List<File> _imagesItenary = [];

  // List to store image download URLs
  List<dynamic> imagesPreview = [];
  String imageItenary = '';

  Future<void> _pickImages() async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    setState(() {
      _imagesPreview = pickedFiles.map((file) => File(file.path)).toList();
      // _imagesItenary = pickedFiles.map((file) => File(file.path)).toList();
    });
    }

  Future<void> _pickItenary() async {
    List<XFile>? pickedItenary = await ImagePicker().pickMultiImage();
    setState(() {
      // _imagesPreview = pickedFiles.map((file) => File(file.path)).toList();
      _imagesItenary = pickedItenary.map((file) => File(file.path)).toList();
    });
    }

  Future<void> _uploadImagesToStorage() async {
    try {
      for (var imageFile in _imagesPreview) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().millisecondsSinceEpoch}');
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
        String downloadUrl = await snapshot.ref.getDownloadURL();
        imagesPreview.add(downloadUrl); // Add URL as a string
      }
      
    } catch (e) {
      print('Error uploading images: $e');
    }

    try {
    for (var imageFile in _imagesItenary) {
      Reference ref = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      imageItenary=(downloadUrl); // Add URL as a string
    }
    } catch (e) {
      print('Error uploading images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          'Add Trekking Places',
          style: Styles.textWhite28B,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(getHorizontalSize(30),
                    getVerticalSize(30), getHorizontalSize(20), 0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          getVerticalSize(10),
                          getHorizontalSize(5),
                          getVerticalSize(10),
                          getHorizontalSize(5)),
                      child: TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                            label: const Text('Name'),
                            labelStyle: Styles.textBlack20,
                            hintText: "Name of the Trek",
                            hintStyle: Styles.hintTextStyle16,
                            errorStyle: Styles.errorTextStyl14,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(10)),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(10)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          getVerticalSize(10),
                          getHorizontalSize(5),
                          getVerticalSize(10),
                          getHorizontalSize(5)),
                      child: TextFormField(
                        controller: descriptionController,
                        maxLines: null,
                        decoration: InputDecoration(
                            label: const Text('Description'),
                            labelStyle: Styles.textBlack20,
                            hintText: "Write the description here",
                            hintStyle: Styles.hintTextStyle16,
                            errorStyle: Styles.errorTextStyl14,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(10)),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(10)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          getVerticalSize(10),
                          getHorizontalSize(5),
                          getVerticalSize(10),
                          getHorizontalSize(5)),
                      child: TextFormField(
                        controller: priceController,
                        decoration: InputDecoration(
                            label: const Text('Price'),
                            labelStyle: Styles.textBlack20,
                            hintText: "Price here",
                            hintStyle: Styles.hintTextStyle16,
                            errorStyle: Styles.errorTextStyl14,
                            fillColor: Colors.grey.shade200,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(10)),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(getSize(10)),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300))),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a price';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: getVerticalSize(20)),

                    // for itenary image
                    _imagesItenary.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Itenary Images:',
                                style: Styles.textBlack20B,
                              ),
                              SizedBox(height: getVerticalSize(20)),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _imagesItenary.map((image) {
                                  return Container(
                                    width: getHorizontalSize(80),
                                    height: getVerticalSize(80),
                                    child: Image.file(
                                      image,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(height: getVerticalSize(15)),
                    ElevatedButton(
                      onPressed: _pickItenary,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryColor),
                      child: Text(
                        'Pick Itenary',
                        style: Styles.textWhite20,
                      ),
                    ),
                    SizedBox(height: getVerticalSize(20)),
                    // ElevatedButton(
                    //   onPressed: () async {
                    //     if (_formKey.currentState?.validate() ?? false) {
                    //       // Upload images to Firebase Storage
                    //       await _uploadImagesToStorage();

                    //       // Save data to Firestore
                    //       try {
                    //         await FirebaseFirestore.instance
                    //             .collection('TrekkingPlaces')
                    //             .doc(nameController
                    //                 .text) // Use name as document name
                    //             .set({
                    //           'name': nameController.text,
                    //           'Description': descriptionController.text,
                    //           'price': priceController.text,
                    //           'Images': images, // Add image URLs to Firestore
                    //         });
                    //         // Process successful submission
                    //         ScaffoldMessenger.of(context).showSnackBar(
                    //           const SnackBar(
                    //             content: Text('Data Submitted Successfully'),
                    //           ),
                    //         );
                    //         // back to home page
                    //         Navigator.of(context).pop();

                    //         print('Data submitted successfully');
                    //       } catch (e) {
                    //         // Handle errors
                    //         print('Error submitting data: $e');
                    //       }
                    //     }
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //       backgroundColor: CustomColors.primaryColor),
                    //   child: Text(
                    //     'Submit',
                    //     style: Styles.textWhite20,
                    //   ),
                    // ),

                    // for preview images
                    _imagesPreview.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Preview Images:',
                                style: Styles.textBlack20B,
                              ),
                              SizedBox(height: getVerticalSize(20)),
                              Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: _imagesPreview.map((image) {
                                  return Container(
                                    width: getHorizontalSize(80),
                                    height: getVerticalSize(80),
                                    child: Image.file(
                                      image,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          )
                        : Container(),
                    SizedBox(height: getVerticalSize(15)),
                    ElevatedButton(
                      onPressed: _pickImages,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryColor),
                      child: Text(
                        'Pick Images',
                        style: Styles.textWhite20,
                      ),
                    ),
                    SizedBox(height: getVerticalSize(20)),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Upload images to Firebase Storage
                          await _uploadImagesToStorage();

                          // Save data to Firestore
                          try {
                            await FirebaseFirestore.instance
                                .collection('TrekkingPlaces')
                                .doc(nameController
                                    .text) // Use name as document name
                                .set({
                              'name': nameController.text,
                              'Description': descriptionController.text,
                              'price': priceController.text,
                              'Images': imagesPreview,
                              'itenary':
                                  imageItenary,
                                  'likes':[] // Add image URLs to Firestore
                            });
                            // Process successful submission
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Data Submitted Successfully'),
                              ),
                            );
                            // back to home page
                            Navigator.of(context).pop();

                            print('Data submitted successfully');
                          } catch (e) {
                            // Handle errors
                            print('Error submitting data: $e');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryColor),
                      child: Text(
                        'Submit',
                        style: Styles.textWhite20,
                      ),
                    ),
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

