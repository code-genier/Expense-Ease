import 'dart:ffi';
import 'dart:math';

import 'package:expense_ease/component/current_month_tile.dart';
import 'package:expense_ease/component/heading_tile.dart';
import 'package:expense_ease/component/message_tile.dart';
import 'package:expense_ease/component/show_latest_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_month_picker/flutter_month_picker.dart';
import 'package:intl/intl.dart';
import '../component/expense_income_tile.dart';
import '../component/savings_tile.dart';
import '../component/expense_graph.dart';

class HomePage extends StatefulWidget {
  final String currency;
  final String userName;
  final DateTime startDate;
  final String savings;
  final Map<String, List<String>> monthlyExpenseIncome;
  final Map<String, List<String>> monthlyPaymentMessage;
  final Map<String, List<String>> paymentMessage;
  final Map<String, Map<String, String>> monthlyCategoryAmount;
  void Function(DateTime) changeStartDate;

  HomePage({
    Key? key,
    required this.currency,
    required this.startDate,
    required this.userName,
    required this.savings,
    required this.monthlyExpenseIncome,
    required this.monthlyCategoryAmount,
    required this.monthlyPaymentMessage,
    required this.paymentMessage,
    required this.changeStartDate,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selected = DateTime.now();
  List<String> _monthList = [];
  List<double> _monthExpense = [];
  List<String> _currentMonthSms = [];
  String _monthId = "";
  List<Map<String, String>> _data = [];
  Map<String, double> _dataAmount = {};
  double _totalExpense = 0;
  bool loading = true;
  String currentMonth = "";

  String formatAsCurrency(double number) {
    NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
    String formattedNumber = numberFormat.format(number);
    return formattedNumber;
  }

  void getData() {
    List<Map<String, String>> data = [];
    Map<String, double> dataAmount = {};
    double totalExpense = 0;
    String monthId = "${selected.month}-${selected.year}";
    print(monthId);
    print(widget.monthlyCategoryAmount.containsKey(monthId));

    if(widget.monthlyCategoryAmount[monthId] != null) {
      for (var item in widget.monthlyCategoryAmount[monthId]!.entries) {
        if (item.key != "income") {
          totalExpense += double.parse(item.value);
          if(dataAmount.containsKey(item.key)){
            dataAmount[item.key] = dataAmount[item.key]! + double.parse(item.value);
          }
          else{
            dataAmount[item.key] = double.parse(item.value);
          }
        }
      }
    }

    if(widget.monthlyCategoryAmount[monthId] != null) {
      for (var item in widget.monthlyCategoryAmount[monthId]!.entries) {
        if (item.key != "income") {
          Map<String, String> mp = {};
          mp[item.key] = (double.parse(item.value)*100/totalExpense).toString();
          data.add(mp);
        }
      }
    }



    data.sort((a, b) {
      return double.parse(b.entries.first.value)
          .compareTo(double.parse(a.entries.first.value));
    });

    if (mounted) {
      setState(() {
        _data = data;
        _dataAmount = dataAmount;
        _totalExpense = totalExpense;
        _monthId = monthId;
      });
    }
  }

  void getFiveMonthDetails(){
    List<String> monthList = [];
    List<double> monthExpense = [];
    int currentMonth = selected.month;
    int currentYear = selected.year;

    for (int i = 0; i < 6; i++) {
      int month = currentMonth - i;
      int year = currentYear;

      // Adjust year and month if needed
      if (month <= 0) {
        month += 12;
        year -= 1;
      }
      monthList.add(getMonthNameShort(month));
      String monthId = "$month-$year";
      if(widget.monthlyExpenseIncome[monthId] != null) monthExpense.add(double.parse(widget.monthlyExpenseIncome[monthId]![0]));
    }

    if(mounted){
      setState(() {
        _monthExpense = monthExpense;
        _monthList = monthList;
      });
    }
  }

  String getMonthNameShort(int month) {
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    if (month >= 1 && month <= 12) {
      return monthNames[month - 1];
    } else {
      return 'Invalid Month';
    }
  }

  void changeMonth(DateTime x){
    if(mounted){
      setState(() {
        selected = x;
        currentMonth = getMonthNameShort(selected.month);
        getData();
        getFiveMonthDetails();
        getLatestTransaction();
      });
    }
  }

  void getLatestTransaction(){
    String monthId = "${selected.month}-${selected.year}";
    List<String> sms = widget.monthlyPaymentMessage[monthId]??[];
    List<String> currentMonthSms = [];
    for(int i = 0; i < min(5, sms.length); i++){
      currentMonthSms.add(sms[i]);
    }

    if(mounted){
      setState(() {
        _currentMonthSms = currentMonthSms;
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _monthId = "${selected.month}-${selected.year}";
    currentMonth = getMonthNameShort(selected.month);
    getData();
    getFiveMonthDetails();
    getLatestTransaction();
  }

  @override
  Widget build(BuildContext context) {
    String monthId = "${selected.month}-${selected.year}";
    String latestTranxString = "Latest Transactions on $currentMonth-${selected.year}:";
    double currentMonthExpense = 0, currentMonthIncome = 0;
    if (widget.monthlyExpenseIncome[monthId] != null) currentMonthExpense = double.parse(widget.monthlyExpenseIncome[monthId]![0]);
    if (widget.monthlyExpenseIncome[monthId] != null) currentMonthIncome = double.parse(widget.monthlyExpenseIncome[monthId]![1]);

    String currentMonthExpenseString = formatAsCurrency(currentMonthExpense);
    String currentMonthIncomeString = formatAsCurrency(currentMonthIncome);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "HELLO, ${widget.userName.toUpperCase()}",
          style: const TextStyle(
            color: Colors.white38,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SavingsTile(
                  currency: widget.currency,
                  startDate: widget.startDate,
                  savings: formatAsCurrency(double.parse(widget.savings)),
                  changeStartDate: widget.changeStartDate,
                ),
                CurrentMonthTile(
                  changeMonth: changeMonth,
                  getData: getData,
                  getFiveMonthDetails: getFiveMonthDetails,
                  currency: widget.currency,
                  monthId: _monthId,
                  month: getMonthNameShort(selected.month),
                  monthlyExpenseIncome: widget.monthlyExpenseIncome,
                  data: _data,
                  dataAmount: _dataAmount,
                  paymentMessage: widget.paymentMessage,
                  monthlyMessage: widget.monthlyPaymentMessage[monthId]??[],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ExpenseIncomeTile(
                        amount: currentMonthIncomeString,
                        income: true,
                        currency: widget.currency,
                        selectedMonth: "$currentMonth",
                      ),
                    ),
                    const SizedBox(width: 8,),
                    Expanded(
                      child: ExpenseIncomeTile(
                        amount: currentMonthExpenseString,
                        income: false,
                        currency: widget.currency,
                        selectedMonth: "$currentMonth",
                      ),
                    ),
                  ],
                ),
                HeadingTile(data: "Last 5 months expense analysis from $currentMonth-${selected.year}:"),
                (_monthExpense.isNotEmpty && _monthList.isNotEmpty)?Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: LineChartSample2(
                    monthExpense: _monthExpense,
                    monthList: _monthList,
                  ),
                ):const SizedBox(),
                const SizedBox(height: 10,),
                HeadingTile(
                  data: latestTranxString,
                ),
                ShowLatestTransaction(
                    currentMonthPaymentMessage: _currentMonthSms,
                    paymentMessage: widget.paymentMessage,
                    currency: widget.currency,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
