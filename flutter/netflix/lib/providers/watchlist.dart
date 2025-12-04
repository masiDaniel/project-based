import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:netflix/api/client.dart';
import 'package:netflix/data/entry.dart';

class WatchListProvider extends ChangeNotifier {
  final String _collectionId = "watchlists";

  List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  Future<User> get user async {
    return await ApiClient.account.get();
  }

  Future<List<Entry>> list() async {
    final user = await this.user;
    final watchlist = await ApiClient.database.listDocuments(
      databaseId: "692f65de000e3e9ce701",
      collectionId: _collectionId,
    );

    final movieIds = watchlist.documents
        .map((document) => document.data['movieId'])
        .toList();

    final entries = (await ApiClient.database.listDocuments(
      databaseId: "692f65de000e3e9ce701",
      collectionId: "movies",
    )).documents.map((document) => Entry.fromJson(document.data)).toList();

    final filtered = entries
        .where((entry) => movieIds.contains(entry.id))
        .toList();
    _entries = filtered;

    notifyListeners();

    return _entries;
  }

  Future<void> add(Entry entry) async {
    final user = await this.user;
    var result = await ApiClient.database.createDocument(
      databaseId: "692f65de000e3e9ce701",
      collectionId: _collectionId,
      documentId: 'unique()',
      data: {
        "userId": user.$id,
        "movieId": entry.id,
        // "createdAt": (DateTime.now().second / 1000).round(),
      },
    );
    print(result.data);

    _entries.add(Entry.fromJson(result.data));
    list();
  }

  Future<void> remove(Entry entry) async {
    final user = await this.user;
    final result = await ApiClient.database.listDocuments(
      databaseId: "692f65de000e3e9ce701",
      collectionId: _collectionId,
      queries: [
        Query.equal("userId", user.$id),
        Query.equal("movieId", entry.id),
      ],
    );

    final id = result.documents.first.$id;

    await ApiClient.database.deleteDocument(
      databaseId: "692f65de000e3e9ce701",
      collectionId: _collectionId,
      documentId: id,
    );

    list();
  }

  Future<Uint8List> imageFor(Entry entry) async {
    return await ApiClient.storage.getFileView(
      fileId: entry.thumbnailImageId,
      bucketId: "692f7189002aefbbbfd9",
    );
  }

  bool isOnList(Entry entry) => _entries.any((e) => e.id == entry.id);
}
