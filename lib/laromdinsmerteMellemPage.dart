import 'package:flutter/material.dart';
import 'navigationbars.dart';
import 'fetch_data.dart' as data;
import 'larOmDinSmerteSoloDag.dart';

String chosenDateForLarOmDinSmerte = "";

class Laromdinsmerte extends StatefulWidget {
  Laromdinsmerte({super.key});

  @override
  State<Laromdinsmerte> createState() => _LaromdinsmerteState();
}

class _LaromdinsmerteState extends State<Laromdinsmerte> {
  // Define variables for font size and button height
  final double buttonFontSize = 18;
  final double samletButtonFontSize = 20;
  final double buttonHeight = 80;
  final double verticalPadding = 6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Lær om din smerte"),
      bottomNavigationBar: const Bottomappbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: buildColumnGode(),
              ),
              Expanded(
                child: buildColumnDarlig(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildColumnGode() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30),
        const Text(
          'Gode dage',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 0,
                      goodDay: true,
                      badDay: false,
                      chosenDate: data.godeDage[0],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[0],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 1,
                      goodDay: true,
                      badDay: false,
                      chosenDate: data.godeDage[1],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[1],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 2,
                      goodDay: true,
                      badDay: false,
                      chosenDate: data.godeDage[2],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[2],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 3,
                      goodDay: true,
                      badDay: false,
                      chosenDate: data.godeDage[3],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[3],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 4,
                      goodDay: true,
                      badDay: false,
                      chosenDate: data.godeDage[4],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.godeDage[4],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return LarOmDinSmerteSoloDagPage1(
                    chosenDateIndex: 5,
                    goodDay: true,
                    badDay: false,
                    chosenDate: "Samlet",
                  );
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.black,
            minimumSize: Size(double.infinity,
                buttonHeight), // Use variable for button height
          ),
          child: Text(
            'Samlet over de 5 gode dage',
            style: TextStyle(fontSize: samletButtonFontSize),
          ),
        ),
      ],
    );
  }

  Widget buildColumnDarlig() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 30),
        Text(
          'Dårlige dage',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 0,
                      goodDay: false,
                      badDay: true,
                      chosenDate: data.badDays[0],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[0],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 1,
                      goodDay: false,
                      badDay: true,
                      chosenDate: data.badDays[1],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[1],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 2,
                      goodDay: false,
                      badDay: true,
                      chosenDate: data.badDays[2],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[2],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 3,
                      goodDay: false,
                      badDay: true,
                      chosenDate: data.badDays[3],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[3],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return LarOmDinSmerteSoloDagPage1(
                      chosenDateIndex: 4,
                      goodDay: false,
                      badDay: true,
                      chosenDate: data.badDays[4],
                    );
                  },
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              side: BorderSide(color: Colors.red),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              minimumSize: Size(double.infinity,
                  buttonHeight), // Use variable for button height
            ),
            child: Text(
              data.badDays[4],
              style: TextStyle(
                  fontSize: buttonFontSize), // Use variable for font size
            ),
          ),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return LarOmDinSmerteSoloDagPage1(
                    chosenDateIndex: 5,
                    goodDay: false,
                    badDay: true,
                    chosenDate: "Samlet",
                  );
                },
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.black,
            minimumSize: Size(double.infinity,
                buttonHeight), // Use variable for button height
          ),
          child: Text(
            'Samlet over de 5 dårlige dage',
            style: TextStyle(fontSize: samletButtonFontSize),
          ),
        ),
      ],
    );
  }
}
