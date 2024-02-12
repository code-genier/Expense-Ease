import 'package:hive_flutter/hive_flutter.dart';

class ExpenseDB{
  String userName = "";
  DateTime? lastScan;
  DateTime? startDate;
  String currency = "";
  double totalSavings = 0;
  Map<String, List<String>> category = {};
  Map<String, List<String>> paymentMessage = {}; // id, sms fields
  Map<String, List<String>> monthlyPaymentMessage = {}; // month, list of sms id
  Map<String, Map<String, String>> monthlyCategoryAmount = {}; // month, list of category, total amount
  Map<String, List<String>> monthlyExpenseIncome = {}; // month, {total expense, income}

  final _myBox = Hive.box("myBox");

  DateTime subtractYears(DateTime dateTime, int years) {
    return DateTime(dateTime.year - years, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute, dateTime.second, dateTime.millisecond, dateTime.microsecond);
  }

  void createInitialData(){
    userName = "User";
    startDate = subtractYears(DateTime.now(), 20);
    currency = "₹";
    totalSavings = 0;
    paymentMessage = {};
    monthlyPaymentMessage = {};
    monthlyCategoryAmount = {};
    monthlyExpenseIncome = {};
    category = {
      'shopping': ["collection", "dress", "mart"],
      'food': ["hungry", "meals", "kitchen", "kitchens", "catering", "restaurant", "res"],
      'travel': ['irctc'],
      'subscription': ['spotify'],
      'income': ['credited', 'credit'],
    };
  }

  void loadDate(){
    userName = _myBox.get("USERNAME");
    lastScan = DateTime.parse(_myBox.get("LASTSCAN"));
    currency = _myBox.get("CURRENCY");
    startDate = DateTime.parse(_myBox.get("STARTDATE"));
    totalSavings = _myBox.get("TOTALSAVINGS");
    paymentMessage = paymentMessageMap(_myBox.get("PAYMENTMESSAGE"));
    category = categoryMap(_myBox.get("CATEGORY"));
    monthlyPaymentMessage = categoryMap(_myBox.get("MONTHLYPAYMENTMESSAGE"));
    monthlyExpenseIncome = categoryMap(_myBox.get("MONTHLYEXPENSEINCOME"));
    monthlyCategoryAmount = monthlyCategoryAmountMap(_myBox.get("MONTHLYCATEGORYAMOUNT"));
  }

  void updateData(){
    _myBox.put("USERNAME", userName);
    _myBox.put("LASTSCAN", lastScan.toString());
    _myBox.put("CURRENCY", currency);
    _myBox.put("STARTDATE", startDate.toString());
    _myBox.put("TOTALSAVINGS", totalSavings);
    _myBox.put("PAYMENTMESSAGE", paymentMessageList());
    _myBox.put("CATEGORY", categoryList());
    _myBox.put("MONTHLYPAYMENTMESSAGE", monthlyPaymentMessageList());
    _myBox.put("MONTHLYEXPENSEINCOME", monthlyExpenseIncomeList());
    _myBox.put("MONTHLYCATEGORYAMOUNT", monthlyCategoryAmountList());
  }

  List<Map<dynamic, dynamic>> paymentMessageList(){
    List<Map<dynamic, dynamic>> categoryList = [];
    for(var i in paymentMessage.entries){
      Map<dynamic, dynamic> mp = {};
      mp[i.key] = i.value;
      categoryList.add(mp);
    }
    return categoryList;
  }

  Map<String, List<String>> paymentMessageMap(List<dynamic> x){
    Map<String, List<String>> ans = {};
    for(int i = 0; i < x.length; i++){
      ans[x[i].entries.first.key] = x[i].entries.first.value;
    }
    return ans;
  }

  List<Map<dynamic, dynamic>> categoryList(){
    List<Map<dynamic, dynamic>> categoryList = [];
    category.forEach((key, value) {
      categoryList.add({key: value});
    });
    return categoryList;
  }

  Map<String, List<String>> categoryMap(List<dynamic> x){
    Map<String, List<String>> ans = {};
    for(int i = 0; i < x.length; i++){
      ans[x[i].entries.first.key] = x[i].entries.first.value;
    }
    return ans;
  }

  List<Map<dynamic, dynamic>> monthlyPaymentMessageList(){
    List<Map<dynamic, dynamic>> categoryList = [];
    monthlyPaymentMessage.forEach((key, value) {
      categoryList.add({key: value});
    });
    return categoryList;
  }

  List<Map<dynamic, dynamic>> monthlyExpenseIncomeList(){
    List<Map<dynamic, dynamic>> categoryList = [];
    monthlyExpenseIncome.forEach((key, value) {
      categoryList.add({key: value});
    });
    return categoryList;
  }

  List<Map<String, dynamic>> monthlyCategoryAmountList(){
    List<Map<String, dynamic>> resultList = [];
    monthlyCategoryAmount.forEach((key, value) {
      Map<String, dynamic> entry = {'mainKey': key, 'subMap': value};
      resultList.add(entry);
    });
    return resultList;
  }

  Map<String, Map<String, String>> monthlyCategoryAmountMap(List<dynamic> x) {
    Map<String, Map<String, String>> resultMap = {};

    for (var map in x) {
      if (map is Map<String, dynamic>) {
        String key = map.keys.first;
        Map<String, String> convertedMap = Map.fromEntries(
          map.entries.map((entry) => MapEntry(entry.key, entry.value.toString())),
        );
        resultMap[key] = convertedMap;
      }
    }

    return resultMap;
  }
}