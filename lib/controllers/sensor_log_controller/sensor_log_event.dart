class SensorLogEvent {}

class SensorLogGetEvent extends SensorLogEvent {
  final String sensorID;
  final String date;
  SensorLogGetEvent({
    required this.sensorID,
    required this.date});
}

class SensorLogLatestEvent extends SensorLogEvent {}