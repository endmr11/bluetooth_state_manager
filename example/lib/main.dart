import 'package:bluetooth_state_manager_example/bluetooth_manager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final bluetoothManager = BluetoothManager();
  bool? isBleEnable;
  late Stream<bool> bluetoothManagerSubs;
  @override
  void initState() {
    bluetoothManagerSubs = bluetoothManager.listenBleState();
    if (isBleEnable == null) {
      bluetoothManager.onBle();
    }
    bluetoothManagerSubs.listen((event) {
      setState(() {
        isBleEnable = event;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('BLE STATUS: $isBleEnable\n'),
              ElevatedButton(onPressed: () => bluetoothManager.onBle(), child: const Text("On")),
              ElevatedButton(onPressed: () => bluetoothManager.offBle(), child: const Text("Off"))
            ],
          ),
        ),
      ),
    );
  }
}
