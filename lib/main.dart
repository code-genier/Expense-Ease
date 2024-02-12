
import 'package:expense_ease/Scenes/add_item_page.dart';
import 'package:expense_ease/Scenes/setting_page.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:expense_ease/Scenes/home_page.dart';
import 'package:expense_ease/db/expense_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox("myBox");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _myBox = Hive.box("myBox");
  bool loading = true;
  List<String> category = [];
  final SmsQuery _query = SmsQuery();
  ExpenseDB db = ExpenseDB();


  Map<String, List<String>> _paymentMessage = {}; // id, sms fields


  void _readMessages() async {
    var permission = await Permission.sms.status;

    if(permission.isGranted) {
      List<SmsMessage> messages = await _query.getAllSms;
      Map<String, List<String>> paymentMessage = {}; // id, sms fields

      debugPrint("inbox message ${messages.length}");

      for(int i = 0; i < messages.length; i++){
        String sender = messages[i].sender.toString().toLowerCase();
        String body = messages[i].body.toString().toLowerCase();
        DateTime date = messages[i].date!;
        String dateSt = date.toString();
        String id = "";

        if(sender.contains("otp") || body.contains("otp")){
          continue;
        }
        if(body.contains('credited')
            || body.contains('credit')
            || body.contains('debited')
            || body.contains('debit')
        ){
            if(body.contains('credited')
                || body.contains('credit')
                || body.contains('salary')
            ) {
              id = generateId(date, sender, "credited");
            }
            else{
              id = generateId(date, sender, "debited");
            }
            double amount = extractAmount(messages[i]);
            String category = "";
            List<String> entries = [dateSt,sender,body,amount.toString(),category];
            if(db.lastScan == null){
              paymentMessage[id] = entries;
            }
            else{
              if(date.isAfter(db.lastScan!)){
                paymentMessage[id] = entries;
              }
              else{
                break;
              }
            }
        }
      }

      if(mounted){
        setState(() {
          _paymentMessage = paymentMessage;
          _filterExpenseToCategory();
        });
      }
    }
    else{
      await Permission.sms.request();
      permission = await Permission.sms.status;
    }
  }

  void _filterExpenseToCategory(){
    Map<String, List<String>> paymentMessage = _paymentMessage; // id, sms fields

    for(var item in paymentMessage.entries){
      String body = item.value[2];
      String currKey = "misc"; // default

      db.category.forEach((key, value) {
        bool found = false;
        for(int j = 0; j < value.length; j++){
          if(body.contains(value[j])){
            currKey = key;
            found = true;
            break;
          }
          if(found) break;
        }
      });

      item.value[4] = currKey;
    }

    if(mounted){
      setState(() {
        if(db.lastScan != null){
          Map<String, List<String>> combined = {...db.paymentMessage, ...paymentMessage};
          db.paymentMessage = combined;
        }
        else{
          db.paymentMessage = paymentMessage;
        }
        _paymentMessage = paymentMessage;
        db.lastScan = DateTime.now();
        db.updateData();
        _getMonthlyExpenseMessages();
      });
    }
  }

  void _getMonthlyExpenseMessages(){
    Map<String, List<String>> monthlyPaymentMessage = {}; // month, list of sms id

    for(var item in db.paymentMessage.entries){
      DateTime date = DateTime.parse(item.value[0]);
      String month = date.month.toString();
      String year = date.year.toString();

      String dateId = "$month-$year";
      String smsId = item.key;

      // split month wise expense and sort expense according to date
      if(monthlyPaymentMessage[dateId] == null){
        monthlyPaymentMessage[dateId] = [smsId];
      }
      else{
        List<String> temp = monthlyPaymentMessage[dateId]??[];
        temp.add(smsId);
        temp.sort((x, y){
          DateTime? a = DateTime.parse(db.paymentMessage[x]![0]);
          DateTime? b = DateTime.parse(db.paymentMessage[y]![0]);

          return b.compareTo(a);
        });
        monthlyPaymentMessage[dateId] = temp;
      }
    }
    if(mounted){
      setState(() {
        db.monthlyPaymentMessage = monthlyPaymentMessage;
        db.updateData();
        _getMonthlyCategoryAmount();
      });
    }

  }

  void _getMonthlyCategoryAmount(){
    Map<String, Map<String, String>> monthlyCategoryAmount = {}; // month, list of category, total amount
    Map<String, List<String>> monthlyExpenseIncome = {}; // month, {total expense, income}


    for(var item in db.monthlyPaymentMessage.entries){
      String dateId = item.key;
      double income = 0;
      double expense = 0;
      Map<String, String> temp = {};
      List<String> amtList = []; // expense, income --> monthly
      for(int i = 0; i < item.value.length; i++){
        String category = db.paymentMessage[item.value[i]]![4];
        double amount = double.parse(db.paymentMessage[item.value[i]]![3]);
        if(category == "income"){
          income += amount;
        }
        else{
          expense +=  amount;
        }

        if(temp[category] == null){
          temp[category] = amount.toString();
        }
        else{
          double x = double.parse(temp[category]!);
          temp[category] = (x + amount).toString();
        }
      }
      amtList = [expense.toString(), income.toString()];
      monthlyExpenseIncome[dateId] = amtList;
      monthlyCategoryAmount[dateId] = temp;
    }

    if(mounted){
      setState(() {
        db.monthlyCategoryAmount = monthlyCategoryAmount;
        db.monthlyExpenseIncome = monthlyExpenseIncome;
        db.updateData();
        _getTotalSavings();
      });
    }
  }

  void _getTotalSavings(){
    // savings
    double savings = 0;

    for(var item in db.paymentMessage.entries){
      DateTime date = DateTime.parse((item.value[0]));
      if(date.isAfter(db.startDate!) || date == db.startDate){
        double amount = double.parse(item.value[3]);
        String category = item.value[4];
        if(category == "income"){
          savings += amount;
        }
        else{
          savings -= amount;
        }
      }
    }


    if(mounted){
      setState(() {
        loading = false;
        db.totalSavings = savings;
        db.updateData();
      });
    }
  }

  String generateId(DateTime date, String sender, String type){
    String id = "";
    id = "${date}_${sender}_$type";
    return id;
  }

  double extractAmount(SmsMessage msg){
    String txt = msg.body.toString().toLowerCase();

    RegExp regex = RegExp(r'(?:inr|rs|credited by|debited by)\s*([\d,]+)');
    Iterable<RegExpMatch> matches = regex.allMatches(txt);
    List<double> extractedValues = matches.map((match) {
      String valueString = match.group(1) ?? '';
      // Remove commas and parse as double
      return double.tryParse(valueString.replaceAll(',', '')) ?? 0;
    }).toList();

    double amount = 0;
    if(extractedValues.isNotEmpty) amount = extractedValues[0];
    return amount;
  }

  void _changeStartDate(DateTime x){
    if(mounted){
      setState(() {
        db.startDate = x;
        db.updateData();
        _getTotalSavings();
      });
    }
  }

  void _addNewTransactions(String smsId, List<String> data){
    DateTime date = DateTime.parse(data[0]);
    String month = date.month.toString();
    String year = date.year.toString();

    String dateId = "$month-$year";
    if(mounted){
      setState(() {
        db.paymentMessage[smsId] = data;
        if(db.monthlyPaymentMessage.containsKey(dateId)){
          db.monthlyPaymentMessage[dateId]!.add(smsId);
        }
        else{
          db.monthlyPaymentMessage[dateId] = [smsId];
        }
        db.updateData();
        _getMonthlyCategoryAmount();
       });
    }
  }

  @override
  void initState() {
    super.initState();
    if(_myBox.get("PAYMENTMESSAGE") == null && _myBox.get("LASTSCAN") == null){
      print("creating new data");
      db.createInitialData();
    }
    else{
      print("loading data");
      db.loadDate();
      print(_myBox.get("PAYMENTMESSAGE")!.length);
    }
    _initApp();
  }
  // Function to initialize the app
  void _initApp() async {
    await _checkAndRequestSmsPermission();
    getCategoryList();
    _readMessages();
  }

  Future<void> _checkAndRequestSmsPermission() async {
    var permission = await Permission.sms.status;

    if (permission.isDenied || permission.isPermanentlyDenied) {
      // Request SMS permission
      await Permission.sms.request();
    }
  }

  void getCategoryList(){
    List<String> categoryLocal = [];

    for(var item in db.category.entries){
      categoryLocal.add(item.key);
    }

    if(mounted){
      setState(() {
        category = categoryLocal;
      });
    }
  }

  void _changeUserName(String data){
    if(mounted){
      setState(() {
        db.userName = data;
        db.updateData();
      });
    }
  }

  void _changeCurrency(String data){
    if(mounted){
      setState(() {
        db.currency = data;
        db.updateData();
      });
    }
  }

  List<Widget> _buildScreens() {
    return [
      HomePage(
        currency: db.currency,
        userName: db.userName,
        startDate: db.startDate??DateTime.now(),
        savings: db.totalSavings.toString(),
        monthlyExpenseIncome: db.monthlyExpenseIncome,
        monthlyCategoryAmount: db.monthlyCategoryAmount,
        paymentMessage: db.paymentMessage,
        monthlyPaymentMessage: db.monthlyPaymentMessage,
        changeStartDate: _changeStartDate,
      ),
      AddItems(
        category: category,
        addNewTransactions: _addNewTransactions,
      ),
      SettingPage(
        userName: db.userName,
        changeName: _changeUserName,
        startDate: db.startDate??DateTime.now(),
        changeStartDate: _changeStartDate,
        currency: db.currency,
        changeCurrency: _changeCurrency,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColorPrimary: Colors.white70,
        inactiveColorPrimary: Colors.white24,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
            Icons.add,
            color: Colors.black,
        ),
        title: ("Add"),
        activeColorPrimary: Colors.grey,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        activeColorPrimary: Colors.white70,
        inactiveColorPrimary: Colors.white24,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller;
    _controller = PersistentTabController(initialIndex: 0);

    return MaterialApp(
      title: 'ExpenseEase',
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Set the overall brightness to dark
        primaryColor: Colors.black, // Set the primary color to black
        hintColor: Colors.white, // Set the accent color to white
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
        )
      ),
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: (!loading)?PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: Colors.black, // Default is Colors.white.
          handleAndroidBackButtonPress: true, // Default is true.
          resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true, // Default is true.
          hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
          decoration: NavBarDecoration(
            borderRadius: BorderRadius.circular(0),
            colorBehindNavBar: Colors.black,
          ),
          popAllScreensOnTapOfSelectedTab: true,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
          onItemSelected: (x){
            HapticFeedback.lightImpact();
          },
        ):const Text("loading"),
    );
  }
}
