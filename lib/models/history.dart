import 'package:bitcoins_app/models/coin.dart';

class History {
  DateTime opDate;
  String opType;
  Coin coin;
  double value;
  double quantity;

  History({
    required this.opDate,
    required this.opType,
    required this.coin,
    required this.value,
    required this.quantity,
  });
}
