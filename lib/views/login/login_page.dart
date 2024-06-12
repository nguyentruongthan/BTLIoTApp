// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:app/controllers/login_controller/logic_bloc.dart';
import 'package:app/controllers/login_controller/login_event.dart';
import 'package:app/controllers/login_controller/login_state.dart';
import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

bool isValidIPv4(String ip) {
  // Regular expression for validating an IPv4 address
  final RegExp ipv4RegExp = RegExp(
      r'^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
          r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
          r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.' +
          r'(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$');

  return ipv4RegExp.hasMatch(ip);
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String ipAddress = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.all(20),
      color: Colors.grey[100],
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text(
          "Địa chỉ IP của server",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: "IndieFlower",
          ),
        ),
        SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: "Nhập địa chỉ IP",
          ),
          onChanged: (value) => ipAddress = value,
        ),
        SizedBox(height: 5),
        TextButton(
            onPressed: () {
              if (!isValidIPv4(ipAddress)) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            title: Text(
                          "Địa chỉ IP không hợp lệ",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "IndieFlower",
                          ),
                        )));
                return;
              }
              //add event login to stream
              loginBloc.eventController.add(LoginEvent(ipAddress: ipAddress));
              //show waiting dialog
              showWaitingDialog(context);
              
            },
            child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                ),
                alignment: Alignment.center,
                child: Text("Xác nhận", style: TextStyle(color: Colors.white))))
      ]),
    ));
  }

  Future<dynamic> showWaitingDialog(BuildContext context) {
    return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                loginBloc.loginStateController.stream.listen((LoginState loginState) { 
                  //remove alert waiting
                  Navigator.of(context).pop();
                  if(loginState.isSuccess){
                    //navigate to layout page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Layout()),
                    );
                  }else{
                    //show alert result
                    showFailureDialog(context);
                  }
                  //close stream
                  loginBloc.loginStateController.close();
                  loginBloc.loginStateController =
                      StreamController<LoginState>();
                });
                return AlertDialog(
                  title: const Text('Đợi phản hồi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "IndieFlower",
                        fontWeight: FontWeight.bold,
                      )),
                  content: LoadingAnimationWidget.threeRotatingDots(
                    color: Colors.white,
                    size: 50,
                  ),
                );
              });
  }

  Future<dynamic> showFailureDialog(BuildContext context) {
    return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Địa chỉ IP không hợp lệ' ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: "IndieFlower",
                        fontWeight: FontWeight.bold,
                      )),
                  content: Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 50,
                  ),
                );
              });
  }
}
