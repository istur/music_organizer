import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/receive_share_state.dart';
import 'package:share/share.dart';
// import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'AddAlbumScreen.dart';
import 'AlbumListScreen.dart';

class HomePageScreen extends StatefulWidget {
  HomePageScreen({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = "Music Organizer";

  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends ReceiveShareState<HomePageScreen> {
  final pages = [AlbumListType.Listen, AlbumListType.Vote];
  // final List<Map<String, Object>> _pages = [
  //   {
  //     'page': AlbumListType.Listen,
  //     'title': 'To Listen',
  //   },
  //   {
  //     'page': AlbumListType.Vote,
  //     'title': 'To Vote',
  //   },
  // ];

  int _selectedPageIndex = 0;

  static const platform = const MethodChannel('app.channel.shared.data');
  String dataShared;
  StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    enableShareReceiving();
    // registerIntentListener();
    // getSharedText();
  }

  getSharedText() async {
    var sharedData = await platform.invokeMethod("getSharedText");
    if (sharedData != null) {
      setState(() {
        Navigator.of(context)
            .pushNamed(AddAlbumScreen.routeName, arguments: sharedData);
      });
    }
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
      print(_selectedPageIndex);
    });
  }

  void _openAddAlbumScreen(BuildContext context) {
    Navigator.of(context).pushNamed(AddAlbumScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: getPage(_selectedPageIndex),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).accentColor,
        currentIndex: _selectedPageIndex,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.play_arrow),
            title: Text('To Listen'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            title: Text('To Vote'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddAlbumScreen(context),
        tooltip: 'Add Album',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget getPage(int selectedPageIndex) {
    return AlbumListScreen(type: pages[selectedPageIndex]);
  }

  void registerIntentListener() {
    // // For sharing or opening urls/text coming from outside the app while the app is in the memory
    // _intentDataStreamSubscription =
    //     ReceiveSharingIntent.getTextStream().listen((String value) {
    //   setState(() {
    //     print(value);
    //     Navigator.of(context)
    //         .pushNamed(AddAlbumScreen.routeName, arguments: value);
    //   });
    // }, onError: (err) {
    //   print("getLinkStream error: $err");
    // });

    //   // For sharing or opening urls/text coming from outside the app while the app is closed
    //   ReceiveSharingIntent.getInitialText().then((String value) {
    //     setState(() {
    //       print(value);
    //       Navigator.of(context)
    //           .pushNamed(AddAlbumScreen.routeName, arguments: value);
    //     });
    //   });
  }

  @override
  void dispose() {
    // _intentDataStreamSubscription.cancel();
    super.dispose();
  }

  @override
  void receiveShare(Share shared) {
    // TODO: implement receiveShare
    print(shared.toString());
    Navigator.of(context)
        .pushNamed(AddAlbumScreen.routeName, arguments: shared.title);
  }
}
