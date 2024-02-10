import 'package:cloud_firestore/cloud_firestore.dart';


class AllData {
  Future<void> addAllData(
      String name, String descriptions, List images, String itenary, String? price) async {
    var value = await FirebaseFirestore.instance
        .collection("AllData")
        .doc(name)
        .set({
          'name':name,
          'Description':descriptions,
          'Images':images,
          'itenary':itenary,
          'price':price,
          // 'likes':likes
          
        });
  }
}
