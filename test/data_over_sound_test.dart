import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:data_over_sound/data_over_sound.dart';

void main() {
  const MethodChannel channel = MethodChannel('data_over_sound');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    //expect(await DataOverSound.platformVersion, '42');
  });
}
