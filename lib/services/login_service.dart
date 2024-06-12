import 'dart:async';

import 'package:app/services/global.dart';
import 'package:http/http.dart' as http;

Future<bool> login(String ipAddress) async {
  try {
    //call api login
    var url = Uri.http("$ipAddress:8000", '/login/');
    
    var res = await http.get(url).timeout(const Duration(seconds: 3));

    if (res.statusCode == 200) {
      serverUrl = "$ipAddress:8000";
      return true;

    } else {
      return false;
    }
  } catch (err) {
    return false;
  }
}
