import 'package:bitcoins_app/models/coin.dart';
import 'package:bitcoins_app/pages/coins_details_page.dart';
import 'package:bitcoins_app/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CoinCard extends StatefulWidget {
  final Coin coin;

  const CoinCard({super.key, required this.coin});

  @override
  State createState() => _CoinCardState();
}

class _CoinCardState extends State<CoinCard> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');

  static Map<String, Color> priceColor = <String, Color>{
    'up': Colors.teal,
    'down': Colors.indigo,
  };

  openDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CoinsDetailsPage(coin: widget.coin),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        onTap: () => openDetails(),
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: [
              Image.asset(
                widget.coin.icon,
                height: 40,
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.coin.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.coin.alias,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  color: priceColor['down']!.withOpacity(0.05),
                  border: Border.all(
                    color: priceColor['down']!.withOpacity(0.4),
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  real.format(widget.coin.price),
                  style: TextStyle(
                    fontSize: 16,
                    color: priceColor['down'],
                    letterSpacing: -1,
                  ),
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      title: const Text('Remover favorito'),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<FavoritesRepository>(context, listen: false)
                            .remove(widget.coin);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
