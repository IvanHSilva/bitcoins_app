import 'package:bitcoins_app/repositories/coin_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import '../database/db.dart';
import '../models/coin.dart';
import '../models/history.dart';
import '../models/position.dart';

class AccountRepository extends ChangeNotifier {
  late Database db;
  List<Position> _wallet = [];
  List<History> _history = [];
  double _balance = 0;

  get balance => _balance;
  List<Position> get wallet => _wallet;
  List<History> get history => _history;

  AccountRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getBalance();
    await _getWallet();
    await _getHistory();
  }

  _getBalance() async {
    db = await DB.instance.database;
    List account = await db.query('account', limit: 1);
    _balance = account.first['balance'];
    notifyListeners();
  }

  setBalance(double value) async {
    db = await DB.instance.database;
    db.update('account', {
      'balance': value,
    });
    _balance = value;
    notifyListeners();
  }

  buyCoin(Coin coin, double value) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      // Check if coins already exists
      final posCoin = await txn
          .query('wallet', where: 'alias = ?', whereArgs: [coin.alias]);

      if (posCoin.isEmpty) {
        await txn.insert('wallet', {
          'alias': coin.alias,
          'coin': coin.name,
          'quantity': (value / coin.price).toString()
        });
      } else {
        final actual = double.parse(posCoin.first['quantity'].toString());
        await txn.update(
            'wallet',
            {
              'quantity': (actual + (value / coin.price)).toString(),
            },
            where: 'alias = ?',
            whereArgs: [coin.alias]);
      }

      // insert buy in history
      await txn.insert('history', {
        'alias': coin.alias,
        'coin': coin.name,
        'quantity': (value / coin.price).toString(),
        'value': value,
        'optype': 'compra',
        'opdate': DateTime.now().millisecondsSinceEpoch,
      });

      // update balance
      await txn.update('account', {'balance': balance - value});
    });
    await _initRepository();
    notifyListeners();
  }

  _getWallet() async {
    _wallet = [];
    List positions = await db.query('wallet');
    for (var pos in positions) {
      Coin coin = CoinRepository.coins.firstWhere(
        (c) => c.alias == pos['alias'],
      );
      _wallet.add(Position(
        coin: coin,
        quantity: double.parse(pos['quantity']),
      ));
      notifyListeners();
    }
  }

  _getHistory() async {
    _history = [];
    List operations = await db.query('history');
    for (var ope in operations) {
      Coin coin = CoinRepository.coins.firstWhere(
        (c) => c.alias == ope['alias'],
      );
      _history.add(
        History(
          opDate: DateTime.fromMicrosecondsSinceEpoch(ope['opdate']),
          opType: ope['optype'],
          coin: coin,
          value: ope['value'],
          quantity: double.parse(ope['quantity']),
        ),
      );
      notifyListeners();
    }
  }
}
