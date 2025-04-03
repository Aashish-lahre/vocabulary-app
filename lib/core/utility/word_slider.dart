import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';
import 'package:flutter_improve_vocabulary/core/utility/draggable.dart';
import 'package:flutter_improve_vocabulary/core/screens/word_card_shimmer.dart';
import 'package:flutter_improve_vocabulary/features/word/bloc/word_bloc.dart';

class WordSlider extends StatefulWidget {
  final Widget wordWidget;
  final int wordsLength;

  const WordSlider(
      {required this.wordWidget, required this.wordsLength, super.key});

  @override
  State<WordSlider> createState() => _WordSliderState();
}

class _WordSliderState extends State<WordSlider>
    with SingleTickerProviderStateMixin {

  late AnimationController _slideMoveController;
  Offset _startOffset = Offset.zero;
  Offset _endOffset = Offset.zero;
  Animation? _offsetAnimation;
  Animation? _rotateAnimation;
  double _angleInDegree = 0;
  double _index = 0;


  Offset getOffset(int index) {
    return {
      0: Offset(0, 0),
      1: _offsetAnimation?.value ?? Offset(0, 0),
    }[index] ?? Offset(0, 0);
  }

  double getScale(int index) {
    return {
      // 0: lerpDouble(0.75, 1, _slideMoveController.value),
      0: 1.0,
      1: (1.0 - _slideMoveController.value).clamp(0.3, 1.0),
    }[index] ?? 1;
  }

  double getRotationAngle(int index) {
    return {
      0: 0.0,
      1: degreesToRadians(_rotateAnimation?.value ?? 0) ?? 0.0,

    }[index] ?? 0.0;
  }


  double degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }


  void slideOut(
      {required double angleInDegree, required Offset endOffset, required Offset startOffset, required int direction}) {
    setState(() {
      _angleInDegree = angleInDegree;
      _endOffset = endOffset;
      _startOffset = startOffset;
    });

    startAnimation(direction: direction);
  }

  void startAnimation({required int direction}) {
    double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;

    // Calculate large distance to move the container off-screen
    double throwDistance = max(350, 0); // Ensures movement beyond screen bounds

    double radians = _angleInDegree * (pi / 180);
    // double radians = _angle;

    double throwDirection = direction.toDouble(); // 🔥 Determine drag direction

    Offset throwOffset = Offset(
        cos(radians) * throwDistance * throwDirection,
        // 🔥 Adjust offset direction
        // sin(radians) * throwDistance,
        0
    );


    double remainingRotationAngle = 36 - _angleInDegree;
    // double remainingRotationAngle = 36 - 18;


    _offsetAnimation = Tween<Offset>(
      begin: _endOffset,
      end: throwOffset,
      // begin: _endOffset - _startOffset,
      // end: _endOffset - _startOffset + throwOffset,
    ).animate(
        CurvedAnimation(parent: _slideMoveController, curve: Curves.easeOut));

    // _rotateAnimation = Tween<double>(begin: _angleInDegree, end: _angleInDegree + remainingRotationAngle).animate(_slideMoveController);
    _rotateAnimation = Tween<double>(
      begin: _angleInDegree,
      end: _angleInDegree + (_angleInDegree > 0
          ? remainingRotationAngle
          : -remainingRotationAngle), // 🔥 Limit rotation based on drag direction
    ).animate(_slideMoveController);

    _rotateAnimation = Tween<double>(
      begin: _angleInDegree,
      end: 20.0, // 🔥 Limit rotation based on drag direction
    ).animate(_slideMoveController);

    _slideMoveController.forward();
  }

  void animationListener() {
    if (_slideMoveController.isCompleted) {
      setState(() {
        _angleInDegree = 0;
        _startOffset = Offset.zero;
        _endOffset = Offset.zero;

        context.read<WordBloc>().add(LoadSingleWordInOrder());

      });
    }
  }


  @override
  void initState() {
    _slideMoveController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 700))
      ..addListener(animationListener);
    super.initState();
  }


  @override
  void dispose() {
    _slideMoveController
      ..removeListener(animationListener)
      ..dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    print("word slider : ${context.watch<WordBloc>().allWords}");
    return BlocListener<WordBloc, WordState>(
      listener: (context, state) {
        print('word slider listener called');
        print('state is : ${state.runtimeType}');
      },
      child: AnimatedBuilder(
        animation: _slideMoveController,
        builder: (context, _) =>
            Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: List.generate(2, (index) {
                // final int wordIndex = (_index + 1 - index).toInt();
                return Transform.translate(
                  offset: getOffset(index),
                  child: Transform.scale(
                    scale: getScale(index),
                    child: Container(
                        child:
                        index == 0 ? WordCardShimmer() : DraggableSlider(
                            allWordsLength: widget.wordsLength,
                            widget: widget.wordWidget, slideOut: slideOut)
                    ),
                  ),
                );
              }),
            ),

      ),
    );
  }

}

