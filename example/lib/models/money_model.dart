class MoneyModel {
  String name;
  double amount;

  MoneyModel({this.name, this.amount});

  MoneyModel.fromRAW(String raw) {
    var _raw = raw.split(',');
    if (_raw.length > 0) name = _raw[0];
    if (_raw.length >= 1) amount = double.parse(_raw[1]);
  }

  String toRaw() => "$name,$amount";
}
