import 'dart:collection';

import 'package:flutter/material.dart';
import '../models/coin.dart';

class FavoritesRepository extends ChangeNotifier {
  final List<Coin> _favorites = [];
  UnmodifiableListView<Coin> get favorites => UnmodifiableListView(_favorites);

  saveAll(List<Coin> coins) {
    for (Coin coin in coins) {
      if (!_favorites.contains(coin)) _favorites.add(coin);
    }
    notifyListeners();
  }

  remove(Coin coin) {
    _favorites.remove(coin);
    notifyListeners();
  }
}
