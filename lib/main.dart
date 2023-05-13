import 'package:bitcoins_app/configs/app_settings.dart';
import 'package:bitcoins_app/repositories/account_repository.dart';
import 'package:bitcoins_app/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'configs/hive_config.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountRepository()),
        ChangeNotifierProvider(create: (context) => AppSettings()),
        ChangeNotifierProvider(create: (context) => FavoritesRepository()),
      ],
      child: const MyApp(),
    ),
  );
}
