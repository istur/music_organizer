import 'package:flutter/material.dart';
import 'package:music_organizer/model/Album.dart';

class AlbumWidget extends StatelessWidget {
  final Album album;
  final Function clickedAlbum;

  AlbumWidget(this.album, this.clickedAlbum);

  @override
  Widget build(BuildContext context) {
    double cardWidth = 320;
    return InkWell(
      onTap: () => clickedAlbum(album, context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(20),
        child: Container(
          width: cardWidth,
          height: 200,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Image.network(
                  album.bigImageUrl,
                  width: 400,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                width: cardWidth,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Container(
                    color: Colors.black54,
                    padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    child: Text(
                      album.name,
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
