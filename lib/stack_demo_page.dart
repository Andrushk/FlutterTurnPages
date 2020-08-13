import 'package:flutter/material.dart';
import 'package:flutter_turn_pages/Page3.dart';
import 'package:flutter_turn_pages/common/pages/stack_no_gestures_page.dart';
import 'package:flutter_turn_pages/page1.dart';
import 'package:flutter_turn_pages/page2.dart';

import 'common/pages/page_base.dart';
import 'common/style/size.dart';

/// Листание при помощи стэка
class StackDemoPage extends PageBase {
  @override
  _StackDemoPageState createState() => _StackDemoPageState();
}

class _StackDemoPageState extends PageBaseState<StackDemoPage> with StackNoGesturesPage {
  @override
  Widget buildAppBar() {
    return Container(
      height: FrSize.appBarBigHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveLeft();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              moveRight();
            },
          ),
        ],
      ),
    );
  }

  @override
  List<Widget> get pages => [Page1(), Page2(), Page3()];
}
