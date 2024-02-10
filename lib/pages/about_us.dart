import 'package:flutter/material.dart';
import 'package:trekking_guide/utils/custom_colors.dart';

import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class AboutUsPage extends StatefulWidget {
  AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String intro =
      ''' "Welcome to Himalayan Wander Walkers! where veteran team is specialize in creating unforgettable experiences for trekking and tours enthusiasts of all levels. Our team of experienced and knowledgeable guides will take you on a journey through some of the most breathtaking landscapes in the world, from the towering peaks of the Himalayas to the lush forests and valleys that surround them. Whether you're a seasoned hiker or a first-time adventurer, we have a range of treks to suit your needs, from short and easy treks to challenging multi-day expeditions (Trekking and Peak Climbing). With our commitment to sustainable tourism and local communities, you can feel good knowing that your trip is not only an incredible adventure but also a responsible and ethical one.

Join with us for lifetime adventure Trips in the majestic country of Nepal, Tibet, Bhutan, and Mongolia. 

"Caring Your Holidays in the Himalayan Nations since 2010"''';

  bool isSeeMore = false;
  List<String> teamImage = [
    'assets/rigzin.jpg',
    'assets/rajendra.jpg',
    'assets/dawa.jpg'
  ];
  List<String> name = [
    "Mr. Rigzin W. Gurung",
    "Rajendra Shrestha",
    "Mr. Dawa T. Gurung"
  ];
  List<String> title = ["Chairman", "Tour Operator", "Managing Director"];

  @override
  Widget build(BuildContext context) {
    final lines = isSeeMore ? null : 8;
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
          "About us",
          style: Styles.textWhite34B,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: getVerticalSize(350),
              width: double.infinity,
              child: Image.asset(
                'assets/hww.jpg',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: getVerticalSize(25),
            ),
            Container(
                margin: EdgeInsets.symmetric(
                    horizontal: getHorizontalSize(20),
                    vertical: getVerticalSize(10)),
                child: Column(
                  children: [
                    Text(
                      "Namaste and Tashi Delek! ",
                      style: Styles.textBlack26B,
                    ),
                    SizedBox(
                      height: getVerticalSize(20),
                    ),
                    Text(
                      intro,
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
              height: getVerticalSize(30),
            ),
            Container(
              width: getHorizontalSize(350),
              height: getVerticalSize(480),
              
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      width: getSize(2), color: CustomColors.primaryColor),
                  borderRadius: BorderRadius.circular(getSize(15)),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: getVerticalSize(10),
                  ),
                  Text(
                    "Our Team",
                    style: Styles.textBlack32B,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 180,
                        childAspectRatio: 1,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemCount: teamImage.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ClipOval(
                              child: Container(
                                height: getVerticalSize(120),
                                width: getHorizontalSize(150),
                                // margin: EdgeInsets.only(bottom: getVerticalSize(20)),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(120),
                                  image: DecorationImage(
                                    image: AssetImage(teamImage[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: getVerticalSize(6),
                            ),
                            Text(
                              name[index],
                              style: Styles.textBlack16,
                            ),
                            // SizedBox(
                            //   height: getVerticalSize(5),
                            // ),
                            Text(
                              title[index],
                              style: Styles.textBlack16,
                            ),
                            // SizedBox(
                            //   height: getVerticalSize(20),
                            // )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
