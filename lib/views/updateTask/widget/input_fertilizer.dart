// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class InputFertilizer extends StatefulWidget {
  final String title;
  final String unit;
  final Function(String) callback;
  final String defaultValue;
  InputFertilizer({
    required this.title,
    required this.unit,
    required this.callback,
    required this.defaultValue,
  });
  @override
  State<InputFertilizer> createState() => _InputFertilizerState();
}

class _InputFertilizerState extends State<InputFertilizer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(
              widget.title,
              style: TextStyle(
                fontFamily: "IndieFlower",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
            Expanded(
                child: TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  label: Text('Đơn vị (${widget.unit})',
                      style: TextStyle(
                        fontFamily: "IndieFlower",
                      ))),
              controller: TextEditingController(text: widget.defaultValue),
              onChanged: (value) {
                widget.callback(value);
              },
            )),
          ],
        ));
  }
}

class InputFarmName extends StatefulWidget {
  final Function(String) callback;
  final String defaultValue;
  InputFarmName({required this.defaultValue, required this.callback});
  @override
  State<InputFarmName> createState() => _InputFarmNameState();
}

class _InputFarmNameState extends State<InputFarmName> {
  String farmName = "farm3";
  @override
  void initState() {
    super.initState();
    if(widget.defaultValue != ""){
      farmName = widget.defaultValue;
    }
  }

  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      widget.callback(selectedValue);
      setState(() {
        farmName = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(
              "Tên khu vườn",
              style: TextStyle(
                fontFamily: "IndieFlower",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
            Expanded(
                child: DropdownButton(
              underline: Container(height: 2, color: Colors.transparent),
              value: farmName,
              items: const [
                DropdownMenuItem(
                  value: "farm1",
                  child: Text('Farm 1'),
                ),
                DropdownMenuItem(
                  value: "farm2",
                  child: Text('Farm 2'),
                ),
                DropdownMenuItem(
                  value: "farm3",
                  child: Text('Farm 3'),
                )
              ],
              onChanged: dropdownCallback,
            )),
          ],
        ));
  }
}
