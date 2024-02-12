import 'package:expense_ease/component/heading_tile.dart';
import 'package:expense_ease/component/message_tile.dart';
import 'package:flutter/material.dart';

class ShowLatestTransaction extends StatelessWidget {
  final List<String> currentMonthPaymentMessage;
  final Map<String, List<String>> paymentMessage;
  final String currency;

  const ShowLatestTransaction({
    super.key,
    required this.currentMonthPaymentMessage,
    required this.paymentMessage,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (currentMonthPaymentMessage.length>0)?MessageTile(
            currency: currency,
            category: paymentMessage[currentMonthPaymentMessage[0]]![4],
            amount: paymentMessage[currentMonthPaymentMessage[0]]![3],
            date: DateTime.parse(paymentMessage[currentMonthPaymentMessage[0]]![0]),
            sender: paymentMessage[currentMonthPaymentMessage[0]]![1],
            body: paymentMessage[currentMonthPaymentMessage[0]]![2],
        ):const SizedBox(height: 0,),
        (currentMonthPaymentMessage.length>1)?MessageTile(
          currency: currency,
          category: paymentMessage[currentMonthPaymentMessage[1]]![4],
          amount: paymentMessage[currentMonthPaymentMessage[1]]![3],
          date: DateTime.parse(paymentMessage[currentMonthPaymentMessage[1]]![0]),
          sender: paymentMessage[currentMonthPaymentMessage[1]]![1],
          body: paymentMessage[currentMonthPaymentMessage[1]]![2],
        ):const SizedBox(height: 0,),
        (currentMonthPaymentMessage.isEmpty)?const Text(
            "No transactions this month",
          style: TextStyle(
            color: Colors.white38,
          ),
        ):const SizedBox(height: 0,)
      ],
    );
  }
}
