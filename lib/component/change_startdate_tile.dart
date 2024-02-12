import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';

class ChangeStartDateTile extends StatefulWidget {
  final String title;
  final String currData;
  void Function(dynamic) changeData;

  ChangeStartDateTile({
    super.key,
    required this.title,
    required this.currData,
    required this.changeData,
  });

  @override
  State<ChangeStartDateTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<ChangeStartDateTile> {
  DateTime? _date;
  @override

  @override
  Widget build(BuildContext context) {
    void showDateTimePicker(){
      DatePickerBdaya.showDateTimePicker(context,
          showTitleActions: true,
          theme: const DatePickerThemeBdaya(
              headerColor: Colors.red,
              backgroundColor: Colors.black,
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
            HapticFeedback.lightImpact();
            setState(() {
              _date = date;
            });
          },
          onConfirm: (date) {
            HapticFeedback.lightImpact();
            widget.changeData(date);
          },
          currentTime: DateTime.now(), locale: LocaleType.en
      );
    }

    void changeBtn(){
      HapticFeedback.lightImpact();
      showDateTimePicker();
    }

    void onSubmit(){
      return;
    }

    void onDone(){
      onSubmit();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
        // color: (data.entries.first.value < 0) ? Colors.red.shade800 : Colors.green.shade800,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        widget.currData.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 18,
                        )
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: changeBtn,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white70),
                        foregroundColor: MaterialStateProperty.all(
                            Colors.black),
                      ),
                      child: const Text(
                        "Change",
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
