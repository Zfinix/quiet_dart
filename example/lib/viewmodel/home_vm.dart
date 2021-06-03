import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:data_over_sound/data_over_sound.dart';
import 'package:data_over_sound_example/models/money_model.dart';
import 'package:data_over_sound_example/views/dialog/send_success_img_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../views/dialog/send_success_dialog.dart';

class HomeViewModel extends ChangeNotifier {
  TextEditingController textTEC = new TextEditingController();
  var dos = DataOverSound();

  BuildContext _context;

  MoneyModel _moneyModel;
  MoneyModel get moneyModel => _moneyModel;
  set moneyModel(MoneyModel val) {
    _moneyModel = val;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool val) {
    _loading = val;
    notifyListeners();
  }

  Future<void> init(BuildContext context) async {
    try {
      _context = context;
      dos..init(SoundMode.audible);
    } catch (e) {
      print(e.toString());
    }
  }

  void start() async {
    try {
      loading = true;
      await dos.scan();
    } catch (e) {
      print(e.toString());
    }
  }

  void stop() async {
    try {
      loading = false;
      await dos.stop();
    } catch (e) {
      print(e.toString());
    }
  }

  void sendMoney(context) async {
    String amt = (textTEC.text ?? '').replaceAll('\u20a6 ', '');
    if (amt.isNotEmpty) {
      final model = MoneyModel(name: "Homa", amount: double.parse(amt));
      loading = false;
      await dos.send(model.toRaw()).then((value) {
        textTEC.clear();
        showCupertinoModalBottomSheet(
            context: context,
            builder: (_) {
              return SendSuccessDialog(model);
            });
      });
    }
  }

  void sendImage(context) async {
    if (image != null) {
      final raw = base64.encode(await image.readAsBytes());
      print(raw);
      await dos.send(raw).then((value) {
      loading = false;
        showCupertinoModalBottomSheet(
            context: context,
            builder: (_) {
              return SendSuccessImageDialog();
            });
      });
    }
  }

  void _listen(String event) {
    var data = MoneyModel.fromRAW(event);

    if (data != null) {
      showCupertinoModalBottomSheet(
          context: _context,
          builder: (_) {
            return SendSuccessDialog(moneyModel);
          });
    }
    loading = false;
  }

  setLoading() {
    _loading = false;
  }

  onTapNum(String val) {
    String _oldVal = (textTEC.text ?? '').replaceAll('\u20a6 ', '');
    switch (val) {
      case '⌫':
        var m = _oldVal.split('');
        if (m.length > 0) {
          m.removeLast();

          _oldVal = m.join();
        } else {
          _oldVal = "";
        }
        break;
      case '•':
        if (!_oldVal.contains('.') &&
            _oldVal.split('').isNotEmpty &&
            _oldVal.split('').last.isNotEmpty) _oldVal += ".";
        break;

      default:
        _oldVal += "$val";
    }
    if (_oldVal.isNotEmpty)
      textTEC.text = '\u20a6 ' '$_oldVal';
    else
      textTEC.clear();
  }

  File _image;
  File get image => _image;
  set image(File val) {
    _image = val;
    notifyListeners();
  }

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }
}
