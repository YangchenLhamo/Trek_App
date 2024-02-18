import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trekking_guide/utils/custom_colors.dart';

import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class IncludeExcludePage extends StatefulWidget {
  IncludeExcludePage({super.key});

  @override
  State<IncludeExcludePage> createState() => _IncludeExcludePageState();
}

class _IncludeExcludePageState extends State<IncludeExcludePage> {
  String Include = ''' 
The given package includes:

1. Airport / Hotel / Airport pick up & transfer by car / Van.
2. All domestic flights from Kathmandu-Nepalgunj-Jumla and
Jumla-Nepalgunj-Kathmandu and domestic airport taxes.
3. Nights accommodation with breakfast at hotels and related palces.
4. Kathmandu city tour and all entry fees as per the above itinerary.
5. Meals (breakfast, lunch, and dinner) with Tea & coffee and hot/cold
filter water during the trek.
6. Tented camp and home-stay accommodation during the trek.
7. 1 experienced helpful and friendly guide, 1 cook and necessary
porters, their food & accommodation, salary, equipment, and insurance.
8. Trekking Equipment (Tent, mattress, dining tent, kitchen tent, toilet
tent, kitchen utensils etc.)
9. All ground transportation by private car.
10. National Park Permit (if happened to be any).
11. All necessary permits.
12. First Aid Medical kit box.
13. Office Service charge.
14. All Government Tax..
''';

  String Exclude =
      '''
The given packages does not includes :

1. Any meals (Lunch and Dinner) in Kathmandu other than breakfast.
2. Your private Travel insurance.
3. International air fare to and from Nepal.
4. Nepal Tourist Visa fee.
5. Items and expenses of personal nature.
6. Any kind of alcoholic drinks, cold drinks, laundry, phone call, internet.
7. Personal Trekking Equipment like sleeping bags, jackets (can be hired
in KTM) etc.
8. Emergency Evacuation (Helicopter Rescue).
9. Any costs which arise due to a change of the itinerary, because of
landslides, political disturbance, and strikes, etc.
10. Any other costs whatsoever, that is not mentioned in the cost included.
11. Horse renting and additional porters during the trek due to natural calamities.
12. Tips for guide, porters, driver
''';


  bool isSeeMore = false;
  bool isSeeMore2 = false;
  
   bool isAdmin = false; // Variable to check if the current user is admin

  @override
  void initState() {
    super.initState();
    // Check if the current user is admin
    isAdmin = FirebaseAuth.instance.currentUser?.email == "admin@gmail.com";
  }
  @override
  Widget build(BuildContext context) {
    final lines = isSeeMore ? null : 8;
     final lines1 = isSeeMore2 ? null : 8;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        title: Text(
          "Include & Exclude",
          style: Styles.textWhite34B,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                      height: getVerticalSize(40),
                    ),
                    Text(
                      "Namaste and Tashi Delek! ",
                      style: Styles.textBlack26B,
                    ),
                          SizedBox(
                      height: getVerticalSize(20),
                    ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: getHorizontalSize(20),
                    vertical: getVerticalSize(10)),
                    
                    
                child: Column(
                  children: [
                    
                    
                    Container(
                      height: getVerticalSize(45),
                      padding: EdgeInsets.symmetric(vertical: getVerticalSize(20), horizontal: getHorizontalSize(20)),
                      decoration: BoxDecoration(
                      color: CustomColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15)
                    ),
                      child: Text(
                        " Include for the journey",
                        style: Styles.textBlack18B,
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Divider(
                      color: CustomColors.primaryColor,
                      height: getVerticalSize(2),
                    ),
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    Text(
                      Include,
                      maxLines: lines,
                      overflow: isSeeMore
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: Styles.textBlack18,
                      textAlign: TextAlign.justify,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSeeMore = !isSeeMore;
                        });
                      },
                      child: Text(
                        (isSeeMore ? 'See Less' : 'See More'),
                        style: TextStyle(
                            fontSize: getFontSize(20),
                            color: CustomColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )),
            SizedBox(
              height: getVerticalSize(20),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: getHorizontalSize(20),
                    vertical: getVerticalSize(10)),
                child: Column(
                  children: [
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    Container(
                      height: getVerticalSize(45),
                      padding: EdgeInsets.symmetric(vertical: getVerticalSize(20), horizontal: getHorizontalSize(20)),
                      decoration: BoxDecoration(
                      color: CustomColors.primaryColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(15)
                    ),
                      child: Text(
                        " Excludes for the journey",
                        style: Styles.textBlack18B,
                      ),
                    ),
                    SizedBox(
                      height: getVerticalSize(10),
                    ),
                    Divider(
                      color: CustomColors.primaryColor,
                      height: getVerticalSize(2),
                    ),
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    Text(
                      Exclude,
                      maxLines: lines1,
                      overflow: isSeeMore2
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: Styles.textBlack18,
                      textAlign: TextAlign.justify,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSeeMore2 = !isSeeMore2;
                        });
                      },
                      child: Text(
                        (isSeeMore2 ? 'See Less' : 'See More'),
                        style: TextStyle(
                            fontSize: getFontSize(20),
                            color: CustomColors.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: getVerticalSize(20),),
                    Text("Important Information",style: Styles.textBlack20B),
                    SizedBox(height: getVerticalSize(15),),
                    Text('''
* The Price given here is per person based on a minimum of 2 people.
The price will be cheaper with an increase in the number of people.

* Single Supplement is applied (if you are single trekker)''', style: Styles.textBlack18)
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
