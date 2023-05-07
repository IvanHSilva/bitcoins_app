import 'package:bitcoins_app/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/coin_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moedas Favoritas'),
      ),
      body: Container(
        color: Colors.indigo.withOpacity(0.05),
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12.0),
        child: Consumer<FavoritesRepository>(
          builder: (context, favorites, child) {
            return favorites.favorites.isEmpty
                ? const ListTile(
                    leading: Icon(Icons.star),
                    title: Text(
                      'Sem favoritas',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ListView.builder(
                    itemCount: favorites.favorites.length,
                    itemBuilder: (_, index) {
                      return CoinCard(coin: favorites.favorites[index]);
                    },
                  );
          },
        ),
      ),
    );
  }
}
