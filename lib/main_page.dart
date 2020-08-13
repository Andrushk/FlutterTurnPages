import 'package:flutter/material.dart';
import 'package:flutter_turn_pages/demo.dart';
import 'package:flutter_turn_pages/gesture_detector.dart';
import 'package:flutter_turn_pages/page_view_demo_page.dart';
import 'package:flutter_turn_pages/stack_demo_page.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RaisedButton(
              child: Text('Перелистывание через PageView'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PageViewDemoPage()));
              },
            ),
            RaisedButton(
              child: Text('Перелистыание через Stack без жестов'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StackDemoPage()));
              },
            ),
            RaisedButton(
              child: Text('Перелистыание через Stack с жестами'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HorizontalSwipe()));
              },
            ),
            RaisedButton(
              child: Text('пример со StackOverflow'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
