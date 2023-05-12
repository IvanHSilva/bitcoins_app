import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../adapters/coin_hive_adapter.dart';
import '../models/coin.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<Coin> _favorites = [];
  late LazyBox box;

  FavoritesRepository() {
    _startRepository();
  }

  _startRepository() async {
    await _openBox();
    await _readFavorites();
  }

  _openBox() async {
    Hive.registerAdapter(CoinHiveAdapter());
    box = await Hive.openLazyBox('favorites_coins');
  }

  _readFavorites() async {
    //box.keys.forEach((coin) async {
    for (Coin coin in box.keys) {
      Coin c = await box.get(coin);
      _favorites.add(c);
      notifyListeners();
    } //);
  }

  UnmodifiableListView<Coin> get favorites => UnmodifiableListView(_favorites);

  saveAll(List<Coin> coins) {
    for (Coin coin in coins) {
      //if (!_favorites.contains(coin)) _favorites.add(coin);
      if (!_favorites.any((current) => current.alias == coin.alias)) {
        _favorites.add(coin);
        box.put(coin.alias, coin);
      }
    }
    notifyListeners();
  }

  remove(Coin coin) {
    _favorites.remove(coin);
    box.delete(coin.alias);
    notifyListeners();
  }
}
