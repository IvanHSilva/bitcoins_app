import 'package:flutter/material.dart';

import 'coins_page.dart';
import 'configurations_page.dart';
import 'favorites_page.dart';
import 'wallet_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int actualPage = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: actualPage);
  }

  setActualPage(page) {
    setState(() {
      actualPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: setActualPage,
        children: const [
          CoinsPage(),
          FavoritesPage(),
          WalletPage(),
          ConfigurationsPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: actualPage,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Todas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favoritas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Carteira',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
        onTap: (page) {
          pageController.animateToPage(
            page,
            duration: const Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
        backgroundColor: Colors.blue[50],
      ),
    );
  }
}
