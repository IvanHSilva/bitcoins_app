import 'package:hive/hive.dart';
import '../models/coin.dart';

class CoinHiveAdapter extends TypeAdapter<Coin> {
  @override
  final int typeId = 0;

  @override
  Coin read(BinaryReader reader) {
    return Coin(
      name: reader.readString(),
      icon: reader.readString(),
      alias: reader.readString(),
      price: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Coin obj) {
    writer.writeString(obj.name);
    writer.writeString(obj.icon);
    writer.writeString(obj.alias);
    writer.writeDouble(obj.price);
  }
}
