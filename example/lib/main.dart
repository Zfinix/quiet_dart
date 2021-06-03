import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'utils/theme.dart';
import 'views/send.dart';
import 'views/send_img.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    overrideDeviceColors();
    return MaterialApp(
      title: 'SoundCheck',
      debugShowCheckedModeBanner: false,
      theme: themeData(context),
      home: SendImg(),
    );
  }
}
