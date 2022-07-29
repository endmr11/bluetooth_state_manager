# bluetooth_state_manager

The Bluetooth State Manager package only meets the needs of those who want to monitor the bluetooth status.The example scenario is to separate the state process from the processes done in its native layer instead of using other Bluetooth packages.

[![pubdev](https://img.shields.io/badge/pub-bluetooth_state_manager-blue)](https://pub.dev/packages/flutter_state_manager)

## Ekler

android/app/src/main/AndroidManifest.xml

```xml
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example">
    <uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>
    <uses-permission android:name="android.permission.BLUETOOTH"/>
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN"/>
```

You only need add the permission message on the Info.plist

```
	<key>NSBluetoothAlwaysUsageDescription</key>
	<string>NSBluetoothAlwaysUsageDescription</string>
```

## Usage/Examples

main.dart

```dart
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
```

bluetooth_manager.dart

```dart
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
    //You can listen to the bluetooth status continuously with the stream method.
  @override
  Stream<bool> listenBleState() {
    return _bluetoothStateManager.getBleState;
  }
    //You can turn on bluetooth. Android only!
  @override
  Future<void> onBle() async {
    try {
      _bluetoothStateManager.onBle;
    } catch (e) {
      print(e.toString());
    }
  }

    //You can turn off bluetooth. Android only!
  @override
  Future<void> offBle() async {
    try {
      _bluetoothStateManager.offBle;
    } catch (e) {
      print(e.toString());
    }
  }
}
```

## Contributors

Author: endmr11 [!["github"](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/endmr11)

## Feedback

If you have any feedback, please contact us at erndemir.1@gmail.com.
