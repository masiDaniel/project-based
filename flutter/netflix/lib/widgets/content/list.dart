import 'package:flutter/material.dart';
import 'package:netflix/data/entry.dart';
import 'package:netflix/providers/entry.dart';
import 'package:netflix/screens/details.dart';
import 'package:provider/provider.dart';

class ContentList extends StatelessWidget {
  final String title;
  final List<Entry> contentList;
  final bool isOriginal;
  final bool _rounded;

  const ContentList({
    super.key,
    required this.title,
    required this.contentList,
    required this.isOriginal,
    bool rounded = false,
  }) : _rounded = rounded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0, bottom: 10, top: 20),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: contentList.length,
            itemBuilder: (context, int count) {
              final Entry current = contentList[count];
              return GestureDetector(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => DetailsScreen(entry: current),
                  );
                },
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  child: FutureBuilder(
                    future: context.read<EntryProvider>().imageFor(current),
                    builder: (context, snapshot) => snapshot.hasData
                        ? Image.memory(snapshot.data!, fit: BoxFit.cover)
                        : Container(color: Colors.black),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
