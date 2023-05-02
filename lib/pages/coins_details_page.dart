import 'package:flutter/material.dart';

import '../models/coin.dart';

class CoinsDetailsPage extends StatefulWidget {
  final Coin coin;

  const CoinsDetailsPage({super.key, required this.coin});

  @override
  State<CoinsDetailsPage> createState() => _CoinsDetailsPageState();
}

class _CoinsDetailsPageState extends State<CoinsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const Divider(),
          Row(
            children: [
              SizedBox(
                child: Image.asset(widget.coin.icon),
                width: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
