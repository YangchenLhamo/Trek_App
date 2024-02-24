import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:trekking_guide/components/comments_log.dart';
import 'package:trekking_guide/components/dateformatter.dart';
// import 'package:trekking_guide/services/comments_log.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';
// Import your custom styles

class CommentsWidget extends StatelessWidget {
  final String title;

  CommentsWidget({super.key, required this.title});
  List<String> commentIds = [];
 

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("TrekkingPlaces")
          .doc(title)
          .collection("Comments")
          .orderBy("CommentTime", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isNotEmpty) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final commentData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final commentId = snapshot.data!.docs[index].id;
              commentIds.add(commentId); // Add comment ID to the list
          
              // Check if the comment was made by the current user
              final currentUserEmail =
                  FirebaseAuth.instance.currentUser!.email;
              final commentOwnerEmail = commentData['CommentedBy'];
              final isCurrentUserComment =
                  currentUserEmail == commentOwnerEmail;
          
              // Only show the delete icon if the comment was made by the current user
              final shouldShowDeleteIcon = isCurrentUserComment;
          
              return Container(
                // height: getVerticalSize(80),
                margin: EdgeInsets.only(
                    left: getHorizontalSize(5),
                    right: getHorizontalSize(5),
                    top: getVerticalSize(15)),
                padding: EdgeInsets.only(
                  top: getVerticalSize(8),
                  left: getHorizontalSize(8),
                  bottom: getVerticalSize(15),
                ),
                decoration: BoxDecoration(
                  color: CustomColors.primaryColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            commentData['CommentText'],
                            style: Styles.textBlack16,
                            maxLines: 3, // Limit to 3 lines
                            overflow: TextOverflow
                                .ellipsis, // Show ellipsis for overflow
                          ),
                        ),
                        if (shouldShowDeleteIcon)
                          GestureDetector(
                            onTap: () {
                              // Call function to delete comment
                             
                              deleteComment(title, commentId);
                            },
                            child: SizedBox(
                              width: getVerticalSize(40),
                              child: Icon(
                                Icons.delete,
                                size: getSize(20),
                              ),
                            ),
                          ),
                        // 
                      ],
                    ),
                    SizedBox(height: getVerticalSize(10)),
                    Row(
                      children: [
                        Text(
                          commentData['CommentedBy'],
                          style: Styles.commentText16,
                        ),
                        SizedBox(
                          width: getHorizontalSize(15),
                        ),
                        Text(
                          ".",
                          style: Styles.commentText16,
                        ),
                        SizedBox(
                          width: getHorizontalSize(15),
                        ),
                        Text(
                          formatDate(commentData['CommentTime']),
                          style: Styles.commentText16,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
