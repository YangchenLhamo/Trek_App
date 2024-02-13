import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void deleteComment(String title, String commentId) {
  FirebaseFirestore.instance
      .collection("TrekkingPlaces")
      .doc(title)
      .collection("Comments")
      .doc(commentId)
      .delete();
}

void addComment(String title, String commentText) {
  FirebaseFirestore.instance
      .collection("TrekkingPlaces")
      .doc(title)
      .collection("Comments")
      .add({
    "CommentText": commentText,
    "CommentedBy": FirebaseAuth.instance.currentUser!.email,
    "CommentTime": Timestamp.now()
  });
}

void showCommentDialog(BuildContext context, TextEditingController commentTextController, String title) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Add Comment"),
      content: TextField(
        maxLines: null,
        controller: commentTextController,
        decoration: InputDecoration(hintText: "Write a comment.."),
      ),
      actions: [
        TextButton(
          onPressed: () {
            addComment(title, commentTextController.text);
            Navigator.pop(context);
            commentTextController.clear();
          },
          child: Text("Post"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            commentTextController.clear();
          },
          child: Text("Cancel"),
        ),
      ],
    ),
  );
}
