import 'package:flutter/material.dart';
import 'package:netflix/providers/entry.dart';
import 'package:provider/provider.dart';

import '../widgets/content/bar.dart';
import '../widgets/content/header.dart';
import '../widgets/content/list.dart';
import '../widgets/previews.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _scrollOffset = 0.0;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });

    // Fetch entries after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EntryProvider>().list();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final provider = context.watch<EntryProvider>();
    final featured = provider.featured;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 70.0),
        child: ContentBar(scrollOffset: _scrollOffset),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ContentHeader(
              key: ValueKey(featured.id), // ensures rebuild on change
              featured: featured,
            ),
          ),
          const SliverPadding(
            padding: EdgeInsets.only(top: 20),
            sliver: SliverToBoxAdapter(
              child: Previews(
                key: PageStorageKey('previews'),
                title: 'Previews',
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: ContentList(
                title: 'Only on PK Netflix',
                contentList: provider.entries,
                isOriginal: false,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: ContentList(
              title: 'New releases',
              contentList: provider.originals,
              isOriginal: true,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 20),
            sliver: SliverToBoxAdapter(
              child: ContentList(
                title: 'Animation',
                contentList: provider.animations,
                isOriginal: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
