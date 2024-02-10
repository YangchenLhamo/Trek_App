import 'package:flutter/material.dart';
import 'package:trekking_guide/mainScreens/loginpage.dart';

import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/woman.png'),
              fit: BoxFit.cover,
              opacity: 0.4)),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  0, getVerticalSize(100), getHorizontalSize(15), 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                 
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginPage()));
                    },
                    child: Container(
                      height: getVerticalSize(40),
                      width: getHorizontalSize(200),
                      // margin: EdgeInsetsDirectional.only(bottom: getVerticalSize(130)),
                      padding: EdgeInsets.fromLTRB(
                          getHorizontalSize(60), getVerticalSize(20), 0, 0),
                      decoration: BoxDecoration(
                          color: CustomColors.primaryColor,
                          borderRadius: BorderRadius.circular(15)),
                      child: Text(
                        'Get Started',
                        style: Styles.textWhite18,
                      ),
                    ),
                  
                  ),
                  SizedBox(height: getVerticalSize(30),)
                  
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
