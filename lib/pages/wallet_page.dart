import 'package:bitcoins_app/configs/app_settings.dart';
import 'package:bitcoins_app/models/position.dart';
import 'package:bitcoins_app/repositories/account_repository.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  int index = 0;
  double totalWallet = 0;
  double balance = 0;
  late NumberFormat real;
  late AccountRepository account;

  String graphLabel = '';
  double graphValue = 0;
  List<Position> wallet = [];

  @override
  Widget build(BuildContext context) {
    account = context.watch<AccountRepository>();
    final loc = context.read<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
    balance = account.balance;

    setTotalWallet();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 48, bottom: 8),
              child: Text(
                'Valor da carteira',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Text(
              real.format(totalWallet),
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w700,
                letterSpacing: -1.5,
              ),
            ),
            loadGraph(),
          ],
        ),
      ),
    );
  }

  setTotalWallet() {
    final List<Position> walletList = account.wallet;

    setState(() {
      totalWallet = account.balance;
      for (Position position in walletList) {
        totalWallet += position.coin.price * position.quantity;
      }
    });
  }

  loadWallet() {
    setGraphData(index);
    wallet = account.wallet;
    final int listSize = wallet.length + 1;

    return List.generate(listSize, (i) {
      final bool isTouched = i == index;
      final bool isBalance = i == listSize - 1;
      final double fontSize = isTouched ? 18.0 : 14.0;
      final double radius = isTouched ? 60.0 : 50.0;
      final Color? color =
          isTouched ? Colors.tealAccent : Colors.tealAccent[400];

      double percent = 0;
      if (!isBalance) {
        percent = wallet[i].coin.price * wallet[i].quantity / totalWallet;
      } else {
        percent = (account.balance > 0) ? account.balance / totalWallet : 0;
      }
      percent *= 100;

      return PieChartSectionData(
        color: color,
        value: percent,
        title: '${percent.toStringAsFixed(0)} %',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      );
    });
  }

  setGraphData(int index) {
    if (index < 0) return;
    if (index == wallet.length) {
      graphLabel = 'Saldo';
      graphValue = account.balance;
    } else {
      graphLabel = wallet[index].coin.name;
      graphValue = wallet[index].coin.price * wallet[index].quantity;
    }
  }

  loadGraph() {
    return (account.balance <= 0)
        ? SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 5,
                    centerSpaceRadius: 110,
                    sections: loadWallet(),
                    pieTouchData: PieTouchData(
                      touchCallback: (touch) => setState(() {
                        index = touch.touchedSection!.touchedSectionIndex;
                        setGraphData(index);
                      }),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    graphLabel,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                  Text(
                    real.format(graphValue),
                    style: const TextStyle(
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
