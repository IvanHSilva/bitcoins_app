import 'package:bitcoins_app/configs/app_settings.dart';
import 'package:bitcoins_app/models/coin.dart';
import 'package:bitcoins_app/pages/coins_details_page.dart';
import 'package:bitcoins_app/repositories/coin_repository.dart';
import 'package:bitcoins_app/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinsPage extends StatefulWidget {
  const CoinsPage({super.key});

  @override
  State<CoinsPage> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPage> {
  final coins = CoinRepository.coins;
  late NumberFormat real;
  late Map<String, String> loc;
  List<Coin> selected = [];
  late FavoritesRepository favorites;

  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? 'US\$ ' : 'R\$';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.swap_vert),
            title: Text('Usar $locale'),
            onTap: () {
              context.read<AppSettings>().setLocale(locale, name);
              // print(locale);
              // print(name);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }

  appBarDynamic() {
    if (selected.isEmpty) {
      return AppBar(
        title: const Text('Crypto Moedas'),
        actions: [
          changeLanguageButton(),
        ],
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

  showDetails(Coin coin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinsDetailsPage(coin: coin),
      ),
    );
  }

  clearSelected() {
    setState(() {
      selected = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    //favorites = Provider.of<FavoritesRepository>(context);
    favorites = context.watch<FavoritesRepository>();
    readNumberFormat();

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
            title: Row(
              children: [
                Text(
                  coins[coin].name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (favorites.favorites.contains(coins[coin]))
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 25,
                  ),
              ],
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
                // debugPrint(coins[coin].name);
                // debugPrint(selected.contains(coins[coin]).toString());
                // debugPrint(coins[coin].toString());
              });
            },
            onTap: () => showDetails(coins[coin]),
          );
        },
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: coins.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selected.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favorites.saveAll(selected);
                clearSelected();
              },
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
