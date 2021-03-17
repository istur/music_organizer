import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:music_organizer/model/Album.dart';

class GroupAlbum with ChangeNotifier {
  List<Album> _items = [];

  List<Album> get items {
    return [..._items];
  }

  void addItem(Album album) {
    // inserire controllo
    var found = false;
    _items.forEach((element) {
      if (element.uri == album.uri) {
        found = true;
      }
    });
    if (!found) {
      _items.add(album);
      print(_items[0].bigImageUrl);
      notifyListeners();
    }
  }

  void removeItem(Album album) {
    _items.remove(album);
    notifyListeners();
  }
}
