class TaskEvent {}

class TaskGetAllEvent extends TaskEvent {}

class TaskPostEvent extends TaskEvent {
  final String flow1;
  final String flow2;
  final String flow3;
  final String pumpIn;
  final String schedulerName;
  final String startTime;
  final String stopTime;
  final String gardenName;
  TaskPostEvent(
      {required this.flow1,
      required this.flow2,
      required this.flow3,
      required this.schedulerName,
      required this.startTime,
      required this.stopTime,
      required this.pumpIn,
      required this.gardenName});
}

class TaskUpdateEvent extends TaskEvent {
  final String id;
  final String flow1;
  final String flow2;
  final String flow3;
  final String pumpIn;
  final String schedulerName;
  final String startTime;
  final String stopTime;
  final String gardenName;
  final String isActive;
  TaskUpdateEvent(
      {required this.id,
      required this.flow1,
      required this.flow2,
      required this.flow3,
      required this.schedulerName,
      required this.startTime,
      required this.stopTime,
      required this.pumpIn,
      required this.gardenName,
      required this.isActive});
}

class TaskGetEvent extends TaskEvent {
  final String id;
  TaskGetEvent({required this.id});
}

class TaskUpdateIsActiveEvent extends TaskEvent{
  final String id;
  final String isActive;
  TaskUpdateIsActiveEvent({required this.id, required this.isActive});
}

class TaskDeleteEvent extends TaskEvent {
  final String id;
  TaskDeleteEvent({required this.id});
}
