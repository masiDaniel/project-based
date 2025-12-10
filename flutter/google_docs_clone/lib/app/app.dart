import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_docs_clone/app/navigation/routes.dart';
import 'package:routemaster/routemaster.dart';

class GoogleDocsApp extends ConsumerStatefulWidget {
  const GoogleDocsApp({super.key});

  @override
  ConsumerState<GoogleDocsApp> createState() => _GoogleDocsAppState();
}

class _GoogleDocsAppState extends ConsumerState<GoogleDocsApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          return routesLoggedOut;
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
