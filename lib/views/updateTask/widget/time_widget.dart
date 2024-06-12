// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

Container timeWidget(
    String title, Function(String) callback, String defaultValue) {
  return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: "IndieFlower",
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SetTimeWidget(
            callback: callback,
            defaultValue: defaultValue,
          ),
        ],
      ));
}

class SetTimeWidget extends StatefulWidget {
  final Function(String) callback;
  final String defaultValue;
  SetTimeWidget({required this.callback, required this.defaultValue});
  @override
  State<SetTimeWidget> createState() => _timeWidgetState();
}

class _timeWidgetState extends State<SetTimeWidget> {
  int hour = 0;
  int minute = 0;

  @override
  void initState() {
    print("initState");
    if (widget.defaultValue == "0:0") {
      hour = 0;
      minute = 0;
    } else {
      hour = int.parse(widget.defaultValue.split(':')[0]);
      minute = int.parse(widget.defaultValue.split(':')[1]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: NumberPicker(
            itemWidth: 80,
            itemHeight: 40,
            value: hour,
            minValue: 0,
            maxValue: 23,
            zeroPad: true,
            infiniteLoop: true,
            onChanged: (value) {
              widget.callback("$value:$minute");
              setState(() => hour = value);
            },
            selectedTextStyle: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                      color: Colors.black,
                    ),
                    bottom: BorderSide(
                      color: Colors.black,
                    ))),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: NumberPicker(
            itemWidth: 80,
            itemHeight: 40,
            value: minute,
            minValue: 0,
            maxValue: 59,
            zeroPad: true,
            infiniteLoop: true,
            onChanged: (value) {
              widget.callback("$hour:$value");
              setState(() => minute = value);
            },
            selectedTextStyle: TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                      color: Colors.black,
                    ),
                    bottom: BorderSide(
                      color: Colors.black,
                    ))),
          ),
        )
      ],
    );
  }
}
