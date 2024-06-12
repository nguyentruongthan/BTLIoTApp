import 'dart:convert';
import 'package:app/services/global.dart';
import 'package:http/http.dart' as http;
import 'package:app/models/task_model.dart';

Future<List<TaskModel>> getScheduler() async {
  try{
    List<TaskModel> scheduler = [];
    //call api get scheduler
    var url = Uri.http(serverUrl, '/scheduler');
    var res = await http.get(url);
    if (res.statusCode == 200) {
      print("res.body: ${res.body}");
      var tasks = jsonDecode(res.body);

      for (var task in tasks) {
        TaskModel taskModel = TaskModel(
            id: task['_id'],
            flow1: task['flow1'],
            flow2: task['flow2'],
            flow3: task['flow3'],
            isActive: task['isActive'],
            schedulerName: task['schedulerName'],
            startTime: task['startTime'],
            stopTime: task['stopTime'],
            gardenName: task['gardenName'],
            pumpIn: task['pumpIn']);
        scheduler.add(taskModel);
      }
    }
    return scheduler;
  }catch(err){
    return [];
  }
  
}

Future<TaskModel> postScheduler(event) async {
  try{
    //check all field  is not empty
    if (event.schedulerName == '' ||
        event.gardenName == '' ||
        event.startTime == '' ||
        event.stopTime == '' ||
        event.flow1 == '' ||
        event.flow2 == '' ||
        event.flow3 == '' ||
        event.pumpIn == '') {
      return TaskModel(
          id: '',
          flow1: '',
          flow2: '',
          flow3: '',
          isActive: '',
          schedulerName: '',
          startTime: '',
          stopTime: '',
          gardenName: '',
          pumpIn: '');
    }
    //call api post scheduler

    var url = Uri.http(serverUrl, '/scheduler');
    var res = await http.post(url, body: {
      'schedulerName': event.schedulerName,
      'gardenName': event.gardenName,
      'startTime': event.startTime,
      'stopTime': event.stopTime,
      'flow1': event.flow1,
      'flow2': event.flow2,
      'flow3': event.flow3,
      'pumpIn': event.pumpIn,
    });

    if (res.statusCode == 200) {
      var task = jsonDecode(res.body);
      return TaskModel(
          gardenName: task['gardenName'],
          id: task['_id'],
          flow1: task['flow1'],
          flow2: task['flow2'],
          flow3: task['flow3'],
          isActive: task['isActive'],
          schedulerName: task['schedulerName'],
          startTime: task['startTime'],
          stopTime: task['stopTime'],
          pumpIn: task['pumpIn']);
    }
    return TaskModel(
        id: '',
        flow1: '',
        flow2: '',
        flow3: '',
        isActive: '',
        schedulerName: '',
        startTime: '',
        stopTime: '',
        gardenName: '',
        pumpIn: '');
  }catch(err){
    return TaskModel(
      id: '',
      flow1: '',
      flow2: '',
      flow3: '',
      isActive: '',
      schedulerName: '',
      startTime: '',
      stopTime: '',
      gardenName: '',
      pumpIn: '');
  }
  
}

Future<TaskModel> updateScheduler(event) async {
  try{
    //check all field  is not empty
    if (event.schedulerName == '' ||
        event.gardenName == '' ||
        event.startTime == '' ||
        event.stopTime == '' ||
        event.flow1 == '' ||
        event.flow2 == '' ||
        event.flow3 == '' ||
        event.pumpIn == '') {
      return TaskModel(
          id: event.id,
          flow1: '',
          flow2: '',
          flow3: '',
          isActive: '',
          schedulerName: '',
          startTime: '',
          stopTime: '',
          gardenName: '',
          pumpIn: '');
    }

    //call api update task
    var url = Uri.http(serverUrl, '/scheduler/${event.id}');
    var res = await http.put(url, body: {
      'schedulerName': event.schedulerName,
      'gardenName': event.gardenName,
      'startTime': event.startTime,
      'stopTime': event.stopTime,
      'flow1': event.flow1,
      'flow2': event.flow2,
      'flow3': event.flow3,
      'pumpIn': event.pumpIn
    });

    if (res.statusCode == 200) {
      var task = jsonDecode(res.body);
      return TaskModel(
          gardenName: task['gardenName'],
          id: task['_id'],
          flow1: task['flow1'],
          flow2: task['flow2'],
          flow3: task['flow3'],
          isActive: task['isActive'],
          schedulerName: task['schedulerName'],
          startTime: task['startTime'],
          stopTime: task['stopTime'],
          pumpIn: task['pumpIn']);
    }
    return TaskModel(
        id: '',
        flow1: '',
        flow2: '',
        flow3: '',
        isActive: '',
        schedulerName: '',
        startTime: '',
        stopTime: '',
        gardenName: '',
        pumpIn: '');
  }catch(err){
    return TaskModel(
      id: '',
      flow1: '',
      flow2: '',
      flow3: '',
      isActive: '',
      schedulerName: '',
      startTime: '',
      stopTime: '',
      gardenName: '',
      pumpIn: '');
  }
  
}

Future<TaskModel> updateIsActiveTask(TaskModel task, String isActive) async {
  try{
    //call api update task
    var url = Uri.http(serverUrl, '/scheduler/${task.id}');
    var res = await http.put(url, body: {
      'schedulerName': task.schedulerName,
      'gardenName': task.gardenName,
      'startTime': task.startTime,
      'stopTime': task.stopTime,
      'flow1': task.flow1,
      'flow2': task.flow2,
      'flow3': task.flow3,
      'pumpIn': task.pumpIn,
      'isActive': isActive
    });

    if (res.statusCode == 200) {
      var task = jsonDecode(res.body);
      return TaskModel(
          gardenName: task['gardenName'],
          id: task['_id'],
          flow1: task['flow1'],
          flow2: task['flow2'],
          flow3: task['flow3'],
          isActive: task['isActive'],
          schedulerName: task['schedulerName'],
          startTime: task['startTime'],
          stopTime: task['stopTime'],
          pumpIn: task['pumpIn']);
    }
    return TaskModel(
        id: '',
        flow1: '',
        flow2: '',
        flow3: '',
        isActive: '',
        schedulerName: '',
        startTime: '',
        stopTime: '',
        gardenName: '',
        pumpIn: '');
  }catch(err){
    return TaskModel(
        id: '',
        flow1: '',
        flow2: '',
        flow3: '',
        isActive: '',
        schedulerName: '',
        startTime: '',
        stopTime: '',
        gardenName: '',
        pumpIn: '');
  }
  
}

Future<int> deleteTask(String id) async {
  try{
    //call api delete task
    var url = Uri.http(serverUrl, '/scheduler/$id');
    var res = await http.delete(url);
    return res.statusCode;
  }catch(err){
    return 500;
  }
  
}
