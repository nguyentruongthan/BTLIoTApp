import 'dart:async';
import 'package:app/controllers/sensor_log_controller/sensor_log_event.dart';
import 'package:app/controllers/sensor_log_controller/sensor_log_state.dart';
import 'package:app/models/sensor_log_model.dart';
import 'package:app/services/sensor_log_service.dart';

class SensorLogBloc {
  var eventController = StreamController<SensorLogEvent>();

  var humiSoilLogStateController = StreamController<SensorLogsDateState>();
  var humiAirLogStateController = StreamController<SensorLogsDateState>();
  var tempLogStateController = StreamController<SensorLogsDateState>();
  var sensorLogLatestStateController = StreamController<List<SensorLogModel>>();

  SensorLogBloc() {
    eventController.stream.listen((event) async {
      if (event is SensorLogGetEvent) {
        //call service get taskLog
        List<SensorLogModel> sensorLogs =
            await getSensorLog(event.sensorID, event.date);
        if (event.sensorID == "1") {
          //add taskLog to taskLogStateController
          humiSoilLogStateController.sink
              .add(SensorLogsDateState(sensorLogs: sensorLogs));
        } else if (event.sensorID == "2") {
          humiAirLogStateController.sink
              .add(SensorLogsDateState(sensorLogs: sensorLogs));
        } else if (event.sensorID == "3") {
          tempLogStateController.sink
              .add(SensorLogsDateState(sensorLogs: sensorLogs));
        }
      }
      if (event is SensorLogLatestEvent) {
        //call service get sensorLog latest
        List<SensorLogModel> sensorLogs = await getSensorLogLatest();
        //add taskLog to sensorLogStateController
        sensorLogLatestStateController.sink.add(sensorLogs);
      }
    });
  }
}

final sensorLogBloc = SensorLogBloc();
