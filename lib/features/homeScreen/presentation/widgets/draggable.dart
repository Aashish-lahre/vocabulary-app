import 'dart:math';

import 'package:flutter/material.dart';

class DraggableSlider extends StatefulWidget {
  final Widget widget;
  final bool isEnableDrag;
  final void Function({required double angleInDegree, required Offset endOffset, required Offset startOffset,required int direction}) slideOut;
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
      getSlideSize();
      getInitialSlideTopLeftGlobalPosition();
      getInitialSlideTopRightGlobalPosition();
      screenSize = MediaQuery.of(context).size;
    });
    super.initState();
  }

  @override
  void dispose() {
    _restoreController..removeListener(animationListener)..dispose();
    super.dispose();
  }


  void getSlideSize() {
    slideSize = (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size ?? Size.zero;
  }

  void getInitialSlideTopLeftGlobalPosition() {
    final renderBox = (_widgetKey.currentContext?.findRenderObject() as RenderBox?);
    initialSlideTopLeftPosition = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  void getInitialSlideTopRightGlobalPosition() {
    final renderBox = (_widgetKey.currentContext?.findRenderObject() as RenderBox?);
    initialSlideTopRightPosition = renderBox?.localToGlobal(Offset(renderBox.size.width, 0)) ?? Offset.zero;
  }

  void animationListener() {
    if(_restoreController.isCompleted) {
      setState(() {
        _restoreController.reset();
        _angle = 0;
        _startOffset = Offset.zero;
        _endOffset = Offset.zero;
      });

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

    double leftDx = getCurrentTopLeftPosition.dx;
    double rightDx = getCurrentTopRightPosition.dx;

    // Calculate slide's center X position
    double slideCenterDx = (leftDx + rightDx) / 2;

    // Get screen center X position
    double screenCenterDx = screenSize.width / 2;

    // Normalize the deviation (-1 to 1 range)
    double normalizedDeviation = (slideCenterDx - screenCenterDx) / screenCenterDx;

    // Max angle range (adjust as needed)
    double maxRotation = pi * 0.08; // Example: max ±18 degrees (~0.1π rad)

    // Calculate angle
    double angle = maxRotation * normalizedDeviation;

    // angle is in radians.
    radiansToDegrees(angle);
    return angle;
  }


  double radiansToDegrees(double radians) {
    print('rotate : ${radians * (180 / pi)}');
    return radians * (180 / pi);
  }

  void onPanStart(DragStartDetails details) {
    if(_restoreController.isAnimating) return;
    setState(() {
      _startOffset = details.localPosition;
    });

  }
  void onPanUpdate(DragUpdateDetails details) {
    if(_restoreController.isAnimating) return;
    setState(() {
      _endOffset = details.localPosition - _startOffset;
    });


  }
  void onPanEnd(DragEndDetails end) {
    if(_restoreController.isAnimating) return;
    double leftX = getCurrentTopLeftPosition.dx;
    double rightX = getCurrentTopRightPosition.dx;

    if (leftX < outSizeLimitLeft) {
      // Entire widget has moved past the left limit
      handleSlideOut(angle: getAngle, endOffset: _endOffset, startOffset: _startOffset, direction: -1);
    } else if (rightX > outSizeLimitRight) {
      // Entire widget has moved past the right limit
      handleSlideOut(angle: getAngle, endOffset: _endOffset, startOffset: _startOffset, direction: 1);

    } else {
      restorePosition();

    }
    // restorePosition();
  }

  void restorePosition() {
    _restoreController.forward();
  }

  void handleSlideOut({required double angle, required Offset endOffset, required Offset startOffset, required int direction}) {
    // provided angle is in radians, converting to degree
    widget.slideOut(angleInDegree: radiansToDegrees(angle), endOffset: endOffset, startOffset: startOffset, direction: direction);
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
