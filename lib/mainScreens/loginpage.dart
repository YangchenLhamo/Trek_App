import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trekking_guide/components/bottomnav.dart';
import 'package:trekking_guide/mainScreens/forgot_password.dart';
import 'package:trekking_guide/mainScreens/registerPage.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';

import 'package:trekking_guide/utils/text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _showPassword = true;

  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final isValid = EmailValidator.validate(emailController.text);
    setState(() {
      _isEmailValid = isValid;
    });
  }

  void signinUser() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: true,
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: getVerticalSize(50), bottom: getVerticalSize(20)),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text('Sign In', style: Styles.textBlack40B)]),
                ),
                SizedBox(
                  height: getVerticalSize(50),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
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
                                  color: Color.fromARGB(255, 20, 123, 90))),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (!_isEmailValid) {
                              return 'Enter a valid email';
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
                            getHorizontalSize(10)),
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
                    ],
                  ),
                ),

                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MaterialButton(
                        onPressed: (){
                           Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ForgotPasswordPage()));
                        },
                        child: Text('Forgot Password?',
                            style: Styles.textBlack16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: getVerticalSize(30)),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text)
                          .then((value) {
                        Fluttertoast.showToast(msg: 'Successful');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNav(),
                          ),
                        );
                      }).onError((error, stackTrace) {
                        print('Error: ${error.toString()}');
                        Fluttertoast.showToast(msg: error.toString());
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enter all essentials'),
                        ),
                      );
                    }
                  },
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => BottomNav()));

                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor,
                      padding: EdgeInsets.symmetric(
                          vertical: getVerticalSize(15),
                          horizontal: getHorizontalSize(120)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(getSize(15)))),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('Login', style: Styles.textWhite20),
                  ),
                ),
                SizedBox(height: getVerticalSize(60)),

                // register

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an Account?", style: Styles.textBlack18),
                    SizedBox(
                      height: getVerticalSize(15),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              vertical: getVerticalSize(15),
                              horizontal: getHorizontalSize(100)),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                getSize(15),
                              ),
                              side: BorderSide(
                                  color: Colors.black, width: getSize(2)))),
                      child: Text('Register Now!', style: Styles.textBlack16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
