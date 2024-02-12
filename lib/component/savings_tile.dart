import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_month_picker/flutter_month_picker.dart';
import 'package:intl/intl.dart';


class SavingsTile extends StatelessWidget {
  final String currency;
  final DateTime startDate;
  final String savings;
  void Function(DateTime) changeStartDate;


  SavingsTile({
    super.key,
    required this.currency,
    required this.startDate,
    required this.savings,
    required this.changeStartDate,
  });

  @override
  Widget build(BuildContext context) {
    String formatDateTime(DateTime dateTime) {
      final formattedDate = DateFormat('dd-MMM-yyyy HH:mm').format(dateTime);
      return formattedDate;
    }

    String formattedDate = formatDateTime(startDate);

    void changeStartDateClick(){
      DatePickerBdaya.showDateTimePicker(context,
          showTitleActions: true,
          minTime: DateTime(2000, 5, 5, 20, 50),
          maxTime: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 05, 06),
          theme: const DatePickerThemeBdaya(
              headerColor: Colors.black,
              backgroundColor: Colors.black12,
              itemStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              doneStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
              cancelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
              )
          ),
          onChanged: (date) {
          },
          onConfirm: (date) {
            changeStartDate(date);
          },
          currentTime: DateTime.now(), locale: LocaleType.en
      );
    }

    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          const Row(
            children: [
              Text(
                "Total savings:",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  "$currency$savings",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.white70,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8,),
          Row(
            children: [
              Text(
                "(since $startDate)",
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.white38,
                ),
              ),
            ],
          ),
          // TextButton(
          //   onPressed: changeStartDateClick,
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all(
          //         Colors.grey.shade900),
          //     foregroundColor: MaterialStateProperty.all(
          //         Colors.white70),
          //   ),
          //   child: const Text(
          //     "Change",
          //     style: TextStyle(
          //       fontSize: 13,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
