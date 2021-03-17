import 'package:flutter/material.dart';
import 'package:music_organizer/providers/GroupAlbum.dart';
import 'package:music_organizer/widget/AlbumWidget.dart';
import 'package:provider/provider.dart';

class AlbumListScreen extends StatelessWidget {
  final AlbumListType type;

  AlbumListScreen({this.type});

  @override
  Widget build(BuildContext context) {
    print(type);
    return type == AlbumListType.Listen
        ? Consumer<GroupAlbum>(
            builder: (ctx, groupAlbum, _) => groupAlbum.items.length > 0
                ? ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: groupAlbum.items.length,
                    itemBuilder: (ctx, i) => AlbumWidget(
                      groupAlbum.items[i],
                      () => {
                        //TODO
                      },
                    ),
                  )
                : Center(
                    child: Text("Lista vuota"),
                  ),
          )
        : Center(child: Text("Qui inseriremo la lista degli album da votare"));
  }
}

enum AlbumListType {
  Listen,
  Vote,
}
