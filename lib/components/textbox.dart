// import 'package:flutter/material.dart';
// import 'package:trekking_guide/utils/size_utils.dart';
// import 'package:trekking_guide/utils/text_styles.dart';

// class MyTextBox extends StatelessWidget {
//   final String text;
//   final String sectionName;
//   // final void Function()? onPressed;
//   const MyTextBox({Key? key, required this.text, required this.sectionName,
//   //  required this.onPressed
//    });


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: getVerticalSize(70),
//       decoration: BoxDecoration(
//           color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
//       padding: EdgeInsets.only(top:getVerticalSize(5), left: getHorizontalSize(10), bottom: getVerticalSize(15)),
//       margin: EdgeInsets.only(left: getHorizontalSize(20), right: getHorizontalSize(20), top: getVerticalSize(10)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
          
//             decoration: InputDecoration(
//               labelText: sectionName,
//               labelStyle: TextStyle(color: Colors.grey[500]),
//               fillColor: Colors.grey.shade200,
//               filled: true,
//             ),

//             style: Styles.textBlack16,
//             controller: TextEditingController(text: text),
//           ),
         
//         ],
//       ),
//     );
//   }
// }
