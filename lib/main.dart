import 'package:flutter/material.dart';
import 'package:music_organizer/providers/GroupAlbum.dart';
import 'package:provider/provider.dart';

import 'screen/AddAlbumScreen.dart';
import 'screen/HomePageScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupAlbum>(
        create: (context) => GroupAlbum(),
        child: MaterialApp(
          title: 'Music Organizer',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.teal,
            accentColor: Colors.amber,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          // home: MyHomePage(title: 'Music Organizer'),
          initialRoute: '/',
          routes: {
            '/': (ctx) => HomePageScreen(),
            AddAlbumScreen.routeName: (ctx) => AddAlbumScreen(),
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (ctx) => HomePageScreen(),
            );
          },
        ));
  }
}
