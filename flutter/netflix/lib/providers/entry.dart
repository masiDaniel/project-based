import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:netflix/api/client.dart';
import 'package:netflix/data/entry.dart';

class EntryProvider extends ChangeNotifier {
  Map<String, Uint8List> _imageCache = {};

  static String _collectionId = "movies";

  Entry? _selected = null;
  Entry? get selected => _selected;

  Entry _featured = Entry.empty();
  Entry get featured => _featured;

  List<Entry> _entries = [];
  List<Entry> get entries => _entries;
  List<Entry> get originals =>
      _entries.where((e) => e.isOriginal == true).toList();
  List<Entry> get animations => _entries
      .where((e) => e.genres.toLowerCase().contains('animation'))
      .toList();
  List<Entry> get newReleases => _entries
      .where(
        (e) =>
            e.releaseDate != null &&
            e.releaseDate!.isAfter(DateTime.parse('2018-01-01')),
      )
      .toList();

  List<Entry> get trending {
    var trending = _entries;

    trending.sort((a, b) => b.trendingIndex.compareTo(a.trendingIndex));

    return trending;
  }

  void setSelected(Entry entry) {
    _selected = entry;

    notifyListeners();
  }

  Future<void> list() async {
    var result = await ApiClient.database.listDocuments(
      collectionId: _collectionId,
      databaseId: '692f65de000e3e9ce701',
    );

    // print("RAW DOCUMENTS: ${result.documents}");

    _entries = result.documents
        .map((document) => Entry.fromJson(document.data))
        .toList();

    // print("PARSED ENTRIES: $_entries");
    _featured = _entries.isEmpty ? Entry.empty() : _entries[0];

    notifyListeners();
  }

  Future<Uint8List> imageFor(Entry entry) async {
    if (entry.thumbnailImageId.isEmpty) {
      return Uint8List(0);
    }

    if (_imageCache.containsKey(entry.thumbnailImageId)) {
      return _imageCache[entry.thumbnailImageId]!;
    }

    try {
      final result = await ApiClient.storage.getFileView(
        fileId: entry.thumbnailImageId,
        bucketId: '692f7189002aefbbbfd9',
      );

      _imageCache[entry.thumbnailImageId] = result;

      return result;
    } catch (e) {
      rethrow;
    }
  }
}
