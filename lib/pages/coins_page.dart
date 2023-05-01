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
  final coins = CoinRepository.coins;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Coin> selected = [];

  appBarDynamic() {
    if (selected.isEmpty) {
      return AppBar(
        title: const Text('Crypto Moedas'),
        centerTitle: true,
      );
    } else {
      return AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              selected = [];
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('${selected.length} selecionada(s)'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextTheme(
          titleLarge: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).titleLarge,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDynamic(),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selected.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {},
              icon: const Icon(Icons.star),
              label: const Text(
                'Favoritar',
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}
