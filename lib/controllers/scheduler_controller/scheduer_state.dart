import 'package:app/models/task_model.dart';

class SchedulerState {
  SchedulerState(this.scheduler);
  List<TaskModel> scheduler;
}

class TaskState {
  TaskState(this.task);
  final TaskModel task;
}
class TaskDeleteState{
  int statusCode;
  TaskDeleteState(this.statusCode);
}