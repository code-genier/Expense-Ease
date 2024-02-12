import 'package:expense_ease/db/expense_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';

class ExpenseIncomeTile extends StatelessWidget {
  final String amount;
  final bool income;
  final String currency;
  final String selectedMonth;

  const ExpenseIncomeTile({
    super.key,
    required this.amount,
    required this.income,
    required this.currency,
    required this.selectedMonth,
  });

  @override
  Widget build(BuildContext context) {

    void showData(){
      HapticFeedback.lightImpact();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Container(
        decoration: BoxDecoration(
          // color: income?Colors.green:Colors.red.shade400,
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: GestureDetector(
        onTap: showData,
        child: Row(
          children: [
            (income)?Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.add,
                color: Colors.black,
                size: 15,
              ),
            ):Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Icon(
                Icons.remove_outlined,
                color: Colors.red,
                size: 15,
              ),
            ),
            const SizedBox(width: 10,),
            Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${income?"Earning":"Expenses"} on $selectedMonth",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white38,
                      ),
                    ),
                    Text(
                      "$currency$amount",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                      // overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      ),
    );
  }
}
