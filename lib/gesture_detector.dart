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
            final pageData = snapshot.data;
            return pageData == null
                ? Container()
                : Positioned(
                    left: pageData.left,
                    top: 0,
                    width: pageData.width,
                    height: pageData.height,
                    child: Transform.rotate(
                      angle: pageData.angle,
                      child: children[pageData.pageIndex],
                    ),
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

/// Состоняие страницы, которую в данный момент тянут
class FlyingPageData {
  final StartDragData startData;
  final double left;
  final double angle;
  final int pageIndex;

  double get width => startData.boxWidth;

  double get height => startData.boxHeight;

  FlyingPageData(
    this.startData,
    this.left,
    this.angle,
    this.pageIndex,
  );
}

/// Состоние на момент начала перетаскивания
class StartDragData {
  final double startX;
  final double boxWidth;
  final double boxHeight;
  final double halfWidth;
  final int pageIndex;

  StartDragData({this.startX, this.boxWidth, this.boxHeight, this.pageIndex})
      : halfWidth = boxWidth / 2;

  double dx(double currentX) => currentX - startX;
}

const xSpeedFactor = 2.0;
const angleSpeedFactor = 6.0;

class HorizontalSwipeController {
  StartDragData _startData;
  int currentPageIndex = 0;
  List<Widget> _items = [];

  final topPageNumberController = BehaviorSubject<int>();
  final flyingPageController = BehaviorSubject<FlyingPageData>();

  Stream<int> get topPageNumber => topPageNumberController.stream;

  Stream<FlyingPageData> get flyingPage => flyingPageController.stream;

  _setItems(List<Widget> items) {
    _items = items;
  }

  start(Size viewSize, Offset initialPosition) {
    _startData = StartDragData(
      startX: initialPosition.dx,
      boxWidth: viewSize.width,
      boxHeight: viewSize.height,
      pageIndex: currentPageIndex,
    );
  }

  move(Offset currentPosition) {
    if (_startData == null) return;

    final dx = _startData.dx(currentPosition.dx);
    final deviation = (dx / _startData.halfWidth).clamp(-1.0, 1.0);

    // тащим вправо
    if (deviation > 0) {
      var flyPageIdx = currentPageIndex - 1;
      // слева еще есть траницы
      if (flyPageIdx >= 0) {
        flyingPageController.add(
          FlyingPageData(
            _startData,
            (dx - _startData.halfWidth) * xSpeedFactor,
            (deviation - 1) / angleSpeedFactor,
            flyPageIdx,
          ),
        );
      } else {
        // уже смотрим на последнюю станицу и больше слева ничего нет
        var vp = deviation.clamp(0, 0.1) * _startData.halfWidth;

        flyingPageController.add(
          FlyingPageData(
            _startData,
            vp * xSpeedFactor,
            deviation.clamp(0, 0.1) / angleSpeedFactor,
            0,
          ),
        );
      }
    } else if (deviation < 0) {
      flyingPageController.add(FlyingPageData(
        _startData,
        dx * xSpeedFactor,
        deviation / angleSpeedFactor,
        0,
      ));
    }

    //print('dx=$dx, offset = $_position');

    if (deviation >= 1) {
      cancel();
      nextPage();
    }

    if (deviation <= -1) {
      cancel();
      prevPage();
    }
  }

  nextPage() {
    if (currentPageIndex <= 0) return;
    currentPageIndex--;
    topPageNumberController.add(currentPageIndex);
    print('next');
  }

  prevPage() {
    if (currentPageIndex >= _items.length - 1) return;
    currentPageIndex++;
    topPageNumberController.add(currentPageIndex);
    print('prev');
  }

  cancel() {
    _startData = null;
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
