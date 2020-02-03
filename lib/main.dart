import 'package:InstantChat/ui/chatScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          iconTheme: IconThemeData(
            color: Colors.deepPurpleAccent
          ),
          primarySwatch: Colors.blue,
        ),
        home: ChatScreen());
  }
}
