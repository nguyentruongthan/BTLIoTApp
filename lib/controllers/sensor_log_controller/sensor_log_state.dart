import 'package:app/models/sensor_log_model.dart';

class SensorLogState {
  final SensorLogModel sensorLogModel;
  SensorLogState({required this.sensorLogModel});
}
class SensorLogsDateState{
  final List<SensorLogModel> sensorLogs;
  SensorLogsDateState({required this.sensorLogs});
}