import 'dart:async';

import 'package:app/controllers/login_controller/login_event.dart';
import 'package:app/controllers/login_controller/login_state.dart';
import 'package:app/services/login_service.dart';

class LoginBloc {
  final eventController = StreamController<LoginEvent>();

  var loginStateController = StreamController<LoginState>();

  LoginBloc() {
    eventController.stream.listen((event) async {
      String ipAddress = event.ipAddress;
      //call service login
      bool isLogin = await login(ipAddress);
      loginStateController.sink.add(LoginState(isSuccess: isLogin));
    });
  }
}

LoginBloc loginBloc = LoginBloc();
