import 'dart:async';

import 'package:flutter/services.dart';

class DataOverSound {
  static const MethodChannel _channel = const MethodChannel('data_over_sound');

  static const EventChannel _timeChannel =
      const EventChannel('data_over_sound.scan');

  Stream<String> get onReceive =>
      _timeChannel.receiveBroadcastStream(0).cast<String>();

  Future<bool> send(String message) => _channel.invokeMethod('send', {
        "data": message,
      });

  Future<bool> init([SoundMode mode = SoundMode.ultrasonic_experimental]) =>
      _send('init', mode);

  Future<bool> scan([SoundMode mode = SoundMode.ultrasonic_experimental]) =>
      _send('scan', mode);

  Future<bool> _send(
    String name, [
    SoundMode mode = SoundMode.ultrasonic_experimental,
  ]) =>
      _channel.invokeMethod(name, {
        "key": mode.val,
      });

  Future<bool> stop() => _channel.invokeMethod('stop');
}

extension Ext on SoundMode {
  String get val =>
      this.toString().replaceAll("_", "-").replaceAll("SoundMode.", "");
}

enum SoundMode {
  audible,
  audible_7k_channel_0,
  audible_7k_channel_1,
  cable_64k,
  hello_world,
  ultrasonic,
  ultrasonic_3600,
  ultrasonic_whisper,
  ultrasonic_experimental
}
