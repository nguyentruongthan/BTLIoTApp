class TaskLogModel {
  String taskID;
  String flow1;
  String flow2;
  String flow3;
  String pumpIn;
  String pumpOut;
  String status;
  TaskLogModel(
      {required this.taskID,
      required this.flow1,
      required this.flow2,
      required this.flow3,
      required this.pumpIn,
      required this.pumpOut,
      required this.status});
}
