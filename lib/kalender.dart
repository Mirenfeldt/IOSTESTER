import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'navigationbars.dart';

class KalenderWidget extends StatefulWidget {
  const KalenderWidget({super.key});
  @override
  State<KalenderWidget> createState() => _KalenderWidgetState();
}

class _KalenderWidgetState extends State<KalenderWidget> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 228),
      appBar: Topappbar(pagename: "Kalender"),
      bottomNavigationBar: const Bottomappbar(),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              reverse: true,
              itemBuilder: (context, index) {
                DateTime month = DateTime(
                    _selectedDate.year, _selectedDate.month - index, 1);
                return MonthView(month: month);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MonthView extends StatelessWidget {
  final DateTime month;

  const MonthView({required this.month});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Display the month name and year
        Text(
          DateFormat.yMMMM().format(month),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8), // Space between header and grid
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // 7 columns for 7 days of the week
              mainAxisSpacing: 1, // Vertical gridline thickness
              crossAxisSpacing: 1, // Horizontal gridline thickness
            ),
            itemCount: _daysInMonth(month),
            itemBuilder: (context, index) {
              DateTime day = DateTime(month.year, month.month, index + 1);
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300, // Gridline color
                    width: 0.5, // Gridline thickness
                  ),
                ),
                child: Center(
                  child: Text(
                    DateFormat.d().format(day),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Calculate the number of days in a given month
  int _daysInMonth(DateTime month) {
    return DateTime(month.year, month.month + 1, 0).day;
  }
}
