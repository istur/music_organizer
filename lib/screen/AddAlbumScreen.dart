import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_organizer/model/Album.dart';
import 'package:music_organizer/providers/GroupAlbum.dart';
import 'package:music_organizer/widget/AlbumWidget.dart';
import 'package:provider/provider.dart';

class AddAlbumScreen extends StatefulWidget {
  static const routeName = "/addalbum";
  static const title = "Add Album";

  @override
  _AddAlbumScreenState createState() => _AddAlbumScreenState();
}

class _AddAlbumScreenState extends State<AddAlbumScreen> {
  Future<List<Album>> futureAlbums;
  var groupAlbum;

  final searchController = new TextEditingController();
  TextField searchTextField;

  @override
  void initState() {
    super.initState();
    groupAlbum = Provider.of<GroupAlbum>(context, listen: false);
    searchTextField = new TextField(
      style: TextStyle(color: Colors.white),
      decoration: new InputDecoration(
        prefixIcon: new Icon(
          Icons.search,
          color: Colors.white,
        ),
        hintText: 'Search...',
        hintStyle: TextStyle(color: Colors.white),
      ),
      controller: searchController,
      onSubmitted: (text) => doAlbumSearch(text),
    );
    // searchController.addListener(doAlbumSearch);
  }

  void doAlbumSearch(String text) {
    setState(() {
      futureAlbums = fetchSpotifyAlbums(text);
    });
  }

  void _clickedFunction(Album album, BuildContext context) {
    groupAlbum.addItem(album);
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added item to cart!!!',
        ),
        duration: Duration(seconds: 2),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            groupAlbum.removeItem(album);
          },
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: searchTextField,
    );
  }

  Widget getFutureBuilder() {
    return FutureBuilder(
      future: futureAlbums,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Album> albumList = snapshot.data;
          return Column(children: <Widget>[
            ...albumList
                .map((album) => AlbumWidget(album, _clickedFunction))
                .toList()
          ]);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final initString = ModalRoute.of(context).settings.arguments as String;
    if (initString != null) {
      searchController.text = initString;
      doAlbumSearch(initString);
    }
    return Scaffold(
      appBar: _buildBar(context),
      body: SingleChildScrollView(
          child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: getFutureBuilder())),
    );
  }

  // Widget buildWaitWidget() {
  //   if(futureAlbum==null){
  //     return CircularProgressIndicator();
  //   } else {
  //     return Text(futureAlbum.);
  //   }

  // }

  Future<String> getAuthCode() async {
    final clientCode =
        "Basic ZTYzODlmYjJmZGEzNDc4MjlhNmYwZTJkMjBiODZjZjk6YzZkODczZjNlMTg1NDc5OGJhN2UyZTRmNjU1NTk0MmM=";
    final response = await http.post('https://accounts.spotify.com/api/token',
        headers: {'Authorization': clientCode},
        body: {'grant_type': 'client_credentials'});
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      String authCode = data["access_token"];
      print(authCode);
      return authCode;
    } else {
      throw Exception('Failed to call Spotify Auth');
    }
  }

  Future<List<Album>> fetchSpotifyAlbums(String query) async {
    final String authCode = await getAuthCode();
    if (authCode != null) {
      final response = await http.get(
          'https://api.spotify.com/v1/search?q=$query&type=album',
          headers: {'Authorization': "Bearer $authCode"});
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        print(response.body);
        String name = data["albums"]["items"][0]["name"];
        print(name);
        List<dynamic> items = data["albums"]["items"];
        List<Album> albumRetrieved = new List();
        for (var i = 0; i < items.length; i++) {
          albumRetrieved.add(Album.fromJson(items[i]));
        }
        return albumRetrieved;
      } else {
        throw Exception('Failed to call Spotify Auth cause ${response.body}');
      }
    }
  }

  Future<Album> fetchAlbum() async {
    final response =
        await http.get('https://jsonplaceholder.typicode.com/albums/1');

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }
}
