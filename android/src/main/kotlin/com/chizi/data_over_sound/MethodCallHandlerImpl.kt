package com.chizi.data_over_sound

import android.Manifest
import android.app.Activity
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.quietmodem.Quiet.*
import java.io.IOException
import java.nio.charset.Charset


class MethodCallHandlerImpl(context: Context, activity: Activity?, scanChannel: EventChannel?) : MethodChannel.MethodCallHandler {
    private var context: Context?
    private var activity: Activity?
    private var scanChannel: EventChannel?
    private var tx: FrameTransmitter? = null
    private var txConf: FrameTransmitterConfig? = null
    private var rx: FrameReceiver? = null
    private var rxConf: FrameReceiverConfig? = null

    private var receiver: UltrasonicReceiver? = null
    private val tag: String = "DataOverSoundPlugin"

    fun setActivity(act: Activity?) {
        this.activity = act
    }

    init {
        this.activity = activity
        this.context = context
        this.scanChannel = scanChannel
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Handler(Looper.getMainLooper()).post {
            when (call.method) {
                "init" -> {
                    initialize(call, result)
                }
                "scan" -> {
                    if (ContextCompat.checkSelfPermission(activity!!, Manifest.permission.RECORD_AUDIO) != PackageManager.PERMISSION_GRANTED) {
                        ActivityCompat.requestPermissions(activity!!, arrayOf(Manifest.permission.RECORD_AUDIO), 200)
                    } else {

                        scan(call, result)
                    }
                }
                "send" -> {
                    send(call, result)
                }
                "stop" -> {
                    stop(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }


    private fun initialize(call: MethodCall, result: MethodChannel.Result) {
        try {

            if (tx != null) {
                tx = null
            }

            val key = call.argument<String>("key")
            txConf = FrameTransmitterConfig(context, key)
            rxConf = FrameReceiverConfig(context, key)
            tx = FrameTransmitter(txConf)
            Log.d(tag, "Initialized with: $key")
            result.success(true)
        } catch (e: IOException) {
            result.error(tag, e.localizedMessage, e.message)
        } catch (e: ModemException) {
            result.error(tag, e.localizedMessage, e.message)
        }
    }

    @RequiresApi(Build.VERSION_CODES.KITKAT)
    private fun scan(call: MethodCall, result: MethodChannel.Result) {

        try {
            val key = call.argument<String>("key")
            if(receiver == null) {
            receiver = UltrasonicReceiver(context!!, scanChannel!!)
            receiver!!.initialize(key, result)
            }
            receiver = null;
        } catch (e: Exception) {
            result.error(tag, e.localizedMessage, e.message)

        }
    }

    private fun send(call: MethodCall, result: MethodChannel.Result) {
        try {
            val msg = call.argument<String>("data")
            tx!!.send(msg!!.toByteArray())
            result.success(true)
        } catch (e: IOException) {
            // our message might be too long or the transmit queue full
            result.error(tag, e.localizedMessage, e.message)
        }
    }


    private fun stop(result: MethodChannel.Result?) {
        rx = null;
        result?.success(true)
    }

    fun detachListener() {
        stop(null)
    }
}
