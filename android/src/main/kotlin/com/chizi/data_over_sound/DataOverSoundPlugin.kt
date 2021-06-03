package com.chizi.data_over_sound

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import org.quietmodem.Quiet.FrameReceiver
import org.quietmodem.Quiet.FrameReceiverConfig

/** DataOverSoundPlugin */
class DataOverSoundPlugin: FlutterPlugin, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var channel: MethodChannel? = null
  private var handler: MethodCallHandlerImpl? = null
  private var scanChannel: EventChannel? = null
  private val scanChannelID = "data_over_sound.scan"


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "data_over_sound")
    scanChannel = EventChannel(flutterPluginBinding.binaryMessenger, scanChannelID)
    handler = MethodCallHandlerImpl(flutterPluginBinding.applicationContext, null,scanChannel)
    channel?.setMethodCallHandler(handler)

  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    teardownChannel()
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    handler?.setActivity(binding.activity)

  }

  override fun onDetachedFromActivityForConfigChanges() {
    handler?.setActivity(null)
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
    handler?.detachListener()
    onDetachedFromActivity()
  }

  private fun teardownChannel() {
    channel?.setMethodCallHandler(null)
    channel = null
    handler = null
  }

}

