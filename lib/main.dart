// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'package:app/views/addTask/add_task.dart';
import 'package:app/views/dashBoard/dash_board.dart';
import 'package:app/views/history/history.dart';
import 'package:app/views/homePage/home_page.dart';
import 'package:app/views/login/login_page.dart';
import 'package:flutter/material.dart';


void main() => runApp(MaterialApp(
      home: LoginPage(),
    ));

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  int _selectedIndex = 1;
  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    DashBoard(),
    History(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true, 
          title: 
            _selectedIndex == 0 ? const Text('Lịch tưới'):
            _selectedIndex == 1 ? const Text("Trang chủ"):
            _selectedIndex == 2 ? const Text("Lịch sử") : null),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule_outlined),
              label: 'Lịch tưới',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dash Board',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_outlined),
              label: 'Lịch sử',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        floatingActionButton: _selectedIndex == 0 ? FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTask()),
            );
            
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ) : null );
  }
}
