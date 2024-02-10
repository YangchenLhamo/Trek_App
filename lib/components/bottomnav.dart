import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:trekking_guide/pages/favorite.dart';
import 'package:trekking_guide/pages/homepage.dart';
import 'package:trekking_guide/pages/map/mapps.dart';


import 'package:trekking_guide/utils/custom_colors.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;
  List<Widget> pageList = [
    HomePage(),
    const FavouritePage(),
    const MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
        bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
          
            color: CustomColors.primaryColor,
            animationDuration: const Duration(milliseconds: 200),
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              Icon(
                Icons.home,
                color: Colors.white,
              ),
              Icon(
                Icons.favorite,
                color: Colors.white,
              ),
              Icon(
                Icons.map,
                color: Colors.white,
              )
            ]),
        body: pageList[_currentIndex]);
  }
}
