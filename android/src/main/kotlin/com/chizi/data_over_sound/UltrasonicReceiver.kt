package com.chizi.data_over_sound

import android.content.Context
import android.os.Build
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.MethodChannel
import rx.android.schedulers.AndroidSchedulers
import rx.schedulers.Schedulers
import rx.subscriptions.Subscriptions
import java.nio.charset.StandardCharsets

class UltrasonicReceiver(private val context: Context, scanChannel: EventChannel? ) :  EventChannel.StreamHandler{
    private var frameSubscription = Subscriptions.empty()
    private var result: MethodChannel.Result? = null
    private var mEvents: EventSink? = null
    private var soundType: String? = null
    private var scanChannel: EventChannel? = null

    init {
        this.scanChannel = scanChannel;
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    fun initialize(soundType: String?, result: MethodChannel.Result) {
        this.soundType = soundType
        this.result = result

        scanChannel?.setStreamHandler(this)
        runThread()
        result.success(true)
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    private fun runThread() {
        frameSubscription.unsubscribe()
        frameSubscription = FrameReceiverObservable.create(context.applicationContext, soundType).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).subscribe({ buf: ByteArray? ->
            val data = String(buf!!, StandardCharsets.UTF_8)
            Log.i("test", data)
            mEvents?.success(data)
            
        }) { error: Throwable ->
            Log.i("test", error.message!!)
            mEvents?.error("error", error.message, null)
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    fun onResume() {
        runThread()
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    fun onPause() {
        frameSubscription.unsubscribe()
    }


    @RequiresApi(Build.VERSION_CODES.KITKAT)
    override fun onListen(arguments: Any?, events: EventSink?) {
        print(events)
        when (arguments) {

            0 -> {
                if (events != null) {
                    this.mEvents = events
                }
            }
            else -> {

            }
        }
    }


    override fun onCancel(arguments: Any?) {

        frameSubscription.unsubscribe()
    }
}