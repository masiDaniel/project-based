import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:netflix/data/entry.dart';
import 'package:netflix/providers/entry.dart';
import 'package:netflix/providers/watchlist.dart';
import 'package:netflix/screens/details.dart';
import 'package:netflix/widgets/buttons/icon.dart';
import 'package:provider/provider.dart';

class ContentHeader extends StatelessWidget {
  final Entry featured;
  const ContentHeader({super.key, required this.featured});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: context.read<EntryProvider>().imageFor(featured),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox(
            height: 500,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            // Background Image
            Container(
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: Image.memory(snapshot.data!).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Gradient overlay
            Container(
              height: 500,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),

            // Title
            Positioned(
              bottom: 120,
              child: SizedBox(
                width: 250,
                child: Text(
                  featured.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Tags
            Positioned(
              bottom: 88,
              child: SizedBox(
                width: 250,
                child: Text(
                  featured.tags.replaceAll(", ", " · "),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),

            // Action buttons
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Spacer(),
                  VerticalIconButton(
                    icon: context.read<WatchListProvider>().isOnList(featured)
                        ? Icons.check
                        : Icons.add,
                    title: 'Watchlist',
                    tap: () {
                      final watchlist = context.read<WatchListProvider>();
                      if (watchlist.isOnList(featured)) {
                        watchlist.remove(featured);
                      } else {
                        watchlist.add(featured);
                      }
                    },
                  ),
                  const SizedBox(width: 40),
                  MaterialButton(
                    color: Colors.white,
                    child: Row(
                      children: const [Icon(Icons.play_arrow), Text("Play")],
                    ),
                    onPressed: () {},
                  ),
                  const SizedBox(width: 40),
                  VerticalIconButton(
                    icon: Icons.info,
                    title: "Info",
                    tap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => DetailsScreen(entry: featured),
                      );
                    },
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
