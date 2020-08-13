import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_turn_pages/common/pages/page_base.dart';
import 'package:flutter_turn_pages/common/pages/simple_page.dart';
import 'package:flutter_turn_pages/common/style/colors.dart';
import 'package:flutter_turn_pages/common/style/padding.dart';
import 'package:flutter_turn_pages/common/style/size.dart';
import 'package:flutter_turn_pages/page1.dart';
import 'package:flutter_turn_pages/page2.dart';
import 'package:flutter_turn_pages/page3.dart';
import 'package:rxdart/rxdart.dart';

class HorizontalSwipe extends PageBase {
  @override
  _HorizontalSwipeState createState() => _HorizontalSwipeState();
}

class _HorizontalSwipeState extends PageBaseState<HorizontalSwipe>
    with SimplePage {
  final _controller = HorizontalSwipeController();

  @override
  Widget buildAppBar(BuildContext context) {
    return SafeArea(
      child: Row(
        children: [BackButton()],
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return SwipeStack(
      controller: _controller,
      children: [
        wrapPage(Page1()),
        wrapPage(Page2()),
        wrapPage(Page3()),
      ],
      bottomPage: bottomPage(),
    );
  }

  Widget wrapPage(Widget page) => Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: PageCard(child: page),
      );

  Widget bottomPage() => Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Transform.rotate(
          child: PageCard(child: Container()),
          angle: -.05,
        ),
      );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

//todo если HorizontalSwipeController создан внутри, то надо его диспозить
class SwipeStack extends StatelessWidget {
  final HorizontalSwipeController controller;
  final List<Widget> children;
  final Widget bottomPage;

  SwipeStack(
      {this.controller, this.children = const <Widget>[], this.bottomPage}) {
    controller._setItems(children);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        bottomPage ?? Container(),
        StreamBuilder<int>(
          stream: controller.pageNumber,
          builder: (context, snapshot) {
            return IndexedStack(
              children: children,
              index: snapshot.data ?? 0,
            );
          },
        ),
        GestureDetector(
          onHorizontalDragStart: (details) {
            RenderBox box = context.findRenderObject();
            controller.start(box.size, details.localPosition);
          },
          onHorizontalDragUpdate: (details) {
            controller.move(details.localPosition);
          },
          onHorizontalDragCancel: () {
            controller.cancel();
          },
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}

class HorizontalSwipeController {
  double _startAtX;
  double _sizeToSwitchX;
  double _position;
  int currentPage = 0;
  List<Widget> _items = [];

  final pageNumberController = BehaviorSubject<int>();

  Stream<int> get pageNumber => pageNumberController.stream;

  _setItems(List<Widget> items) {
    _items = items;
  }

  start(Size viewSize, Offset initialPosition) {
    _startAtX = initialPosition.dx;
    _sizeToSwitchX = viewSize.width / 2;
  }

  move(Offset currentPosition) {
    if (_startAtX == null || _sizeToSwitchX == null) return;
    _position =
        ((currentPosition.dx - _startAtX) / _sizeToSwitchX).clamp(-1.0, 1.0);

    //print('offset = $_position');

    if (_position >= 1) {
      cancel();
      nextPage();
    }

    if (_position <= -1) {
      cancel();
      prevPage();
    }
  }

  nextPage() {
    if (currentPage <= 0) return;
    currentPage--;
    pageNumberController.add(currentPage);
    print('next');
  }

  prevPage() {
    if (currentPage >= _items.length - 1) return;
    currentPage++;
    pageNumberController.add(currentPage);
    print('prev');
  }

  cancel() {
    _startAtX = null;
  }

  dispose() {
    pageNumberController.close();
  }
}

class PageCard extends StatelessWidget {
  final Widget child;

  const PageCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Container(
        child: child,
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: FrPadding.verticalCardPadding,
              color: FrColors.cardShadow,
            ),
          ],
          borderRadius: FrSize.cardRadius,
        ),
      ),
      padding: const EdgeInsets.only(
        left: FrPadding.horizontalCardPadding,
        right: FrPadding.horizontalCardPadding,
        top: FrPadding.verticalCardPadding + 100,
        bottom: FrPadding.verticalCardPadding + 10,
      ),
    );
  }
}
