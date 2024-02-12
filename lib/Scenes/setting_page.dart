import 'package:expense_ease/component/change_currency_tile.dart';
import 'package:expense_ease/component/change_name_tile.dart';
import 'package:flutter/material.dart';

import '../component/change_startdate_tile.dart';

class SettingPage extends StatelessWidget {
  final String userName;
  final DateTime startDate;
  final String currency;
  void Function(String) changeName;
  void Function(DateTime) changeStartDate;
  void Function(String) changeCurrency;

  SettingPage({
    super.key,
    required this.userName,
    required this.changeName,
    required this.startDate,
    required this.changeStartDate,
    required this.currency,
    required this.changeCurrency,
  });

  @override
  Widget build(BuildContext context) {

    void changeNameLocal(dynamic data){
      changeName(data);
    }

    void changeStartDateLocal(dynamic data){
      changeStartDate(data);
    }

    void changeCurrencyLocal(dynamic data){
      changeCurrency(data);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SETTINGS",
          style: TextStyle(
            color: Colors.white38,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  ChangeNameTile(
                    title: "Username",
                    currData: userName,
                    changeData: changeNameLocal,
                  ),
                  const SizedBox(height: 10,),
                  ChangeStartDateTile(
                    title: "Start date",
                    currData: startDate.toString(),
                    changeData: changeStartDateLocal,
                  ),
                  const SizedBox(height: 10,),
                  ChangeCurrencyTile(
                      title: "Currency",
                      currData: currency,
                      changeData: changeCurrencyLocal,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
