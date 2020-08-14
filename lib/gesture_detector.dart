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
    RenderBox box = context.findRenderObject();

    return Stack(
      overflow: Overflow.visible,
      children: [
        bottomPage ?? Container(),
        StreamBuilder<int>(
          stream: controller.topPageNumber,
          builder: (context, snapshot) {
            return IndexedStack(
              children: children,
              index: snapshot.data ?? 0,
            );
          },
        ),
        StreamBuilder<FlyingPageData>(
          stream: controller.flyingPage,
          builder: (context, snapshot) {
            return snapshot.data == null
                ? Container()
                : Positioned(
                    left: snapshot.data.x,
                    top: 0,
                    width: box.size.width,
                    height: box.size.height,
                    child: Transform.rotate(
                      angle: snapshot.data.angle,
                      child: children[snapshot.data.pageIndex],
                    ),
                  );
          },
        ),
        GestureDetector(
          onHorizontalDragStart: (details) {
            controller.start(box.size, details.localPosition);
          },
          onHorizontalDragUpdate: (details) {
            controller.move(details.localPosition);
          },
          onHorizontalDragEnd: (details) {
            controller.cancel();
          },
          onHorizontalDragCancel: () {
            controller.cancel();
          },
        ),
      ],
    );
  }
}

class FlyingPageData {
  final double x;
  final double angle;
  final int pageIndex;

  FlyingPageData(this.x, this.angle, this.pageIndex);
}

const xSpeedFactor = 2.0;
const angleSpeedFactor = 6.0;

class HorizontalSwipeController {
  double _startAtX;
  double _sizeToSwitchX;
  double _position;
  int currentPage = 0;
  List<Widget> _items = [];

  final topPageNumberController = BehaviorSubject<int>();
  final flyingPageController = BehaviorSubject<FlyingPageData>();

  Stream<int> get topPageNumber => topPageNumberController.stream;

  Stream<FlyingPageData> get flyingPage => flyingPageController.stream;

  _setItems(List<Widget> items) {
    _items = items;
  }

  start(Size viewSize, Offset initialPosition) {
    _startAtX = initialPosition.dx;
    _sizeToSwitchX = viewSize.width / 2;
  }

  move(Offset currentPosition) {
    if (_startAtX == null || _sizeToSwitchX == null) return;
    final dx = currentPosition.dx - _startAtX;
    _position = (dx / _sizeToSwitchX).clamp(-1.0, 1.0);

    if (_position > 0) {
      flyingPageController.add(FlyingPageData(
        (dx - _sizeToSwitchX) * xSpeedFactor,
        (_position-1) / angleSpeedFactor,
        0,
      ));
    } else if (_position<0) {
      flyingPageController.add(FlyingPageData(
        dx * xSpeedFactor,
        _position / angleSpeedFactor,
        0,
      ));
    }

    //print('dx=$dx, offset = $_position');

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
    topPageNumberController.add(currentPage);
    print('next');
  }

  prevPage() {
    if (currentPage >= _items.length - 1) return;
    currentPage++;
    topPageNumberController.add(currentPage);
    print('prev');
  }

  cancel() {
    _startAtX = null;
    flyingPageController.add(null);
  }

  dispose() {
    topPageNumberController.close();
    flyingPageController.close();
  }
}

//todo вынести отсюда падинги в _HorizontalSwipeState
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
