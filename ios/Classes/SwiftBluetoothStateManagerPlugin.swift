import Flutter
import UIKit
import CoreBluetooth

public class SwiftBluetoothStateManagerPlugin: NSObject, FlutterPlugin, FlutterStreamHandler,BleStateHandlerProtocol {
  var manager: BLEManager!
  var sink: FlutterEventSink?
  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = SwiftBluetoothStateManagerPlugin()
    let channel = FlutterMethodChannel(name: "bluetooth_state_manager", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(instance, channel: channel)
    let eventChannel = FlutterEventChannel(name: "event_bluetooth_state_manager", binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    if(call.method == "initManager"){
      print("6 ")
      self.manager = BLEManager.sharedManager
      self.manager.setProtocol(bleStateHandlerProtocol:self)
    }
  }

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
      sink = events
      return nil
  }
    
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
      sink = nil
      return nil
  }

  func sendData(data:Bool) {
      guard let sink = sink else { return }
      print("sendData \(data)")
      sink(data)
    }
}


class BLEManager: NSObject, CBCentralManagerDelegate {
  static let sharedManager: BLEManager = BLEManager()
  var bleStateHandlerProtocol:BleStateHandlerProtocol?
  var cbCentral: CBCentralManager!

      override init() {
        super.init() 
        self.cbCentral = CBCentralManager(delegate: self, queue: nil,options: [CBCentralManagerOptionShowPowerAlertKey: true])
    }

  public func setProtocol(bleStateHandlerProtocol:BleStateHandlerProtocol){
    self.bleStateHandlerProtocol = bleStateHandlerProtocol
  }
  public func centralManagerDidUpdateState(_ central: CBCentralManager){
    switch central.state {
      case .unknown:
        print("central.state is .unknown")
        bleStateHandlerProtocol?.sendData(data:false)
        break
      case .resetting:
        print("central.state is .resetting")
        break
      case .unsupported:
        print("central.state is .unsupported")
        break
      case .unauthorized:
        print("central.state is .unauthorized")
        break
      case .poweredOff:
        print("central.state is .poweredOff")
        bleStateHandlerProtocol?.sendData(data:false)
        break
      case .poweredOn:
        print("central.state is .poweredOn")
        bleStateHandlerProtocol?.sendData(data:true)
        break
    }
  }
}


protocol BleStateHandlerProtocol {
    func sendData(data:Bool)
}
