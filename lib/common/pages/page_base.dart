import 'package:flutter/material.dart';

/// Базовая страница.
abstract class PageBase extends StatefulWidget {
  PageBase({Key key}) : super(key: key);
}

abstract class PageBaseState<Page extends PageBase> extends State<Page> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
}
