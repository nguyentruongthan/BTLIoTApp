class TaskLogEvent{}

class TaskLogGetEvent extends TaskLogEvent {
  final String taskID;
  TaskLogGetEvent({required this.taskID});
}