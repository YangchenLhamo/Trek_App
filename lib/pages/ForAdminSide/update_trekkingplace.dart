import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class UpdateButton extends StatefulWidget {
  UpdateButton({
    Key? key,
    required this.title,
    required this.description,
    // required this.images,
    required this.price,
    this.itenary,
    this.likes,
  });

  String title;
  String description;
  // List<dynamic> images;
  String price;
  String? itenary;
  List<dynamic>? likes;

  @override
  State<UpdateButton> createState() => _UpdateButtonState();
}

class _UpdateButtonState extends State<UpdateButton> {
  void getUserData() async {
    var value = await FirebaseFirestore.instance
        .collection("TrekkingPlace")
        .doc(widget.title)
        .get();
    if (value.exists) {
      print('the value that came is $value');
      setState(() {
        widget.title = value.data()!['title'];
        widget.description = value.data()!['description'];
        widget.price = value.data()!['price'];
      });
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  void updateData(String title, String description, String price) async {
    await FirebaseFirestore.instance
        .collection("TrekkingPlaces")
        .doc(widget.title)
        .update({
      "title": title,
      "Description": description,
      "price": price,
    });

    // Update widget properties with the new values
    setState(() {
      widget.title = title;
      widget.description = description;
      widget.price = price;
    });

    // Pop the screen
  }

  @override
  Widget build(BuildContext context) {
    titleController.text = widget.title;
    descriptionController.text = widget.description;
    priceController.text = widget.price;
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
          "Update Page",
          style: Styles.textWhite34B,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        getVerticalSize(10),
                        getHorizontalSize(5),
                        getVerticalSize(10),
                        getHorizontalSize(5)),
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                          label: const Text('Name'),
                          labelStyle: Styles.textBlack20,
                          hintText: "Name of the Trek",
                          hintStyle: Styles.hintTextStyle16,
                          errorStyle: Styles.errorTextStyl14,
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(getSize(10)),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(getSize(10)),
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
                              borderRadius: BorderRadius.circular(getSize(10)),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(getSize(10)),
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
                              borderRadius: BorderRadius.circular(getSize(10)),
                              borderSide:
                                  const BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(getSize(10)),
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
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                updateData(
                  titleController.text,
                  descriptionController.text,
                  priceController.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data updated successfully'),
                  ),
                );
                getUserData();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CustomColors.primaryColor,
              ),
              child: Text(
                "Update",
                style: Styles.textWhite18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
