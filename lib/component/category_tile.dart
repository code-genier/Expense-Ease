import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String category;
  final double percent;
  final String amount;
  final String currency;

  const CategoryTile({
    super.key,
    required this.category,
    required this.amount,
    required this.percent,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    String formatAsCurrency(double number) {
      NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
      String formattedNumber = numberFormat.format(number);
      return formattedNumber;
    }
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
          ),
          child: CircularPercentIndicator(
            radius: 50.0,
            lineWidth: 10.0,
            animation: true,
            percent: percent/100,
            center: Text(
              "${percent.toString().substring(0, 4)}%",
              style:
              const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
              ),
            ),
            footer: Column(
              children: [
                const SizedBox(height: 8,),
                Text(
                  category.toUpperCase(),
                  style:
                  const TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                  ),
                ),
                Text(
                  '$currency${formatAsCurrency(double.parse(amount))}',
                  style:
                  const TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.red,
          ),
        ),
        const SizedBox(width: 8,),
      ],
    );
  }
}
