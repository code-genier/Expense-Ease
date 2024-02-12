import 'package:expense_ease/component/category_tile.dart';
import 'package:expense_ease/component/heading_tile.dart';
import 'package:expense_ease/component/message_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../component/expense_income_tile.dart';

class MonthlyTransactionInfo extends StatefulWidget {
  final String month;
  final String monthId;
  final String currency;
  final List<Map<String, String>> data; // category, amount
  final Map<String, List<String>> monthlyExpenseIncome;
  final Map<String, double> dataAmount;
  final List<String> monthlyMessage;
  final Map<String, List<String>> paymentMessage;
  // final Map<String, Map<String, String>> monthlyCategoryAmount;

  const MonthlyTransactionInfo({
    super.key,
    required this.month,
    required this.monthId,
    required this.currency,
    required this.data,
    required this.dataAmount,
    required this.monthlyExpenseIncome,
    required this.paymentMessage,
    required this.monthlyMessage,
  });

  @override
  State<MonthlyTransactionInfo> createState() => _MonthlyTransactionInfoState();
}

class _MonthlyTransactionInfoState extends State<MonthlyTransactionInfo> {

  String formatAsCurrency(double number) {
    NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
    String formattedNumber = numberFormat.format(number);
    return formattedNumber;
  }

  @override
  Widget build(BuildContext context) {
    double currentMonthExpense = 0, currentMonthIncome = 0;

    if (widget.monthlyExpenseIncome[widget.monthId] != null) currentMonthExpense = double.parse(widget.monthlyExpenseIncome[widget.monthId]![0]);
    if (widget.monthlyExpenseIncome[widget.monthId] != null) currentMonthIncome = double.parse(widget.monthlyExpenseIncome[widget.monthId]![1]);

    String currentMonthExpenseString = formatAsCurrency(currentMonthExpense);
    String currentMonthIncomeString = formatAsCurrency(currentMonthIncome);


    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "DETAILED INFO",
          style: TextStyle(
            color: Colors.white38,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: Column(
          children: [
            const HeadingTile(
                data: "Earning and expense summary:",
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ExpenseIncomeTile(
                    amount: currentMonthIncomeString,
                    income: true,
                    currency: widget.currency,
                    selectedMonth: widget.month,
                  ),
                ),
                const SizedBox(width: 8,),
                Expanded(
                  child: ExpenseIncomeTile(
                    amount: currentMonthExpenseString,
                    income: false,
                    currency: widget.currency,
                    selectedMonth: widget.month,
                  ),
                ),
              ],
            ),
            (widget.data.isNotEmpty)?const HeadingTile(
                data: "Category wise summary:"
            ):const SizedBox(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20),
                // color: (data.entries.first.value < 0) ? Colors.red.shade800 : Colors.green.shade800,
              ),
              child: ListView.builder(
              itemCount: widget.data.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index){
                double percent = double.parse(widget.data[index].entries.first.value);
                String category = widget.data[index].entries.first.key;
                String amount = widget.dataAmount[category]!.toString();
                  return CategoryTile(
                      category: category,
                      amount: amount,
                      percent: percent,
                      currency: widget.currency,
                  );
                }
              ),
            ),
            const HeadingTile(
                data: "Transactions:"
            ),
            Expanded(
                child: ListView.builder(
                itemCount: widget.monthlyMessage.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index){
                  String smsId = widget.monthlyMessage[index];
                  return MessageTile(
                      currency: widget.currency,
                      category: widget.paymentMessage[smsId]![4]??"",
                      amount: widget.paymentMessage[smsId]![3]??"",
                      date:  DateTime.parse(widget.paymentMessage[smsId]![0])??DateTime.now(),
                      sender:  widget.paymentMessage[smsId]![1]??"",
                      body:  widget.paymentMessage[smsId]![2]??"",
                  );
                })
            )
          ],
        ),
      ),
    );
  }
}
