import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:expense_ease/component/change_name_tile.dart';
import 'package:expense_ease/component/change_startdate_tile.dart';
import 'package:expense_ease/component/expense_amount_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddItems extends StatefulWidget {
  final List<String> category;
  void Function(String smsId, List<String> data) addNewTransactions;

  AddItems({
    super.key,
    required this.category,
    required this.addNewTransactions,
  });

  @override
  State<AddItems> createState() => _AddItemsState();
}

class _AddItemsState extends State<AddItems> {
  int labelSelect = 0;
  String? selectedCategory;
  List<String> smsData = List<String>.filled(5, "Change me...");

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
        backgroundColor: Colors.black,

        duration: const Duration(seconds: 2),
      ),
    );
  }

  void changeSender(dynamic data){
    if(mounted){
      setState(() {
        smsData[1] = data;
      });
    }
  }

  void changeData(dynamic data){
    if(mounted){
      setState(() {
        smsData[2] = data;
      });
    }
  }

  void changeDate(dynamic data){
    if(mounted){
      setState(() {
        smsData[0] = data.toString();
      });
    }
  }

  void changeAmount(dynamic data){
    if(mounted){
      setState(() {
        smsData[3] = data;
      });
    }
  }

  void onSubmitCategory(String? value){
    if(mounted){
      setState(() {
        selectedCategory = value;
        smsData[4] = selectedCategory??"misc";
      });
    }
    return;
  }

  void submitHandle(){
    if(smsData[0] == "Change me..."){
      _showSnackbar("Date can't be empty");
      return;
    }
    if(smsData[1] == "Change me..."){
      _showSnackbar("Sender can't be empty");
      return;
    }
    if(smsData[2] == "Change me..."){
      _showSnackbar("Description can't be empty");
      return;
    }
    if(smsData[3] == "Change me..."){
      _showSnackbar("Amount can't be empty");
      return;
    }
    if(smsData[4] == "Change me..."){
      _showSnackbar("Category can't be empty");
      return;
    }
    String smsId = generateId(smsData[0], smsData[1], (labelSelect==0)?"debited":"credited");
    widget.addNewTransactions(smsId, smsData);
    _showSnackbar("Transactions added successfully");
    if(mounted){
      setState(() {
        smsData = List<String>.filled(5, "Change me...");
      });
    }
  }

  void cancelHandle(){
    if(mounted){
      setState(() {
        smsData = List<String>.filled(5, "Change me...");
      });
    }
  }

  String generateId(String date, String sender, String type){
    String id = "";
    id = "${date}_${sender}_$type";
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            "ADD TRANSACTIONS",
          style: TextStyle(
            color: Colors.white38,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: <Widget>[
                      const Text(
                        "Type: ",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 1,),
                      Text(
                        (labelSelect == 0)?"Debited":"Credited",
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ToggleSwitch(
                    minWidth: 100,
                    initialLabelIndex: labelSelect,
                    cornerRadius: 10.0,
                    activeFgColor: Colors.black,
                    inactiveBgColor: Colors.white10,
                    inactiveFgColor: Colors.white38,
                    totalSwitches: 2,
                    labels: const ['Debit', 'Credit'],
                    icons: const [Icons.remove_outlined, Icons.add_outlined],
                    activeBgColors: const [[Colors.white70],[Colors.white70]],
                    onToggle: (index) {
                      setState(() {
                        labelSelect = index??0;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            ChangeNameTile(
                title: "Sender:",
                currData: smsData[1],
                changeData: changeSender,
            ),
            const SizedBox(height: 10,),
            ChangeNameTile(
              title: "Description:",
              currData: smsData[2],
              changeData: changeData,
            ),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Category:",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${(selectedCategory!=null)?(selectedCategory?.toUpperCase()):"Choose category..."}",
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(25),
                      // color: (data.entries.first.value < 0) ? Colors.red.shade800 : Colors.green.shade800,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint: const Text(
                              'Select category',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            items: widget.category
                                .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                ),
                              ),
                            ))
                                .toList(),
                            value: selectedCategory,
                            onChanged: (String? value) {
                              HapticFeedback.lightImpact();
                              onSubmitCategory(value);
                            },
                            buttonStyleData: const ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 40,
                              width: 140,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.black,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.white70,
                              ),
                              offset: const Offset(0, -15),
                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(40),
                                thickness: MaterialStateProperty.all(0),
                                thumbVisibility: MaterialStateProperty.all(true),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10,),
            ChangeStartDateTile(
              title: "Time:",
              currData: smsData[0],
              changeData: changeDate,
            ),
            const SizedBox(height: 10,),
            ExpenseAmountTile(
                title: "Amount:",
                currData: smsData[3],
                changeData: changeAmount
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: cancelHandle,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white70),
                      foregroundColor: MaterialStateProperty.all(
                          Colors.black),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: TextButton(
                    onPressed: submitHandle,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.white70),
                      foregroundColor: MaterialStateProperty.all(
                          Colors.black),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
