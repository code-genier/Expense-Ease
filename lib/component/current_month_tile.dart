import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_month_picker/flutter_month_picker.dart';

import '../Scenes/monthly_transaction_info.dart';

class CurrentMonthTile extends StatefulWidget {
  final String month;
  final String monthId;
  final String currency;
  final Map<String, List<String>> monthlyExpenseIncome;
  final List<Map<String, String>> data;
  void Function() getData;
  void Function() getFiveMonthDetails;
  void Function(DateTime) changeMonth;
  final Map<String, double> dataAmount;
  final List<String> monthlyMessage;
  final Map<String, List<String>> paymentMessage;

  CurrentMonthTile({
    super.key,
    required this.month,
    required this.monthId,
    required this.currency,
    required this.monthlyExpenseIncome,
    required this.getFiveMonthDetails,
    required this.changeMonth,
    required this.getData,
    required this.data,
    required this.dataAmount,
    required this.paymentMessage,
    required this.monthlyMessage,
  });

  @override
  State<CurrentMonthTile> createState() => _CurrentMonthTileState();
}

class _CurrentMonthTileState extends State<CurrentMonthTile> {
  DateTime selected = DateTime.now();


  Future<void> monthpicker() async {
    HapticFeedback.lightImpact();
    final selectedDate = await showMonthPicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 5),
      lastDate: DateTime(DateTime.now().year, DateTime.now().month),
    );

    if (selectedDate != null) {
      HapticFeedback.lightImpact();
      if (mounted) {
        setState(() {
          selected = selectedDate;
          widget.changeMonth(selected);
        });
      }
    } else {
      HapticFeedback.lightImpact();
      // The user canceled the selection
    }
  }

  String getMonthName(int month) {
    const monthNames = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    if (month >= 1 && month <= 12) {
      return monthNames[month - 1];
    } else {
      return 'Invalid Month';
    }
  }

  void showMonthTransaction(){
    HapticFeedback.lightImpact();
    Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MonthlyTransactionInfo(
            currency: widget.currency,
            monthlyExpenseIncome: widget.monthlyExpenseIncome,
            month: widget.month,
            monthId: widget.monthId,
            data: widget.data,
            dataAmount: widget.dataAmount,
            monthlyMessage: widget.monthlyMessage,
            paymentMessage: widget.paymentMessage,
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    String monthName = getMonthName(selected.month).toUpperCase();
    String year = selected.year.toString();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white10,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Colors.white38,
                ),
                Text(
                  "  $monthName - $year",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: showMonthTransaction,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white70),
                      foregroundColor: MaterialStateProperty.all(
                          Colors.black),
                    ),
                    child: const Text(
                      "All Transactions",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15,),
                Expanded(
                  child: TextButton(
                    onPressed: monthpicker,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white70),
                      foregroundColor: MaterialStateProperty.all(
                          Colors.black),
                    ),
                    child: const Text(
                      "Change Month",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
