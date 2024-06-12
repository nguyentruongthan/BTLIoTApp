import 'dart:async';

import 'package:app/controllers/scheduler_controller/scheduer_state.dart';
import 'package:app/controllers/scheduler_controller/scheduler_event.dart';
import 'package:app/models/task_model.dart';

import 'package:app/services/scheduler_service.dart';


class SchedulerBloc {
  var eventController = StreamController<TaskEvent>();

  var schedulerStateController = StreamController<SchedulerState>();
  var taskPostStateController = StreamController<TaskState>();
  var taskGetStateController = StreamController<TaskState>();
  var taskUpdateStateController = StreamController<TaskState>();
  var taskUpdateIsActiveController = StreamController<TaskState>.broadcast();
  var taskDeleteController = StreamController<TaskDeleteState>();
  SchedulerState schedulerState = SchedulerState([]);

  SchedulerBloc() {
    // listen eventController
    eventController.stream.listen((event) async {
      if (event is TaskGetAllEvent) {
        // call api get scheduler
        if (schedulerState.scheduler.isEmpty) {
          var scheduler = await getScheduler();
          schedulerState.scheduler = scheduler;
        }
        schedulerStateController.sink.add(schedulerState);
      }
      if (event is TaskPostEvent) {
        // call api post scheduler
        var task = await postScheduler(event);

        // add state post to taskPostStateController
        taskPostStateController.sink.add(TaskState(task));
        if (task.id == '') {
          print('error');
          return;
        }
        // add new task to global scheduler
        schedulerState.scheduler.add(task);
        // add new scheduler to schedulerRecvStateController
        schedulerStateController.sink.add(schedulerState);
      }
      if (event is TaskGetEvent) {
        // find task from global scheduler
        List<TaskModel> scheduler = schedulerState.scheduler;
        TaskModel task =
            scheduler.firstWhere((element) => element.id == event.id);
        // add task to taskGetStateController
        taskGetStateController.sink.add(TaskState(task));
      }
      if (event is TaskUpdateEvent) {
        //call api update scheduler
        final task = await updateScheduler(event);

        // add state update to taskUpdateStateController
        taskUpdateStateController.sink.add(TaskState(task));
        if (task.id == '') {
          return;
        }
        // update task to global scheduler
        int index = 0;
        for (index; index < schedulerState.scheduler.length; index++) {
          if (schedulerState.scheduler[index].id == task.id) {
            break;
          }
        }
        schedulerState.scheduler[index] = task;
        // update scheduler to schedulerRecvStateController
        schedulerStateController.sink.add(schedulerState);
      }
      if (event is TaskUpdateIsActiveEvent) {
        //get task by ID
        TaskModel task = schedulerState.scheduler
            .firstWhere((element) => element.id == event.id);

        //update isActive
        // call service updateIsActiveTask
        final updatedIsActiveTask =
            await updateIsActiveTask(task, event.isActive);

        if (updatedIsActiveTask.id == '') {
          return;
        }
        //add state update to taskUpdateStateController
        taskUpdateIsActiveController.sink.add(TaskState(updatedIsActiveTask));
      }
      if (event is TaskDeleteEvent) {
        //call api delete task
        int result = await deleteTask(event.id);
        taskDeleteController.sink.add(TaskDeleteState(result));
        if(result == 200){
          // remove task from schedule
          schedulerState.scheduler.removeWhere((element) => element.id == event.id);
          // update new schedule
          schedulerStateController.sink.add(schedulerState);
        }
      }
    });
  }
}

final schedulerBloc = SchedulerBloc();
