package com.bluetooth_state_manager.bluetooth_state_manager

import android.app.Activity
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.widget.Toast
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class BluetoothStateManagerPlugin : FlutterPlugin, MethodCallHandler,
    ActivityAware,
    PluginRegistry.ActivityResultListener, EventChannel.StreamHandler {

    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var sink: EventChannel.EventSink

    private lateinit var activity: Activity

    private lateinit var bleAdapter: BluetoothAdapter
    private var BLE_REQUEST_CODE = 1
    private var bleIsOpen = false




    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "bluetooth_state_manager")
        channel.setMethodCallHandler(this)
        eventChannel =
            EventChannel(flutterPluginBinding.binaryMessenger, "event_bluetooth_state_manager")
        eventChannel.setStreamHandler(this)
        bleAdapter = BluetoothAdapter.getDefaultAdapter()
        var intentFilter = IntentFilter(BluetoothAdapter.ACTION_STATE_CHANGED)
        flutterPluginBinding.applicationContext.registerReceiver(broadcastReceiver,intentFilter)

    }



//  val broadCastReceiver = object : BroadcastReceiver() {
//    override fun onReceive(context: Context, intent: Intent) {
//      var action = intent.action
//      if (action.equals(BluetoothAdapter.ACTION_STATE_CHANGED)){
//        var state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE,BluetoothAdapter.ERROR )
//        when (state) {
//          BluetoothAdapter.STATE_OFF -> {
//            sink.success(false)
//          }
//          BluetoothAdapter.STATE_TURNING_OFF -> {
//            sink.success(false)
//          }
//          BluetoothAdapter.STATE_ON -> {
//            sink.success(true)
//          }
//          BluetoothAdapter.STATE_TURNING_ON -> {
//            sink.success(true)
//          }
//          else -> {
//            sink.success(false)
//          }
//        }
//      }
//
//    }
//  }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "onBle" -> {
                onBle()
            }
            "offBle" -> {
                offBle()
            }
            else -> {
                result.notImplemented()
            }
        }
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == BLE_REQUEST_CODE) {

            if (resultCode == Activity.RESULT_OK) {

                return true
            }
        }
        return false
    }


    //BLE OPERATIONS
    private fun onBle() {
        if (!bleAdapter.isEnabled) {
            var enableIntent = Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE)
            activity.startActivityForResult(enableIntent, BLE_REQUEST_CODE)
            this.bleIsOpen = true
            Toast.makeText(
                flutterPluginBinding.applicationContext,
                "Ble Turned On",
                Toast.LENGTH_SHORT
            ).show()
        } else {
            Toast.makeText(
                flutterPluginBinding.applicationContext,
                "Ble is already on",
                Toast.LENGTH_SHORT
            ).show()
        }
    }

    private fun offBle() {
        bleAdapter.disable()
        this.bleIsOpen = false
        Toast.makeText(
            flutterPluginBinding.applicationContext,
            "Ble Turned Off",
            Toast.LENGTH_SHORT
        ).show()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity

    }
    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            var action = intent.action
            if (action.equals(BluetoothAdapter.ACTION_STATE_CHANGED)) {
                var state = intent.getIntExtra(BluetoothAdapter.EXTRA_STATE, BluetoothAdapter.ERROR)
                when (state) {
                    BluetoothAdapter.STATE_OFF -> {
                        sink.success(false)
                    }
                    BluetoothAdapter.STATE_TURNING_OFF -> {
                        sink.success(false)
                    }
                    BluetoothAdapter.STATE_ON -> {
                        sink.success(true)
                    }
                    BluetoothAdapter.STATE_TURNING_ON -> {
                        sink.success(true)
                    }
                    else -> {
                        sink.success(false)
                    }
                }
            }
        }
    }
    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        flutterPluginBinding.applicationContext.unregisterReceiver(broadcastReceiver)
    }

    override fun onListen(arguments: Any?, events: EventSink?) {
        if (events != null) {
            sink = events
        };
    }

    override fun onCancel(arguments: Any?) {
        sink.endOfStream();
    }
}



