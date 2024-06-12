
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class InputSchedulerName extends StatefulWidget {
  final Function(String) callback;
  InputSchedulerName({
    required this.callback,
  });
  @override
  State<InputSchedulerName> createState() => _InputSchedulerNameState();
}

class _InputSchedulerNameState extends State<InputSchedulerName> {
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
                "Tên lịch tưới",
              
              style: TextStyle(
                fontFamily: "IndieFlower",
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            )),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (value){
                  widget.callback(value);
                },
            )),
          ],
        ));
  }
}

