// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:app/controllers/sensor_log_controller/sensor_log_bloc.dart';
import 'package:app/controllers/sensor_log_controller/sensor_log_event.dart';
import 'package:app/controllers/sensor_log_controller/sensor_log_state.dart';
import 'package:app/models/sensor_log_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final int minute;
  final double value;
  ChartData({required this.minute, required this.value});
}

class ChartHistory extends StatefulWidget {
  final String sensorID;
  final String date;
  ChartHistory({required this.sensorID, required this.date});
  @override
  State<ChartHistory> createState() => _ChartHistoryState();
}

class _ChartHistoryState extends State<ChartHistory> {
  List<ChartData> chartDatas = [];
  @override
  void initState() {
    super.initState();
    chartDatas = [];
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SensorLogsDateState>(
        stream: widget.sensorID == "2"
                ? sensorLogBloc.humiAirLogStateController.stream
                : widget.sensorID == "3"
                    ? sensorLogBloc.tempLogStateController.stream
                    : null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return AlertDialog(
                title: const Text('Waiting',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "IndieFlower",
                      fontWeight: FontWeight.bold,
                    )),
                content: LinearProgressIndicator());
          } else {
            List<SensorLogModel> sensorLogs = snapshot.data!.sensorLogs;
            chartDatas = [];
            for (var sensorLog in sensorLogs) {
              DateTime dateTime = DateTime.parse(sensorLog.timeStamp);
              final minute = dateTime.hour * 60 + dateTime.minute;
              final value = double.parse(sensorLog.value);
              chartDatas.add(ChartData(minute: minute, value: value));
            }
            return SizedBox(
                height: 300,
                child: SfCartesianChart(
                    primaryXAxis: NumericAxis(
                      minimum: 0,
                      maximum: 24 * 60,
                      interval: 120,
                      axisLabelFormatter: (AxisLabelRenderDetails details) {
                        // Chuyển đổi giá trị trục X từ phút sang giờ
                        final int minutes = details.value.toInt();
                        final int hours = minutes ~/ 60;
                        return ChartAxisLabel('$hours', details.textStyle);
                      },
                    ),
                    primaryYAxis: NumericAxis(
                      minimum: 0,
                      maximum: widget.sensorID == "3" ? 50 : 100,
                    ),
                    title: ChartTitle(
                        text: widget.sensorID == "2"
                                ? 'Lịch sử độ ẩm không khí'
                                : widget.sensorID == "3"
                                    ? 'Lịch sử nhiệt độ'
                                    : ""),
                    series: <CartesianSeries<ChartData, int>>[
                      LineSeries<ChartData, int>(
                          dataSource: chartDatas,
                          xValueMapper: (ChartData data, _) => data.minute,
                          yValueMapper: (ChartData data, _) => data.value)
                    ]));
          }
        });
  }
}

class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late DateTime selectedDate;
  String dateForGetData = "";
  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        //call api get sensor log with new date
        selectedDate = picked;
        dateForGetData =
            "${selectedDate.month}-${selectedDate.day}-${selectedDate.year}";
        sensorLogBloc.eventController.sink
            .add(SensorLogGetEvent(sensorID: "2", date: dateForGetData));
        sensorLogBloc.eventController.sink
            .add(SensorLogGetEvent(sensorID: "3", date: dateForGetData));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    dateForGetData =
        "${selectedDate.month}-${selectedDate.day}-${selectedDate.year}";
    sensorLogBloc.eventController.sink
        .add(SensorLogGetEvent(sensorID: "2", date: dateForGetData));
    sensorLogBloc.eventController.sink
        .add(SensorLogGetEvent(sensorID: "3", date: dateForGetData));
  }

  @override
  void dispose() {
    super.dispose();

    sensorLogBloc.humiAirLogStateController.close();
    sensorLogBloc.humiAirLogStateController =
        StreamController<SensorLogsDateState>();

    sensorLogBloc.tempLogStateController.close();
    sensorLogBloc.tempLogStateController =
        StreamController<SensorLogsDateState>();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        
        child: Column(
          children: [
            TextButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text(
                    "Tháng ${selectedDate.month} - Ngày ${selectedDate.day} - Năm ${selectedDate.year}")),
            ChartHistory(sensorID: "2", date: dateForGetData),
            ChartHistory(sensorID: "3", date: dateForGetData),
          ],
        ),
      ),
    );
  }
}
