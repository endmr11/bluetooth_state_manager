import 'dart:async';
import 'dart:developer';

import 'package:bluetooth_state_manager/bluetooth_state_manager.dart';

abstract class IBluetoothManager {
  Stream<bool> listenBleState();
  Future<void> onBle();
  Future<void> offBle();
}

class BluetoothManager extends IBluetoothManager {
  late final BluetoothStateManager _bluetoothStateManager;

  BluetoothManager() {
    _bluetoothStateManager = BluetoothStateManager();
    _bluetoothStateManager.platformVersion;
  }

  @override
  Stream<bool> listenBleState() {
    return _bluetoothStateManager.getBleState;
  }

  @override
  Future<void> onBle() async {
    try {
      _bluetoothStateManager.onBle;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<void> offBle() async {
    try {
      _bluetoothStateManager.offBle;
    } catch (e) {
      log(e.toString());
    }
  }
}
