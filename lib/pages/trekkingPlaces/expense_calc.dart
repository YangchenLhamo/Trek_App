import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trekking_guide/pages/about_us.dart';
import 'package:trekking_guide/pages/trekkingPlaces/include_exclude.dart';
import 'package:trekking_guide/utils/custom_colors.dart';
import 'package:trekking_guide/utils/size_utils.dart';
import 'package:trekking_guide/utils/text_styles.dart';

class ExpenseCalculatorScreen extends StatefulWidget {
  ExpenseCalculatorScreen({super.key, required this.title});
  String title;

  @override
  // ignore: library_private_types_in_public_api
  _ExpenseCalculatorScreenState createState() =>
      _ExpenseCalculatorScreenState();
}

class _ExpenseCalculatorScreenState extends State<ExpenseCalculatorScreen> {
  String _selectedTrek = 'Basic';
  // Default trek type
  String _currency = 'Nep';
  int _numberOfParticipants = 1;
  int _numberOfDay = 1;
  int _totalSharedServiceCost = 0;
  double _expenses = 0.0;
  double _expensesPerPerson = 0.0;
  double _totalExpenses = 0.0;
  String _area = 'Mardi Himal';
  String _accomodation = 'Camping';
  Map<String, int> serviceOption = {
    'Guide : \$15/Day': 1500,
    'Porter : \$12/Day': 1200,
    'Cook : \$10/Day': 1000,
    'Sardar :\$8/Day': 800,
    'CLimbing Guide : \$20/Day': 2000
  };
  List<bool> selectedServices = [false, false, false, false, false];

  // Define the expenses for each trek type
  Map<String, double> trekExpenses = {
    'Basic': 10000.0,
    'Comfort': 15000.0,
  };

  Map<String, double> currencies = {
    'USD': 133.43,
    'Nep': 1.0,
    'Yuan': 18.65,
  };
  Set<String> trekArea = {
    'Sagarmatha Base Camp',
    'Annapurna Base Camp',
    'Mardi Himal'
  };
  Map<String, double> trekAccomodation = {
    'Tea House': 5000.0,
    'Camping': 300.0,
    'Lodges': 800.0
  };

// to calculate the total cost of the shared services only
  int calculateServiceExpenses() {
    int totalCost = 0;
    for (int i = 0; i < selectedServices.length; i++) {
      if (selectedServices[i]) {
        totalCost += serviceOption.values.toList()[i];
      }
    }
    return totalCost;
  }

  void _calculateSharedServiceCost() {
    setState(() {
      _totalSharedServiceCost = calculateServiceExpenses();
    });
  }

  String name = "name";
  // Function to get the currency symbol based on the selected currency
  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'Nep':
        return 'रू';
      case 'Yuan':
        return '¥';
      default:
        return '';
    }
  }

// all the calculation done here
  void _calculateExpenses() {
    _calculateSharedServiceCost();
    setState(() {
      // without any services
      _expenses = (trekExpenses[_selectedTrek] ?? 0.0) +
          (trekAccomodation[_accomodation] ?? 0.0);

      // expense of a person with the shared services
      _expensesPerPerson = _expenses + _totalSharedServiceCost;

      // expense of total people
      _totalExpenses = (_numberOfParticipants * _numberOfDay * _expenses) +
          _totalSharedServiceCost;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch trek areas from Firestore
    FirebaseFirestore.instance
        .collection("TrekkingPlaces")
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        // If there are documents in the collection
        List<String> areas = [];
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          // Add each title to the list
          areas.add(doc.id);
        });
        setState(() {
          name = "title";
          // Update the trek areas list
          trekArea = areas.toSet();

          // // Set the initial value of _area if it's not already set
          if (!trekArea.contains(_area)) {
            _area = trekArea.first;
          }

          _area = widget.title;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        title: Text(
          'Expense Calculator',
          style: Styles.textWhite28B,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(getHorizontalSize(10),
              getVerticalSize(10), getHorizontalSize(10), 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Trekking Area : ",
                    style: Styles.textBlack20,
                  ),
                  SizedBox(
                    height: getVerticalSize(30),
                  ),
                  DropdownButton<String>(
                    value: _area,
                    onChanged: (newValue) {
                      setState(() {
                        _area = newValue!;
                      });
                    },
                    items: trekArea.map((String trek) {
                      return DropdownMenuItem<String>(
                        value: trek,
                        child: Text(trek),
                      );
                    }).toList(),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Text(
                        'Packages : ',
                        style: Styles.textBlack20,
                      ),
                      DropdownButton<String>(
                        value: _selectedTrek,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTrek = newValue!;
                          });
                        },
                        items: trekExpenses.keys.map((String trek) {
                          return DropdownMenuItem<String>(
                            value: trek,
                            child: Text(trek),
                          );
                        }).toList(),
                      )
                    ],
                  )),
                  // for currency
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Currency : ',
                          style: Styles.textBlack20,
                        ),
                        DropdownButton<String>(
                          value: _currency,
                          onChanged: (String? newValue) {
                            setState(() {
                              _currency = newValue!;
                              // Use the static currencies map to get the conversion rate
                              // _currencyRate = currencies[_currency] ?? 1.0;
                            });
                          },
                          items: currencies.keys.map((String trek) {
                            return DropdownMenuItem<String>(
                              value: trek,
                              child: Text(trek),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Accomodation :  ',
                    style: Styles.textBlack20,
                  ),
                  DropdownButton<String>(
                    value: _accomodation,
                    onChanged: (String? newValue) {
                      setState(() {
                        _accomodation = newValue!;
                      });
                    },
                    items: trekAccomodation.keys.map((String trek) {
                      return DropdownMenuItem<String>(
                        value: trek,
                        child: Text(trek),
                      );
                    }).toList(),
                  )
                ],
              ),

              SizedBox(height: getVerticalSize(20)),
              // check box for services
              Text(
                'Shared Services',
                style: Styles.textBlack20B,
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              Container(
                  height: getVerticalSize(300),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: Colors.black, width: getSize(2))),
                  margin: EdgeInsets.only(right: getHorizontalSize(15)),
                  padding: EdgeInsets.fromLTRB(
                      getHorizontalSize(10),
                      getVerticalSize(5),
                      getHorizontalSize(10),
                      getVerticalSize(5)),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: serviceOption.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(serviceOption.keys.toList()[index]),
                          value: selectedServices[index],
                          onChanged: (bool? value) {
                            setState(() {
                              selectedServices[index] = value!;
                            });
                          },
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: -1),
                        );
                      })),
              // const SizedBox(
              //   height: 30,
              // ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor),
                onPressed: () {
                  int totalCost = calculateServiceExpenses();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Total Cost'),
                        content:
                            Text('Total Cost of Selected Services: $totalCost'),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.primaryColor),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'OK',
                              style: Styles.textWhite20,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text(
                  'Submit',
                  style: Styles.textWhite20,
                ),
              ),
              SizedBox(
                height: getVerticalSize(20),
              ),
              // total claculation
              Text(
                'Number of People:',
                style: Styles.textBlack18,
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numberOfParticipants = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
              // total claculation
              Text(
                'Number of Day:',
                style: Styles.textBlack18,
              ),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _numberOfDay = int.tryParse(value) ?? 0;
                  });
                },
              ),
              SizedBox(height: getVerticalSize(20)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryColor),
                onPressed: _calculateExpenses,
                child: Text(
                  'Calculate Expenses',
                  style: Styles.textWhite20,
                ),
              ),
              SizedBox(height: getVerticalSize(20)),

              Text(
                'Expenses per person per day: ${_getCurrencySymbol(_currency)} ${_currency == 'USD' ? (_expensesPerPerson / 133.43).toStringAsFixed(3) : _currency == 'Yuan' ? (_expensesPerPerson / 18.65).toStringAsFixed(3) : (_expensesPerPerson * currencies['Nep']!).toStringAsFixed(3)}',
                style: Styles.textBlack18,
              ),
              Text(
                  'Total Expenses: ${_getCurrencySymbol(_currency)} ${_currency == 'USD' ? (_totalExpenses / 133.43).toStringAsFixed(3) : _currency == 'Yuan' ? (_totalExpenses / 18.65).toStringAsFixed(3) : (_totalExpenses * currencies['Nep']!).toStringAsFixed(3)}',
                  style: Styles.textBlack18),
              SizedBox(
                height: getVerticalSize(30),
              ),
              SizedBox(
                width: getHorizontalSize(220),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryColor),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => IncludeExcludePage()));
                  },
                  child: Row(
                    children: [
                      Text(
                        'Includes & Excludes',
                        style: Styles.textWhite20,
                      ),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.white,
                        size: getSize(20),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: getVerticalSize(30),
              ),
              Divider(
                color: CustomColors.primaryColor,
                height: getVerticalSize(2),
              ),
              SizedBox(
                height: getVerticalSize(10),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(getHorizontalSize(30), 0, 0, 0),
                width: getHorizontalSize(300),
                height: getVerticalSize(50),
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                        width: getSize(5), color: CustomColors.primaryColor),
                    borderRadius: BorderRadius.circular(getSize(15)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "For More Detail....",
                      style: Styles.textBlack18B,
                    ),
                    MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AboutUsPage()));
                        },
                        child: Text("Contact Us", style: Styles.textBlack18B)),
                  ],
                ),
              ),
              SizedBox(
                height: getVerticalSize(30),
              )
            ],
          ),
        ),
      ),
    );
  }
}
