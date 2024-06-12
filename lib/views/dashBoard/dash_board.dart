// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:app/controllers/scheduler_controller/scheduer_bloc.dart';
import 'package:app/controllers/scheduler_controller/scheduer_state.dart';
import 'package:app/controllers/scheduler_controller/scheduler_event.dart';
import 'package:app/controllers/sensor_log_controller/sensor_log_bloc.dart';
import 'package:app/controllers/sensor_log_controller/sensor_log_event.dart';
import 'package:app/models/sensor_log_model.dart';
import 'package:flutter/material.dart';
import 'package:app/views/dashBoard/widget/input_fertilizer.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DashBoard extends StatefulWidget {
  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String gardenName = "";
  String flow1 = "", flow2 = "", flow3 = "", pumpIn = "";
  void setFlow1(String value) {
    flow1 = value;
  }

  void setFlow2(String value) {
    flow2 = value;
  }

  void setFlow3(String value) {
    flow3 = value;
  }

  void setPumpIn(String value) {
    pumpIn = value;
  }

  @override
  void initState(){
    super.initState();
    schedulerBloc.taskPostStateController.stream
        .listen((TaskState taskPostState) {
      Navigator.of(context).pop();// close dialog
      if (taskPostState.task.id != '') {//add task success
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Thành công',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "IndieFlower",
                    fontWeight: FontWeight.bold,
                  )),
              content: Icon(
                Icons.check,
                size: 50,)
            );
          },
        );
      } else {//add task error
        //display dialog error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Lỗi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "IndieFlower",
                    fontWeight: FontWeight.bold,
                  )),
              content: Icon(
                Icons.error,
                size: 50,)
            );
          },
        );
      }
    });
  }
  @override
  void dispose(){
    schedulerBloc.taskPostStateController.close();
    schedulerBloc.taskPostStateController = StreamController<TaskState>();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          children: [
            wheather(),
            SizedBox(height: 10),
            Container(
                margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  children: [
                    Text("Điều khiển thiết bị",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "IndieFlower")),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() => gardenName = "farm1");
                              },
                              style: ButtonStyle(
                                  backgroundColor: gardenName == "farm1"
                                      ? MaterialStateProperty.all(Colors.green)
                                      : MaterialStateProperty.all(
                                          Colors.white)),
                              child: Text("Farm 1",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "IndieFlower",
                                      color: Colors.black))),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() => gardenName = "farm2");
                              },
                              style: ButtonStyle(
                                  backgroundColor: gardenName == "farm2"
                                      ? MaterialStateProperty.all(Colors.green)
                                      : MaterialStateProperty.all(
                                          Colors.white)),
                              child: Text("Farm 2",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "IndieFlower",
                                      color: Colors.black))),
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() => gardenName = "farm3");
                              },
                              style: ButtonStyle(
                                  backgroundColor: gardenName == "farm3"
                                      ? MaterialStateProperty.all(Colors.green)
                                      : MaterialStateProperty.all(
                                          Colors.white)),
                              child: Text("Farm 3",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "IndieFlower",
                                      color: Colors.black))),
                        )
                      ],
                    ),
                    InputFertilizer(
                        callback: setFlow1, title: "Phân 1", unit: "ml"),
                    InputFertilizer(
                        callback: setFlow2, title: "Phân 2", unit: "ml"),
                    InputFertilizer(
                        callback: setFlow3, title: "Phân 3", unit: "ml"),
                    InputFertilizer(
                        callback: setPumpIn, title: "Nước vào", unit: "lit"),
                    Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () {
                            DateTime now = DateTime.now();
                            schedulerBloc.eventController.add(TaskPostEvent(
                                schedulerName: "oneshot",
                                gardenName: gardenName,
                                startTime:
                                    '${now.hour * 60 + now.minute}',
                                stopTime:
                                    '${23*60 + 59}',
                                flow1: flow1,
                                flow2: flow2,
                                flow3: flow3,
                                pumpIn: pumpIn));
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Đợi phản hồi',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "IndieFlower",
                                        fontWeight: FontWeight.bold,
                                      )),
                                  content:
                                      LoadingAnimationWidget.threeRotatingDots(
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                );
                              },
                            );
                          },
                          child: Text("Điều khiển",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "IndieFlower",
                                  color: Colors.black))),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class wheather extends StatefulWidget {
  const wheather({
    super.key,
  });

  @override
  State<wheather> createState() => _wheatherState();
}

class _wheatherState extends State<wheather> {
  Timer? _timer;
  String humiAir = "0", temp = "0";
  @override
  void initState() {
    super.initState();
    sensorLogBloc.eventController.sink.add(SensorLogLatestEvent());
    //add event listen for state
    sensorLogBloc.sensorLogLatestStateController.stream.listen((event) {
      List<SensorLogModel> sensorLogs = event;
      final String humiAir = sensorLogs[0].value;
      final String temp = sensorLogs[1].value;
      setState(() {
        this.humiAir = humiAir;
        this.temp = temp;
      });
    });
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      //add event to get sensorLog latest
      sensorLogBloc.eventController.sink.add(SensorLogLatestEvent());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    sensorLogBloc.sensorLogLatestStateController.close();
    sensorLogBloc.sensorLogLatestStateController =
        StreamController<List<SensorLogModel>>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              Icon(Icons.wb_sunny, size: 50.0, color: Colors.yellow[900]),
              Text("$temp℃",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "IndieFlower"))
            ],
          )),
          Expanded(
              child: Column(
            children: [
              Icon(Icons.cloud, size: 50.0, color: Colors.blueAccent),
              Text("$humiAir%",
                  style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "IndieFlower"))
            ],
          )),
        ],
      ),
    );
  }
}
