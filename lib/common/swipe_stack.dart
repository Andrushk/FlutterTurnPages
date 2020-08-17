import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// На сколько скорость изменения параметра больше скорости движения пальца
const xSpeedFactor = 2.0;
const angleSpeedFactor = 6.0;

/// Колода карточек, которые можно листать смахиванием вправо-влево
/// На верху карточка с индексом - 0, чем больше индекс, тем глубже карточка.
/// Свайп влево - смахиваем вернюю карточку и переходим к более "глубокой".
/// Свайп вправо - возвращаем карточку на верх колоды.
class SwipeStack extends StatefulWidget {
  final HorizontalSwipeController controller;
  final List<Widget> children;
  final Widget bottomPage;

  SwipeStack({
    HorizontalSwipeController controller,
    this.children: const <Widget>[],
    this.bottomPage,
  }) : this.controller = controller ?? HorizontalSwipeController();

  @override
  _SwipeStackState createState() => _SwipeStackState();
}

class _SwipeStackState extends State<SwipeStack> {
  @override
  void initState() {
    super.initState();
    widget.controller._setItems(widget.children);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        widget.bottomPage ?? Container(),
        StreamBuilder<int>(
          stream: widget.controller.topPageNumber,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? IndexedStack(
                    children: widget.children,
                    index: snapshot.data,
                  )
                : Container();
          },
        ),
        StreamBuilder<FlyingPageData>(
          stream: widget.controller.flyingPage,
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
                      child: widget.children[pageData.pageIndex],
                    ),
                  );
          },
        ),
        GestureDetector(
          onHorizontalDragStart: (details) {
            RenderBox box = context.findRenderObject();
            widget.controller.startDrag(box.size, details.localPosition);
          },
          onHorizontalDragUpdate: (details) {
            widget.controller.updateDrag(details.localPosition);
          },
          onHorizontalDragEnd: (details) {
            widget.controller.dragCancel();
          },
          onHorizontalDragCancel: () {
            widget.controller.dragCancel();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
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

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => pageIndex * 10000 + left.truncate() * 10;
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

class HorizontalSwipeController {
  StartDragData _startData;
  int topPageIndex = 0;
  List<Widget> _items = [];

  final topPageNumberController = BehaviorSubject<int>();
  final flyingPageController = BehaviorSubject<FlyingPageData>();

  Stream<int> get topPageNumber => topPageNumberController.distinct();
  Stream<FlyingPageData> get flyingPage => flyingPageController.distinct();

  _setItems(List<Widget> items) {
    _items = items;
    //todo можно запоминать страницу и после обновления списка позиционироваться на ней
    if (_items != null && _items.length > 0) topPageNumberController.add(0);
  }

  startDrag(Size viewSize, Offset initialPosition) {
    _startData = StartDragData(
      startX: initialPosition.dx,
      boxWidth: viewSize.width,
      boxHeight: viewSize.height,
      pageIndex: topPageIndex,
    );
  }

  updateDrag(Offset currentPosition) {
    if (_startData == null) return;

    final dx = _startData.dx(currentPosition.dx);
    final deviation = (dx / _startData.halfWidth).clamp(-1.0, 1.0);

    notifyGui({int topPage, int flyPage, double left, double angle}) {
      topPageNumberController.add(topPage);
      flyingPageController
          .add(FlyingPageData(_startData, left, angle, flyPage));
    }

    // тащим вправо (листание к вершине списка, нулевой индекс)
    if (deviation > 0) {
      if (noHigher) {
        var limited = deviation.clamp(0, 0.1);
        notifyGui(
          topPage: noBelow ? null : topPageIndex + 1,
          flyPage: 0,
          left: limited * _startData.halfWidth * xSpeedFactor,
          angle: limited / angleSpeedFactor,
        );
      } else {
        notifyGui(
          topPage: topPageIndex,
          flyPage: topPageIndex - 1,
          left: (dx - _startData.halfWidth) * xSpeedFactor,
          angle: (deviation - 1) / angleSpeedFactor,
        );
      }
    }

    // тащим влево (листание к дну списка)
    if (deviation < 0) {
      if (noBelow) {
        var limited = deviation.clamp(-0.1, 0);
        notifyGui(
          topPage: null,
          flyPage: topPageIndex,
          left: limited * _startData.halfWidth * xSpeedFactor,
          angle: limited / angleSpeedFactor,
        );
      } else {
        notifyGui(
          topPage: topPageIndex + 1,
          flyPage: topPageIndex,
          left: dx * xSpeedFactor,
          angle: deviation / angleSpeedFactor,
        );
      }
    }

    if (deviation >= 1) {
      dragCancel();
      _pageUp();
    }

    if (deviation <= -1) {
      dragCancel();
      _pageDown();
    }
  }

  dragCancel() {
    topPageNumberController.add(topPageIndex);
    _startData = null;
    flyingPageController.add(null);
  }

  bool get noHigher => topPageIndex <= 0;

  bool get noBelow => topPageIndex >= _items.length - 1;

  _pageUp() {
    if (noHigher) return;
    topPageIndex--;
    topPageNumberController.add(topPageIndex);
  }

  _pageDown() {
    if (noBelow) return;
    topPageIndex++;
    topPageNumberController.add(topPageIndex);
  }

  dispose() {
    topPageNumberController.close();
    flyingPageController.close();
  }
}
