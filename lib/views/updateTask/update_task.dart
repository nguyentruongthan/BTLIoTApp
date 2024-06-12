// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:app/controllers/scheduler_controller/scheduer_bloc.dart';
import 'package:app/controllers/scheduler_controller/scheduer_state.dart';
import 'package:app/controllers/scheduler_controller/scheduler_event.dart';
import 'package:app/models/task_model.dart';
import 'package:app/views/updateTask/widget/input_fertilizer.dart';
import 'package:app/views/updateTask/widget/input_task_name.dart';
import 'package:app/views/updateTask/widget/time_widget.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UpdateTask extends StatefulWidget {
  final TaskModel task;
  UpdateTask({
    required this.task,
  });

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  String schedulerName = "";
  String gardenName = "";
  String startTime = "0:0";
  String stopTime = "0:0";
  String flow1 = "";
  String flow2 = "";
  String flow3 = "";
  String pumpIn = "";
  String isActive = "";
  void setSchedulerName(String value) {
    schedulerName = value;
  }

  void setGardenName(String value) {
    gardenName = value;
  }

  void setStartTime(String value) {
    startTime = value;
  }

  void setStopTime(String value) {
    stopTime = value;
  }

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

  void setIsActive(String value){
    isActive = value;
  }

  @override
  void initState() {
    super.initState();
    setSchedulerName(widget.task.schedulerName);
    setGardenName(widget.task.gardenName);
    setStartTime(
        '${int.parse(widget.task.startTime) ~/ 60}:${int.parse(widget.task.startTime) % 60}');
    setStopTime(
        '${int.parse(widget.task.stopTime) ~/ 60}:${int.parse(widget.task.stopTime) % 60}');
    setFlow1(widget.task.flow1);
    setFlow2(widget.task.flow2);
    setFlow3(widget.task.flow3);
    setPumpIn(widget.task.pumpIn);
    setIsActive(widget.task.isActive);
    schedulerBloc.taskUpdateStateController.stream
        .listen((TaskState taskState) {
      Navigator.of(context).pop(); // close dialog
      if (taskState.task.id != '') {
        //add task success
        Navigator.pop(context); // go to homepage
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
                  size: 50,
                  color: Colors.green,
                ));
          },
        );
      } else {
        //add task error
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
                  Icons.cancel,
                  size: 50,
                  color: Colors.red,
                ));
          },
        );
      }
    });
  }

  @override
  void dispose() {
    schedulerBloc.taskUpdateStateController.close();
    schedulerBloc.taskUpdateStateController = StreamController<TaskState>();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    
    return UpdateTaskWidget(context);
    
  }

  

  Scaffold UpdateTaskWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Sửa lịch: $schedulerName")),
      body: form(context),
    );
  }

  SingleChildScrollView form(BuildContext context) {
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              InputSchedulerName(callback: setSchedulerName, defaultValue: schedulerName),
              SizedBox(
                height: 10,
              ),
              InputFarmName(callback: setGardenName, defaultValue: gardenName),
              SizedBox(
                height: 10,
              ),
              timeWidget("Start Time", setStartTime, startTime),
              SizedBox(
                height: 10,
              ),
              timeWidget("Stop Time", setStopTime, stopTime),
              SizedBox(
                height: 10,
              ),
              InputFertilizer(
                title: "Hàm lượng phân 1",
                unit: "ml",
                callback: setFlow1,
                defaultValue: flow1,
              ),
              SizedBox(
                height: 10,
              ),
              InputFertilizer(
                  title: "Hàm lượng phân 2",
                  unit: "ml",
                  callback: setFlow2,
                  defaultValue: flow2),
              SizedBox(
                height: 10,
              ),
              InputFertilizer(
                  title: "Hàm lượng phân 3",
                  unit: "ml",
                  callback: setFlow3,
                  defaultValue: flow3),
              SizedBox(
                height: 10,
              ),
              InputFertilizer(
                  title: "Lượng nước vào",
                  unit: "l",
                  callback: setPumpIn,
                  defaultValue: pumpIn),
              SizedBox(
                height: 10,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300],
                    ),
                    child: TextButton(
                        onPressed: () {
                          schedulerBloc.taskPostStateController.close();
                          Navigator.pop(context);
                        },
                        child: Text("Hủy",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "IndieFlower",
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[300],
                    ),
                    child: TextButton(
                        onPressed: () {
                          schedulerBloc.eventController.add(TaskUpdateEvent(
                              id: widget.task.id,
                              schedulerName: schedulerName,
                              gardenName: gardenName,
                              startTime:
                                  '${int.parse(startTime.split(':')[0]) * 60 + int.parse(startTime.split(':')[1])}',
                              stopTime:
                                  '${int.parse(stopTime.split(':')[0]) * 60 + int.parse(stopTime.split(':')[1])}',
                              flow1: flow1,
                              flow2: flow2,
                              flow3: flow3,
                              pumpIn: pumpIn,
                              isActive: isActive
                              ));
                          showWaitingDialog(context);
                        },
                        child: Text("Hoàn tất",
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: "IndieFlower",
                              fontWeight: FontWeight.bold,
                            ))),
                  ),
                ),
              ]),
            ],
          ),
        ));
  }

  Future<dynamic> showWaitingDialog(BuildContext context) {
    return showDialog(
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
  }
}
