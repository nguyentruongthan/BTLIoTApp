class TaskModel {
  String id;
  String flow1;
  String flow2;
  String flow3;
  String isActive;
  String schedulerName;
  String startTime;
  String stopTime;
  String gardenName;
  String pumpIn;
  TaskModel(
      {required this.id,
      required this.flow1,
      required this.flow2,
      required this.flow3,
      required this.isActive,
      required this.schedulerName,
      required this.startTime,
      required this.stopTime,
      required this.gardenName,
      required this.pumpIn});
}
