// ignore_for_file: must_be_immutable, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:app/controllers/scheduler_controller/scheduer_bloc.dart';
import 'package:app/controllers/scheduler_controller/scheduer_state.dart';
import 'package:app/controllers/scheduler_controller/scheduler_event.dart';
import 'package:app/controllers/task_log_controller/task_log_bloc.dart';
import 'package:app/controllers/task_log_controller/task_log_event.dart';
import 'package:app/controllers/task_log_controller/task_log_state.dart';
import 'package:app/controllers/timer_controller/timer_bloc.dart';
import 'package:app/controllers/timer_controller/timer_state.dart';
import 'package:app/models/task_log_model.dart';
import 'package:app/models/task_model.dart';
import 'package:app/views/updateTask/update_task.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class StaticTaskWidget extends StatefulWidget {
  final TaskModel task;
  StaticTaskWidget({
    required Key key,
    required this.task,
  }) : super(key: key);

  @override
  State<StaticTaskWidget> createState() => _StaticTaskWidgetState();
}

class _StaticTaskWidgetState extends State<StaticTaskWidget> {
  bool showDetailInfor = false;
  TaskLogModel taskLog = TaskLogModel(
    taskID: '',
    flow1: '0',
    flow2: '0',
    flow3: '0',
    pumpIn: '0',
    pumpOut: '0',
    status: '0',
  );
  @override
  void initState() {
    super.initState();
    schedulerBloc.taskUpdateIsActiveController.stream
        .listen((TaskState taskState) {
      final task = taskState.task;
      if (task.id == '') {
        return;
      } else if (task.id == widget.task.id) {
        Navigator.of(context).pop(); // close dialog
        if (mounted) {
          setState(() {
            widget.task.isActive = task.isActive;
          });
        }
      }
    });
    timerBloc.timerCheckTaskStateController.stream
        .listen((CurrentMinuteState currentMinuteState) {
      final startTimer = int.parse(widget.task.startTime);
      final stopTimer = int.parse(widget.task.stopTime);
      if (currentMinuteState.currentMinute >= startTimer &&
          currentMinuteState.currentMinute <= stopTimer) {
        if (widget.task.isActive == "0") {
          return;
        }
        // add event get task log
        taskLogBloc.eventController
            .add(TaskLogGetEvent(taskID: widget.task.id));
        if (mounted) {
          setState(() {
            showDetailInfor = true;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            showDetailInfor = false;
          });
        }
      }
    });
    taskLogBloc.taskLogStateController.stream
        .listen((TaskLogState taskLogState) {
      if (taskLogState.taskLog.taskID == widget.task.id) {
        // print(taskLog.flow1);
        if(mounted){
          setState(() {
            if (taskLogState.taskLog.status == "1") {}
            taskLog = taskLogState.taskLog;
          });
        }
        
      }
    });
  }

  @override
  void dispose() {
    // schedulerBloc.taskUpdateIsActiveController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UpdateTask(task: widget.task)),
          );
        },
        onLongPress: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                    'Bạn chắc chắn muốn xóa \n${widget.task.schedulerName}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "IndieFlower",
                      fontWeight: FontWeight.bold,
                    )),
                actions: [
                  TextButton(
                    child: Text("Xác nhận"),
                    onPressed: () {
                      //call api delete task
                      Navigator.of(context).pop();
                      schedulerBloc.eventController
                          .add(TaskDeleteEvent(id: widget.task.id));
                      //show wating dialog
                      showWaitingDialog(context);
                    },
                  ),
                  TextButton(
                    child: Text("Hủy"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        },
        child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: taskLog.status == "1"
                    ? LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.green, Colors.yellow, Colors.amber],
                      )
                    : LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          const Color.fromRGBO(224, 224, 224, 1),
                          const Color.fromRGBO(224, 224, 224, 1)
                        ],
                      )),
            child: Column(children: [
              infor(),
              Visibility(visible: showDetailInfor, child: detailInfor())
            ])));
  }

  Future<dynamic> showWaitingDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          schedulerBloc.taskDeleteController.stream
              .listen((TaskDeleteState taskDeleteState) {
            //remove alert waiting
            Navigator.of(context).pop();
            //show alert result
            showResultDeleteDialog(context, taskDeleteState);
            //close stream
            schedulerBloc.taskDeleteController.close();
            schedulerBloc.taskDeleteController =
                StreamController<TaskDeleteState>();
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

  Future<dynamic> showResultDeleteDialog(
      BuildContext context, TaskDeleteState taskDeleteState) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                taskDeleteState.statusCode == 200
                    ? 'Xóa lịch tưới thành công'
                    : 'Không nhận được phản hồi từ server',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "IndieFlower",
                  fontWeight: FontWeight.bold,
                )),
            content: Icon(
              taskDeleteState.statusCode == 200
                  ? Icons.check_circle_outline
                  : Icons.cancel_outlined,
              color:
                  taskDeleteState.statusCode == 200 ? Colors.green : Colors.red,
              size: 50,
            ),
          );
        });
  }

  Column infor() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 100,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: timeWidget(widget.task.startTime, widget.task.stopTime),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.task.schedulerName,
                      style: TextStyle(
                        fontFamily: "IndieFlower",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Switch(
                        activeColor: Colors.blueGrey.shade600,
                        activeTrackColor: Colors.yellow.shade100,
                        inactiveThumbColor: Colors.blueGrey.shade600,
                        inactiveTrackColor: Colors.grey.shade400,
                        splashRadius: 50.0,
                        // boolean variable value
                        value: widget.task.isActive == "1" ? true : false,
                        // changes the state of the switch
                        onChanged: (value) {
                          //add event update task's isActive
                          schedulerBloc.eventController.add(
                              TaskUpdateIsActiveEvent(
                                  id: widget.task.id,
                                  isActive: widget.task.isActive));
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
                        }),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Column detailInfor() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        processPercent(
            title: 'Phân 1',
            current: taskLog.flow1,
            total: widget.task.flow1,
            unit: 'ml',
            status: taskLog.status),
        SizedBox(
          height: 10,
        ),
        processPercent(
            title: 'Phân 2',
            current: taskLog.flow2,
            total: widget.task.flow2,
            unit: 'ml',
            status: taskLog.status),
        SizedBox(
          height: 10,
        ),
        processPercent(
            title: 'Phân 3',
            current: taskLog.flow3,
            total: widget.task.flow3,
            unit: 'ml',
            status: taskLog.status),
        SizedBox(
          height: 10,
        ),
        processPercent(
            title: 'Nước vào',
            current: taskLog.pumpIn,
            total: widget.task.pumpIn,
            unit: 'lit',
            status: taskLog.status),
        SizedBox(
          height: 10,
        ),
        processPercent(
            title: 'Nước ra',
            current: taskLog.pumpOut,
            total: widget.task.pumpIn,
            unit: 'lit',
            status: taskLog.status),
      ],
    );
  }

  Row timeWidget(String startTime, String stopTime) {
    int durationTime = int.parse(stopTime) - int.parse(startTime);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        textTimeWidget([int.parse(startTime) ~/ 60, int.parse(startTime) % 60]),
        Expanded(
            child: durationTimeWidget(
                "${durationTime ~/ 60}h${durationTime % 60}p")),
        textTimeWidget([int.parse(stopTime) ~/ 60, int.parse(stopTime) % 60]),
      ],
    );
  }

  Column durationTimeWidget(String durationTime) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            margin: EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(),
            )),
            child: Text(durationTime,
                style: TextStyle(
                  fontSize: 10,
                )),
          ),
        ),
        Expanded(
          child: Container(),
        ),
      ],
    );
  }

  Text textTimeWidget(List<int> time) {
    String hour = time[0] < 10 ? '0${time[0]}' : '${time[0]}';
    String minute = time[1] < 10 ? '0${time[1]}' : '${time[1]}';
    return Text("$hour:$minute",
        style: TextStyle(
            color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold));
  }
}

class processPercent extends StatefulWidget {
  final String title;
  final String current;
  final String total;
  final String unit;
  final String status;
  const processPercent({
    required this.title,
    required this.current,
    required this.total,
    required this.unit,
    required this.status,
    super.key,
  });

  @override
  State<processPercent> createState() => _processPercentState();
}

class _processPercentState extends State<processPercent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "IndieFlower"),
        ),
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width * 0.6,
          lineHeight: 20,
          percent: double.parse(widget.current) / double.parse(widget.total),
          barRadius: Radius.circular(10),
          backgroundColor: Colors.white,
          progressColor: Colors.green[200],
          center: Text(
            "${widget.current}/${widget.total} ${widget.unit}",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: "IndieFlower"),
          ),
        ),
      ],
    );
  }
}
