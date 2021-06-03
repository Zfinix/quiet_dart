import 'package:data_over_sound/data_over_sound.dart';
import 'package:data_over_sound_example/models/money_model.dart';
import 'package:data_over_sound_example/utils/navigator.dart';
import 'package:data_over_sound_example/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:im_animations/im_animations.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'dialog/send_success_dialog.dart';

class Receive extends StatefulHookWidget {
  const Receive({Key key}) : super(key: key);

  @override
  _ReceiveState createState() => _ReceiveState();
}

class _ReceiveState extends State<Receive> {
  final dos = DataOverSound();
  @override
  void initState() {
    super.initState();
    scan();
  }

  @override
  void dispose() {
    super.dispose();
    stop();
  }

  void _listen(String event) async {
    var data = MoneyModel.fromRAW(event);

    if (data != null) {
      context.popView();
      await showCupertinoModalBottomSheet(
          context: context,
          builder: (_) {
            return SendSuccessDialog(data, false);
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        backgroundColor: kPrimaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'chizi',
              child: ColorSonar(
                wavesDisabled: false,
                // waveMotion: WaveMotion.synced,
                contentAreaRadius: 10,
                contentAreaColor: white.withOpacity(0.1),
                innerWaveColor: white.withOpacity(0.1),
                outerWaveColor: white.withOpacity(0.1),
                middleWaveColor: white.withOpacity(0.1),
                waveFall: 50,
                waveMotion: WaveMotion.synced,
                // duration: Duration(seconds: 5),
                child: Container(
                  width: 80,
                  height: 80,
                  child: Image.asset('assets/img/chizi.png', height: 80),
                ),
              ),
            ),
          ],
        ));
  }

  void scan() async {
     dos
      ..scan(SoundMode.audible)
      ..onReceive.listen((event) {
        _listen(event);
      });
  }

  void stop() async {
    await dos.stop();
  }
}
