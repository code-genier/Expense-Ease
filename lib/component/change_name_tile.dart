import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChangeNameTile extends StatefulWidget {
  final String title;
  final String currData;
  void Function(dynamic) changeData;

  ChangeNameTile({
    super.key,
    required this.title,
    required this.currData,
    required this.changeData,
  });

  @override
  State<ChangeNameTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<ChangeNameTile> {
  final TextEditingController _nameController = TextEditingController();
  bool show = false;
  String _textFieldName = "";

  @override
  Widget build(BuildContext context) {
    void changeBtn(){
      HapticFeedback.lightImpact();
      if(mounted){
        setState(() {
          show = !show;
        });
      }
    }

    void onSubmit(String txt){
      _nameController.clear();
      if(txt!=""){
        widget.changeData(txt);
      }
      if(mounted){
        setState(() {
          show = false;
        });
      }
      return;
    }

    void onDone(){
      HapticFeedback.lightImpact();
      onSubmit(_nameController.text);
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
                    ClipRect(
                      child: Text(
                          (show && _textFieldName.isNotEmpty)?_textFieldName.toUpperCase():widget.currData.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 18,
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    TextButton(
                      onPressed: (show)?onDone:changeBtn,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white70),
                        foregroundColor: MaterialStateProperty.all(
                            Colors.black),
                      ),
                      child: Text(
                        (show)?"Done":"Change",
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: (show)?15:0,
          ),
          (show)?TextField(
            cursorColor: Colors.white38,
            maxLines: 1,
            maxLength: 20,
            controller: _nameController,
            onSubmitted: onSubmit,
            onChanged: (value) {
              setState(() {
                _textFieldName = value;
              });
            },
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white70), // Change the color here
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              labelStyle: const TextStyle(
                fontSize: 12,
                color: Colors.white54,
              ),
              labelText: widget.title,
            ),
          ):const SizedBox(),
        ],
      ),
    );
  }
}
