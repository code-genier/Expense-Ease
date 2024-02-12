import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class ChangeCurrencyTile extends StatefulWidget {
  final String title;
  final String currData;
  void Function(dynamic) changeData;

  ChangeCurrencyTile({
    super.key,
    required this.title,
    required this.currData,
    required this.changeData,
  });

  @override
  State<ChangeCurrencyTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<ChangeCurrencyTile> {
  bool show = false;
  String? selectedCurrency;

  Map<String, String> currencies = {
    '\$': 'United States (USD)',
    '€': 'European Union (EUR)',
    '¥': 'Japan (JPY)',
    '£': 'United Kingdom (GBP)',
    '₹': 'India (INR)',
    '₽': 'Russia (RUB)',
    '₩': 'South Korea (KRW)',
    '฿': 'Thailand (THB)',
    '₪': 'Israel (ILS)',
    '₱': 'Philippines (PHP)',
    '₨': 'Nepal (NPR)',
    '₮': 'Mongolia (MNT)',
    '₴': 'Ukraine (UAH)',
    '₲': 'Paraguay (PYG)',
    '₫': 'Vietnam (VND)',
    '₵': 'Ghana (GHS)',
    '₦': 'Nigeria (NGN)',
    '₼': 'Azerbaijan (AZN)',
    '₾': 'Georgia (GEL)',
    '֏': 'Armenia (AMD)',
  };

  List<String> currencySymbols = [
    '\$', '€', '¥', '£', '₹', '₽', '₩', '฿', '₪', '₱', '₨', '₮', '₴', '₲', '₫', '₵', '₦', '₼', '₾', '֏',
  ];

  void changeBtn(){
    HapticFeedback.lightImpact();
    if(mounted){
      setState(() {
        show = !show;
      });
    }
  }

  void onSubmit(String? value){
    if(mounted){
      setState(() {
        selectedCurrency = value;
        widget.changeData(value);
        show = false;
      });
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    String currValue = "${currencies[widget.currData]!.toUpperCase()} ${widget.currData.toUpperCase()}";
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
                        "${currencies[widget.currData]!.toUpperCase()} ${widget.currData.toUpperCase()}",
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 18,
                        )
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              HapticFeedback.lightImpact();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(25),
                      // color: (data.entries.first.value < 0) ? Colors.red.shade800 : Colors.green.shade800,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        isExpanded: true,
                        hint: const Text(
                          'Select currency',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        items: currencySymbols
                            .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            "${currencies[item]!.toUpperCase()} ${item.toUpperCase()}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            ),
                          ),
                        ))
                            .toList(),
                        value: selectedCurrency,
                        onChanged: (String? value) {
                          HapticFeedback.lightImpact();
                          onSubmit(value);
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
