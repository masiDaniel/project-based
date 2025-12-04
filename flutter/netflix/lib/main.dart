import 'package:flutter/material.dart';
import 'package:netflix/providers/account.dart';
import 'package:netflix/providers/entry.dart';
import 'package:netflix/providers/watchlist.dart';
import 'package:netflix/screens/navigation.dart';
import 'package:netflix/screens/onboarding.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => EntryProvider()),
        ChangeNotifierProvider(create: (context) => WatchListProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netflix',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: context.read<AccountProvider>().isValid(),
        builder: (context, snapshot) {
          final accountProvider = context.watch<AccountProvider>();

          return accountProvider.session == null
              ? const OnboardingScreen()
              : const NavScreen();
        },
      ),
    );
  }
}
