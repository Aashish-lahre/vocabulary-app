import 'dart:math';

import 'package:flutter/material.dart';

class DraggableSlider extends StatefulWidget {
  final Widget widget;
  final bool isEnableDrag;
  final void Function({required double angle, required Offset endOffset}) slideOut;
  const DraggableSlider({required this.widget, this.isEnableDrag = true, required this.slideOut, super.key});

  @override
  State<DraggableSlider> createState() => _DraggableSliderState();
}

class _DraggableSliderState extends State<DraggableSlider> with SingleTickerProviderStateMixin {
  final GlobalKey _widgetKey = GlobalKey();
  Offset _startOffset = Offset.zero;
  Offset _endOffset = Offset.zero;
  double _angle = 0;
  late AnimationController _restoreController;
  late Size screenSize;
  Size slideSize = Size.zero;
  late Offset initialSlideTopLeftPosition;
  late Offset initialSlideTopRightPosition;



  // left limit to remove the magazine
  double get outSizeLimitLeft => -50;
  // right limit to remove the magazine
  double get outSizeLimitRight => screenSize.width + 50;

  @override
  void initState() {
    _restoreController = AnimationController(vsync: this, duration: Duration(milliseconds: 300))..addListener(animationListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getChildSize();
      getInitialSlideTopLeftPosition();
      screenSize = MediaQuery.of(context).size;
    });
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }


  void getChildSize() {
    slideSize = (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size ?? Size.zero;
  }

  void getInitialSlideTopLeftPosition() {
    final renderBox = (_widgetKey.currentContext?.findRenderObject() as RenderBox?);
    initialSlideTopLeftPosition = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  void getInitialSlideTopRightPosition() {
    final renderBox = (_widgetKey.currentContext?.findRenderObject() as RenderBox?);
    initialSlideTopRightPosition = renderBox?.localToGlobal(Offset(renderBox.size.width, 0)) ?? Offset.zero;
  }

  void animationListener() {
    if(_restoreController.isCompleted) {
      _restoreController.reset();
      _angle = 0;
      _startOffset = Offset.zero;
      _endOffset = Offset.zero;
    }
  }


  Offset get getCurrentTopLeftPosition {
    // 1. localToGlobal(Offset.zero) means widget's screen position of widgets top-left corner.
    // 2. localToGlobal(renderBox.size.center(Offset.zero)) means widget's screen position of widgets center.
    //    we use Offset.zero again because center(Offset) requires a reference point to calculate center point.
    // 3. localToGlobal(Offset(widgetWidth * .6, widgetHeight * .3)) means widget's screen position of
    //    widgets 60 percent of width point and 30 percent of height point offset's position.

    final renderBox = (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.localToGlobal(Offset.zero);
    return renderBox ?? Offset.zero;

  }

  Offset get getCurrentTopRightPosition {
    final renderBox = (_widgetKey.currentContext?.findRenderObject() as RenderBox?);
    return renderBox?.localToGlobal(Offset(renderBox.size.width, 0)) ?? Offset.zero;
  }





  // double get getAngle {
  //   return getCurrentPosition.dx < initialSlideTopLeftPosition.dx ?  ((pi * 0.1) * (getCurrentPosition.dx + slideSize.width - screenSize.width)/slideSize.width)
  //       : getCurrentPosition.dx + slideSize.width > screenSize.width ? (pi * 0.1) * (getCurrentPosition.dx + slideSize.width - screenSize.width)/slideSize.width
  //       : 0;
  // }

  double get getAngle {
    if (slideSize == Size.zero || screenSize == Size.zero) return 0;

    double dx = getCurrentTopLeftPosition.dx;
    double centerX = dx + (slideSize.width / 2);
    double screenCenterX = screenSize.width / 2;

    // Calculate angle based on the center position relative to screen center
    double angle = (pi * 0.1) * ((centerX - screenCenterX) / screenCenterX);

    return angle;
  }

  double radiansToDegrees(double radians) {
    return radians * (180 / pi);
  }

  void onPanStart(DragStartDetails details) {
    setState(() {
      _startOffset = details.localPosition;
    });

  }
  void onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _endOffset = details.localPosition - _startOffset;
    });


  }
  void onPanEnd(DragEndDetails end) {
    double leftX = getCurrentTopLeftPosition.dx;
    double rightX = getCurrentTopRightPosition.dx;

    if (leftX < outSizeLimitLeft) {
      // Entire widget has moved past the left limit
      handleSlideOut(angle: radiansToDegrees(getAngle), endOffset: _endOffset);
    } else if (rightX > outSizeLimitRight) {
      // Entire widget has moved past the right limit
      handleSlideOut(angle: radiansToDegrees(getAngle), endOffset: _endOffset);
    } else {
      // If not fully out, restore position
      restorePosition();
    }
  }

  void restorePosition() {
    _restoreController.forward();
  }

  void handleSlideOut({required double angle, required Offset endOffset}) {

    widget.slideOut(angle: angle, endOffset: endOffset);
  }




  @override
  Widget build(BuildContext context) {

    final child = SizedBox(key: _widgetKey, child: widget.widget,);
    if(!widget.isEnableDrag) return child;

    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: AnimatedBuilder(
        animation: _restoreController,
        builder: (context, _) {
          final value = 1 - _restoreController.value;
          return Transform.translate(
              offset: _endOffset * value,
              child: Transform.rotate(
                  angle: getAngle,
                  child: child,
              )
          );
        }
      ),
    );
  }
}
