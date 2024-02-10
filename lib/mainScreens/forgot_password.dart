import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
          showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("Password reset link is sent! Check your mail!!"),
            );
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
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
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Forgot Password??",
            style: Styles.textBlack32B,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: getVerticalSize(20),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '''"Enter your email and we will send you a password reset link!"''',
              style: Styles.textBlack16,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: getVerticalSize(20),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                getVerticalSize(15),
                getHorizontalSize(5),
                getVerticalSize(15),
                getHorizontalSize(10)),
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
                      borderRadius: BorderRadius.circular(getSize(20)),
                      borderSide: const BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(getSize(20)),
                      borderSide: BorderSide(color: Colors.grey.shade300)),
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: Color.fromARGB(255, 20, 123, 90))),
            ),
          ),
          MaterialButton(
            onPressed: passwordReset,
            color: CustomColors.primaryColor,
            child: Text(
              "Reset Password",
              style: Styles.textWhite20,
            ),
          )
        ],
      ),
    );
  }
}
