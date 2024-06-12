// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:app/controllers/scheduler_controller/scheduer_state.dart';
import 'package:app/controllers/scheduler_controller/scheduler_event.dart';
import 'package:app/controllers/task_log_controller/task_log_bloc.dart';
import 'package:app/controllers/task_log_controller/task_log_state.dart';
import 'package:app/controllers/timer_controller/timer_bloc.dart';
import 'package:app/controllers/timer_controller/timer_state.dart';
import 'package:app/models/task_model.dart';
import 'package:app/views/homePage/widget/static_task_widget.dart';
import 'package:flutter/material.dart';
import 'package:app/controllers/scheduler_controller/scheduer_bloc.dart';

List<TaskModel> sortTasksByStartTime(List<TaskModel> scheduler) {
  scheduler.sort((a, b) {
    int startComparison = int.parse(a.startTime).compareTo(int.parse(b.startTime));
    if (startComparison != 0) {
      return startComparison;
    } else {
      return int.parse(a.stopTime).compareTo(int.parse(b.stopTime));
    }
  });
  return scheduler;
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TaskModel> scheduler = [];

  @override
  void initState() {
    super.initState();
    schedulerBloc.eventController.add(TaskGetAllEvent());
  }

  @override
  void dispose() {
    super.dispose();
    schedulerBloc.schedulerStateController.close();
    schedulerBloc.schedulerStateController = StreamController<SchedulerState>();
    taskLogBloc.taskLogStateController.close();
    taskLogBloc.taskLogStateController = StreamController<TaskLogState>.broadcast();
    timerBloc.timerCheckTaskStateController.close();
    timerBloc.timerCheckTaskStateController = StreamController<CurrentMinuteState>.broadcast();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SchedulerState>(
        stream: schedulerBloc.schedulerStateController.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return AlertDialog(
                title: const Text('Waiting',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "IndieFlower",
                      fontWeight: FontWeight.bold,
                    )),
                content: LinearProgressIndicator());
          } else {
            scheduler = snapshot.data!.scheduler;
            scheduler = sortTasksByStartTime(scheduler);
            return Container(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                  child: Column(
                      children: scheduler.map((task) {
                return StaticTaskWidget(key: Key(task.id), task: task);
              }).toList())),
            );
          }
        });
  }
}
