import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final String currency;
  final String category;
  final String amount;
  final DateTime date;
  final String sender;
  final String body;
  // final Map<String, double> categoryWithTotalAmount;
  // void Function(SmsMessage, String, String) changeCategory;

  MessageTile({
    super.key,
    required this.currency,
    required this.category,
    required this.amount,
    required this.date,
    required this.sender,
    required this.body,
    // required this.categoryWithTotalAmount,
    // required this.changeCategory,
  });

  @override
  Widget build(BuildContext context) {

    void showDetailPage(){
      HapticFeedback.lightImpact();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => ShowDetailInfo(
      //     data: data,
      //     category: category,
      //     currency: currency,
      //     changeCategory: changeCategory,
      //     categoryWithTotalAmount: categoryWithTotalAmount,
      //   )),
      // );
    }

    int getYear(DateTime dateTime) {
      return dateTime.year;
    }

    String getMonth(DateTime dateTime) {
      final DateFormat monthFormatter = DateFormat.MMM();
      return monthFormatter.format(dateTime);
    }

    int getDay(DateTime dateTime) {
      return dateTime.day;
    }

    String formatDateTime(DateTime dateTime) {
      final DateFormat formatter = DateFormat('MMMM d, yyyy HH:mm:ss');
      return formatter.format(dateTime);
    }

    String formatAsCurrency(double number) {
      NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
      String formattedNumber = numberFormat.format(number);
      return formattedNumber;
    }

    DateTime dateTime = date ?? DateTime.now();
    int year = getYear(dateTime);
    String month = getMonth(dateTime);
    int day = getDay(dateTime);


    return GestureDetector(
      onTap: showDetailPage,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
              // color: (data.entries.first.value < 0) ? Colors.red.shade800 : Colors.green.shade800,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade800, // Border color
                          width: 0.2, // Border width
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRect(
                            child: Row(
                              children: [
                                (category=="income") ? Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: const Icon(
                                    Icons.add_outlined,
                                    color: Colors.green,
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
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      " ${category.toString().toUpperCase()}",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    ClipRect(
                                      child: SizedBox(
                                        width: 100,
                                        child: Text(
                                          " ~ ${sender.toUpperCase()}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                  month.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  year.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              day.toString(),
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            body.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.grey.shade800,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "$currency${formatAsCurrency(double.parse(amount))}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: (category!="income") ? Colors.red : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8,),
        ],
      ),
    );
  }
}
