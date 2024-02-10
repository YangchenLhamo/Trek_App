import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:trekking_guide/utils/custom_colors.dart';

import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class TipsFaqPage extends StatefulWidget {
  TipsFaqPage({super.key});

  @override
  State<TipsFaqPage> createState() => _TipsFaqPageState();
}

class _TipsFaqPageState extends State<TipsFaqPage> {
  String tips = ''' 
Here are some additional travel and trekking tips for Nepal:

1. Carry essential medications and first aid supplies.
2. Learn basic Nepali phrases and respect local culture.
3. Bring high-energy snacks and water purification tablets.
4. Stay connected with emergency contacts and travel insurance.
5. Check weather forecasts and trail conditions regularly.
6. Take breaks, listen to your body, and avoid overexertion.
7. Practice responsible tourism and support local communities.
8. Carry extra batteries/power banks for electronic devices.
9. Inform someone about your trekking itinerary and expected return.
10. Be prepared for altitude sickness and know the symptoms.
11. Use sunscreen, wear sunglasses, and protect against insects.
12. Carry cash in Nepali currency for remote areas without ATMs.
13. Stay on designated trails to preserve the environment.
14. Respect wildlife and avoid feeding or disturbing animals.
15. Enjoy the breathtaking scenery and make memories responsibly.''';

  String faqs =
      '''Here are some common FAQs related to travel and trekking in Nepal along with short answers:

Q: What is the best time to visit Nepal for trekking?
A: The best trekking seasons are spring (March to May) and autumn (September to November).

Q: Do I need a visa to travel to Nepal?
A: Yes, most nationalities require a visa to enter Nepal, which can be obtained on arrival or from Nepalese diplomatic missions abroad.

Q: Is it safe to trek alone in Nepal?
A: While solo trekking is possible in many areas, it's generally safer to trek with a guide or in a group, especially in remote regions.

Q: What permits do I need for trekking in Nepal?
A: The most common permits are the TIMS (Trekkers' Information Management System) card and the Annapurna Conservation Area Permit (ACAP) or Sagarmatha National Park Permit, depending on the trekking area.

Q: What should I pack for a trek in Nepal?
A: Essential items include sturdy hiking boots, warm clothing, a sleeping bag, water purification tablets, sunscreen, insect repellent, and a first aid kit.

Q: How do I prepare for high-altitude trekking in Nepal?
A: Proper acclimatization is crucial. Gradual ascent, staying hydrated, and recognizing symptoms of altitude sickness are essential.

Q: Are there ATMs and Wi-Fi available during treks in Nepal?
A: While major trekking routes may have ATMs and lodges with Wi-Fi, remote areas may have limited or no access to these facilities.

Q: Can I drink tap water during treks in Nepal?
A: It's not recommended to drink tap water. Always use bottled water or purify water using tablets or a filtration system.

Q: How do I book a trekking guide or porter in Nepal?
A: Guides and porters can be hired through trekking agencies in Kathmandu or Pokhara, or arranged directly in trekking regions.

Q: What are the risks of trekking in Nepal?
A: Risks include altitude sickness, unpredictable weather, landslides, avalanches, and encounters with wildlife. Proper preparation and caution can mitigate these risks.''';


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
          "Tips & FAQs",
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
                        " Tips for the journey",
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
                      tips,
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
                        " Some Frequently Aksed Questions",
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
                      faqs,
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
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
