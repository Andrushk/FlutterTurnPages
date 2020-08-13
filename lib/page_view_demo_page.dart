import 'package:flutter/material.dart';
import 'package:flutter_turn_pages/page3.dart';
import 'package:flutter_turn_pages/common/pages/page_base.dart';
import 'package:flutter_turn_pages/common/pages/turn_pages.dart';
import 'package:flutter_turn_pages/common/style/size.dart';
import 'package:flutter_turn_pages/page1.dart';
import 'package:flutter_turn_pages/page2.dart';

/// Листание при помощи PageView
class PageViewDemoPage extends PageBase {
  @override
  _PageViewDemoPageState createState() => _PageViewDemoPageState();
}

class _PageViewDemoPageState extends PageBaseState<PageViewDemoPage> with TurnPages {

  @override
  Widget buildAppBar() {
    return Container(height: FrSize.appBarBigHeight);
  }

  @override
  List<Widget> get pages => [Page1(), Page2(), Page3()];
}
