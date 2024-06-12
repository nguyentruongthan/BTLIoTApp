import 'dart:async';

import 'package:app/controllers/task_log_controller/task_log_event.dart';
import 'package:app/controllers/task_log_controller/task_log_state.dart';
import 'package:app/models/task_log_model.dart';
import 'package:app/services/task_log_service.dart';

class TaskLogBloc {
  var eventController = StreamController<TaskLogEvent>();

  var taskLogStateController = StreamController<TaskLogState>.broadcast();

  TaskLogBloc() {
    eventController.stream.listen((event) async {
      if (event is TaskLogGetEvent) {
        //call service get taskLog
        TaskLogModel taskLog = await getTaskLog(event.taskID);
        //add taskLog to taskLogStateController
        taskLogStateController.sink.add(TaskLogState(taskLog: taskLog));
      }
    });
  }
}

final taskLogBloc = TaskLogBloc();
