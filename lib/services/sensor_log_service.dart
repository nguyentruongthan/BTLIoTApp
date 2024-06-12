import 'dart:convert';

import 'package:app/models/sensor_log_model.dart';
import 'package:app/services/global.dart';
import 'package:http/http.dart' as http;

Future<List<SensorLogModel>> getSensorLog(String sensorID, String date) async {
  try {
    //call api get sensorLog of the date
    var url = Uri.http(serverUrl, '/sensorLog/$sensorID/$date');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      List<SensorLogModel> sensorLogs = [];
      for (var sensorLog in jsonDecode(res.body)) {
        SensorLogModel sensorLogModel = SensorLogModel(
            sensorID: sensorLog['sensorID'],
            value: sensorLog['value'],
            timeStamp: sensorLog['timeStamp']);
        sensorLogs.add(sensorLogModel);
      }
      return sensorLogs;
    } else {
      return [];
    }
  } catch (err) {
    return [];
  }
}

Future<List<SensorLogModel>> getSensorLogLatest() async {
  try{
    //call api get sensorLog latest
    var url = Uri.http(serverUrl, '/sensorLog/');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      List<SensorLogModel> sensorLogs = [];
      sensorLogs.add(SensorLogModel(
          sensorID: '2', value: jsonDecode(res.body)['humiAir'], timeStamp: ''));
      sensorLogs.add(SensorLogModel(
          sensorID: '3', value: jsonDecode(res.body)['temp'], timeStamp: ''));
      return sensorLogs;
    } else {
      return [];
    }
  }catch(err){
    return [];
  }
  
}
