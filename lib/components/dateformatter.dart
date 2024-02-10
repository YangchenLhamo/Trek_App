import 'package:cloud_firestore/cloud_firestore.dart';

String formatDate(Timestamp timestamp) {
  // timestamp is the retrive from firebase
  DateTime dateTime = timestamp.toDate();

  // get year
  String year = dateTime.year.toString();
  // get month
  String month = dateTime.month.toString();
  // get day
  String day = dateTime.day.toString();

  // final format
  String formattedDate = '$day/$month/$year';
  return formattedDate;
}
