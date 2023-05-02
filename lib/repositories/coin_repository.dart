import '../models/coin.dart';

class CoinRepository {
  static List<Coin> coins = [
    Coin(
      name: 'Bitcoin',
      icon: 'assets/images/bitcoin.png',
      alias: 'BTC',
      price: 164603.00,
    ),
    Coin(
      name: 'Ethereum',
      icon: 'assets/images/ethereum.png',
      alias: 'ETH',
      price: 9716.00,
    ),
    Coin(
      name: 'Cardano',
      icon: 'assets/images/cardano.png',
      alias: 'CDN',
      price: 350.00,
    ),
    Coin(
      name: 'Dogecoin',
      icon: 'assets/images/dogecoin.png',
      alias: 'DGC',
      price: 0.03,
    ),
    Coin(
      name: 'XPR',
      icon: 'assets/images/xpr.png',
      alias: 'XPR',
      price: 321.12,
    ),
    Coin(
      name: 'Tether',
      icon: 'assets/images/tether.png',
      alias: 'TTH',
      price: 105.50,
    ),
    Coin(
      name: 'Chainlink',
      icon: 'assets/images/chainlink.png',
      alias: 'CLK',
      price: 22.39,
    ),
  ];
}
