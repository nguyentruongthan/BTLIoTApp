import 'dart:async';

import 'package:app/controllers/timer_controller/timer_state.dart';

class TimerBloc {
  var eventController = StreamController();
  var timerCheckTaskStateController = StreamController<CurrentMinuteState>.broadcast();
  TimerBloc() {
    // init timer every 5s
    Timer.periodic(const Duration(seconds: 5), (timer) {
      // get current time
      DateTime now = DateTime.now();
      final hour = now.hour;
      final minute = now.minute;
      timerCheckTaskStateController.sink.add(CurrentMinuteState(hour*60 + minute));
    });
  }
}

TimerBloc timerBloc = TimerBloc();
