import 'package:bitcoins_app/models/coin.dart';
import 'package:bitcoins_app/repositories/coin_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({super.key});

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  @override
  Widget build(BuildContext context) {
    final coins = CoinRepository.coins;
    NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
    List<Coin> selected = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cripto Moedas'),
      ),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int coin) {
          return ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            leading: (selected.contains(coins[coin]))
                ? const CircleAvatar(
                    child: Icon(Icons.check),
                  )
                : SizedBox(
                    width: 50,
                    child: Image.asset(coins[coin].icon),
                  ),
            title: Text(
              coins[coin].name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              real.format(coins[coin].price),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: (coins[coin].price > 100) ? Colors.blue : Colors.red,
              ),
            ),
            selected: selected.contains(coins[coin]),
            selectedTileColor: Colors.indigo[50],
            onLongPress: () {
              setState(() {
                (selected.contains(coins[coin]))
                    ? selected.remove(coins[coin])
                    : selected.add(coins[coin]);
                debugPrint(coins[coin].name);
                debugPrint(selected.contains(coins[coin]).toString());
                debugPrint(coins[coin].toString());
              });
            },
          );
        },
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: coins.length,
      ),
    );
  }
}
