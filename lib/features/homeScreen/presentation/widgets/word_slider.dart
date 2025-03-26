


import 'dart:math';
import 'dart:ui';

import 'package:dictionary_api/dictionary_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_improve_vocabulary/features/homeScreen/presentation/widgets/draggable.dart';

class WordSlider extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  const WordSlider({required this.itemCount, required this.itemBuilder, super.key});

  @override
  State<WordSlider> createState() => _WordSliderState();
}

class _WordSliderState extends State<WordSlider> with SingleTickerProviderStateMixin {

  late AnimationController _slideMoveController;
  Offset _startOffset = Offset.zero;
  Offset _endOffset = Offset.zero;
  Animation? _offsetAnimation;
  Animation? _rotateAnimation;
  double _angle = 0;
  double _index = 0;
  int _slidesNumber = 2;


  Offset getOffset(int index) {
    return {
      0: Offset(0,0),
      1: _offsetAnimation?.value ?? Offset(0, 0),
    }[index] ?? Offset(0,0);
  }
  
  double getScale(int index) {
    return {
      0: lerpDouble(0.75, 1, _slideMoveController.value),
      1: 1.0,
    }[index] ?? 1;
  }

  double getRotationAngle(int index) {
    return {
      0: 0.0,
      1: _rotateAnimation?.value ?? _angle,

    }[index] ?? 0.0;

  }
  



  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  void slideOut({required double angle, required Offset endOffset}) {
    _angle = angle;
    _endOffset = endOffset;
    startAnimation();
  }

  void startAnimation() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Calculate large distance to move the container off-screen
    double throwDistance = max(screenWidth, screenHeight) * 1.5; // Ensures movement beyond screen bounds

    double radians = _angle * (pi / 180);
    // double radians = _angle;

    Offset throwOffset = Offset(
      cos(radians) * throwDistance,
      sin(radians) * throwDistance,
    );

    double remainingRotationAngle = 36 - _angle;
    // double remainingRotationAngle = 36 - 18;


    _offsetAnimation = Tween<Offset>(
      begin: _endOffset,
      end:  throwOffset,
    ).animate(CurvedAnimation(parent: _slideMoveController, curve: Curves.easeOut));

    _rotateAnimation = Tween<double>(begin: _angle, end: _angle + remainingRotationAngle).animate(_slideMoveController);

    _slideMoveController.forward(from: 0);
  }

  void animationListener() {
    if(_slideMoveController.isCompleted) {
      setState(() {
        _angle = 0;
        _startOffset = Offset.zero;
        _endOffset = Offset.zero;
        _slideMoveController.reset();
        if(_index == widget.itemCount - 1) {
          _slidesNumber = 1;
        } else {
          _slidesNumber = 2;
          _index++;
        }
      });

    }
  }



  @override
  void initState() {
   _slideMoveController = AnimationController(vsync: this, duration: Duration(milliseconds: 300))..addListener(animationListener);
    super.initState();
  }


  @override
  void dispose() {
    _slideMoveController..removeListener(animationListener)..dispose();
    super.dispose();
  }







  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideMoveController,
      builder: (context, _) => Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: List.generate(_slidesNumber, (index) {
          final int wordIndex = (_index + 1 - index).toInt();
          return Transform.translate(
            offset: getOffset(index),
            child: Transform.scale(
              scale: getScale(index),
              child: Transform.rotate(
                angle: getRotationAngle(index),
                child: Container(
                  // width: 100,
                  // height: 100,
                  color: Colors.white70,
                  child: DraggableSlider(widget: widget.itemBuilder(context, wordIndex), slideOut: slideOut)
                ),
              ),
            ),
          );
        }),
      ),

    );
  }

}

