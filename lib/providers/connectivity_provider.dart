import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io' if (dart.library.html) 'dart:html';
import 'package:flutter/foundation.dart' show kIsWeb;

class ConnectivityProvider with ChangeNotifier {
  bool isWeb = kIsWeb;

  Future<bool> checkInternet() async {
    if (isWeb) {
      // Aquí podrías implementar una manera de verificar conectividad en web
      return true;
    } else {
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      } on SocketException catch (_) {
        return false;
      }
    }
  }

  bool internet = true;

  Future<bool> verifyInternet() async {
    internet = await checkInternet();
    return internet;
  }
}
