import 'package:flutter/material.dart';
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
              child: Text('PageView turn pages'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PageViewDemoPage()));
              },
            ),
            RaisedButton(
              child: Text('Stack turn pages'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StackDemoPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
