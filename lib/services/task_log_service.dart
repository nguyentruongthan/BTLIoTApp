import 'dart:convert';

import 'package:app/services/global.dart';
import 'package:http/http.dart' as http;
import 'package:app/models/task_log_model.dart';

Future<TaskLogModel> getTaskLog(String taskID) async {
  try{
    //call api get taskLog
    var url = Uri.http(serverUrl, '/taskLog/$taskID');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      var taskLog = jsonDecode(res.body);
      TaskLogModel taskLogModel = TaskLogModel(
          taskID: taskLog['taskID'],
          flow1: taskLog['flow1'],
          flow2: taskLog['flow2'],
          flow3: taskLog['flow3'],
          pumpIn: taskLog['pumpIn'],
          pumpOut: taskLog['pumpOut'],
          status: taskLog['status']);
      return taskLogModel;
    }else{
      return TaskLogModel(
          taskID: '',
          flow1: '',
          flow2: '',
          flow3: '',
          pumpIn: '',
          pumpOut: '',
          status: '0');
    }
  }catch(err){
    return TaskLogModel(
          taskID: '',
          flow1: '',
          flow2: '',
          flow3: '',
          pumpIn: '',
          pumpOut: '',
          status: '0');
  }
  
}
