import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class BluetoothStateManager {
  static const MethodChannel _channel = MethodChannel('bluetooth_state_manager');
  static const EventChannel _eventChannel = EventChannel('event_bluetooth_state_manager');

  Future<void> get platformVersion async {
    if (Platform.isIOS) {
      await _channel.invokeMethod('initManager');
    }
  }

  Stream<bool> get getBleState {
    return _eventChannel.receiveBroadcastStream().cast();
  }

  Future<void> get onBle async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('onBle');
    }
  }

  Future<void> get offBle async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('offBle');
    }
  }
}
