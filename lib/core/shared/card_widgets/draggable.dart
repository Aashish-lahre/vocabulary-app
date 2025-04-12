import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/blocs/ViewSwitcherCubit/view_switcher_cubit.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';
import 'package:flutter_improve_vocabulary/core/blocs/later_word_fetch_bloc/later_word_fetch_bloc.dart';
import 'package:flutter_improve_vocabulary/features/dictionary/bloc/word_bloc.dart';

class DraggableSlider extends StatefulWidget {
  final Widget widget;
  final void Function({required double angleInDegree, required Offset endOffset, required Offset startOffset,required int direction}) slideOut;
  const DraggableSlider({required this.widget,  required this.slideOut, super.key});

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
  bool isEnableDrag = true;
  bool _isPanEndTriggered = false; // To prevent multiple manual panEnd triggers


  // left limit to remove the magazine
  double get outSizeLimitLeft => -50;

  // right limit to remove the magazine
  double get outSizeLimitRight => screenSize.width + 50;

  @override
  void initState() {
    _restoreController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      ..addListener(animationListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSlideSize();
      getInitialSlideTopLeftGlobalPosition();
      getInitialSlideTopRightGlobalPosition();
      screenSize = MediaQuery
          .of(context)
          .size;
    });
    super.initState();
  }

  @override
  void dispose() {
    _restoreController
      ..removeListener(animationListener)
      ..dispose();
    super.dispose();
  }


  void getSlideSize() {
    slideSize =
        (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size ??
            Size.zero;
  }

  void getInitialSlideTopLeftGlobalPosition() {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    initialSlideTopLeftPosition =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  void getInitialSlideTopRightGlobalPosition() {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    initialSlideTopRightPosition =
        renderBox?.localToGlobal(Offset(renderBox.size.width, 0)) ??
            Offset.zero;
  }

  void animationListener() {
    if (_restoreController.isCompleted) {
      print('restore animation completed');
      // _fetchMoreWords();
      // print('about to fetch words...');

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

    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?)?.localToGlobal(Offset.zero);
    return renderBox ?? Offset.zero;
  }

  Offset get getCurrentTopRightPosition {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    return renderBox?.localToGlobal(Offset(renderBox.size.width, 0)) ??
        Offset.zero;
  }

  Offset get getCurrentBottomLeftPosition {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    return renderBox?.localToGlobal(Offset(0, renderBox.size.height)) ??
        Offset.zero;
  }

  Offset get getCurrentBottomRightPosition {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    return renderBox?.localToGlobal(
        Offset(renderBox.size.width, renderBox.size.height)) ?? Offset.zero;
  }


  double get getAngle {
    if (slideSize == Size.zero || screenSize == Size.zero) return 0;

    double leftDx = getCurrentTopLeftPosition.dx;
    double rightDx = getCurrentTopRightPosition.dx;

    // Calculate slide's center X position
    double slideCenterDx = (leftDx + rightDx) / 2;

    // Get screen center X position
    double screenCenterDx = screenSize.width / 2;

    // Normalize the deviation (-1 to 1 range)
    double normalizedDeviation = (slideCenterDx - screenCenterDx) /
        screenCenterDx;

    // Max angle range (adjust as needed)
    double maxRotation = pi * 0.08; // Example: max ±18 degrees (~0.1π rad)

    // Calculate angle
    double angle = maxRotation * normalizedDeviation;

    // angle is in radians.
    radiansToDegrees(angle);
    return angle;
  }


  double radiansToDegrees(double radians) {
    return radians * (180 / pi);
  }



  void _fetchMoreWords() {
print('fetch block started...');
    // is using Gemini AI to fetch words or no.
    if (context
        .read<GeminiBloc>()
        .isAiWordsGenerationOn) {
print('ai is no...');
      if(context.read<GeminiBloc>().state.runtimeType != AiWordsLoadingState) {

print('loading more ai words....');
        context.read<GeminiBloc>().add(LoadAiWordsEvent(autoLoad: false, noOfAiWordsToLoad: context
            .read<LaterWordFetchBloc>()
            .laterWordFetchLimit));
        context.read<ViewSwitcherCubit>().changeViewMode(ViewMode.geminiAi);
      }


    } else {
print('ai is off');
      if(context.read<WordBloc>().state.runtimeType != LaterWordsLoading) {

print('loading more api words...');
        context.read<WordBloc>().add(LaterLoadWords(noOfWordsToLoad: context
            .read<LaterWordFetchBloc>()
            .laterWordFetchLimit));
        context.read<ViewSwitcherCubit>().changeViewMode(ViewMode.dictionaryApi);
      }


    }
  }

  void restorePosition() {
    if (_restoreController.isAnimating) return;
    print('restoring start....');
    _restoreController.forward();
  }

  void handleSlideOut(
      {required double angle, required Offset endOffset, required Offset startOffset, required int direction}) {
    print('called slide out');
    // provided angle is in radians, converting to degree
    widget.slideOut(angleInDegree: radiansToDegrees(angle),
        endOffset: endOffset,
        startOffset: startOffset,
        direction: direction);
  }


  int getCurrentModeWordIndex() {
    if(context.read<ViewSwitcherCubit>().viewMode == ViewMode.dictionaryApi) {
      print('viewMode : dictionary');
      return context
          .read<WordBloc>()
          .wordIndex;
    } else {
      print('viewMode : gemini');
      return context
          .read<GeminiBloc>()
          .wordIndex;
    }
  }
  int getCurrentModeWordsLength() {
    if(context.read<ViewSwitcherCubit>().viewMode == ViewMode.dictionaryApi) {
      return context
          .read<WordBloc>()
          .allWords
          .length;
    } else {
      return context
          .read<GeminiBloc>()
          .allWords
          .length;
    }
  }


  void onPanStart(DragStartDetails details) {
    if (_restoreController.isAnimating) return;

    int currentIndex = getCurrentModeWordIndex();
    int allWordsLength = getCurrentModeWordsLength();
    print('currentIndex : $currentIndex');
    print('allWordsLength : $allWordsLength');

    setState(() {
      isEnableDrag = currentIndex != allWordsLength - 1;
      print('isEnableDrag : $isEnableDrag');
      _startOffset = details.localPosition;
      _isPanEndTriggered = false;
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (_restoreController.isAnimating) return;
    if (!isEnableDrag) {
      if (_isPanEndTriggered != true) {
        if (getCurrentTopLeftPosition.dx <= 0 ||
            getCurrentBottomLeftPosition.dx <= 0) {
          // Moving left (prevent going beyond the left screen boundary)
          setState(() {
            _isPanEndTriggered = true;
          });
          print('restoring position about to called');
          restorePosition();
          _fetchMoreWords();

          return;
        }

        if (getCurrentTopRightPosition.dx >= screenSize.width ||
            getCurrentBottomRightPosition.dx >= screenSize.height) {
          // Moving right (prevent going beyond the right screen boundary)
          setState(() {
            _isPanEndTriggered = true;
          });
          restorePosition();
          _fetchMoreWords();


          return;
        }

        if (getCurrentTopLeftPosition.dy <= 0 ||
            getCurrentTopRightPosition.dy <= 0) {
          // Moving top (prevent going beyond the top screen boundary)
          setState(() {
            _isPanEndTriggered = true;
          });
          restorePosition();
          _fetchMoreWords();

          return;
        }

        if (getCurrentBottomLeftPosition.dy >= screenSize.height ||
            getCurrentBottomRightPosition.dy >= screenSize.height) {
          // Moving bottom (prevent going beyond the bottom screen boundary)
          setState(() {
            _isPanEndTriggered = true;
          });
          restorePosition();
          _fetchMoreWords();

          return;
        }
      } else {
        print('returned');
        return;
      }
    }
      // print('isEnableDrag = true, not entered');

      setState(() {
        _endOffset = details.localPosition - _startOffset;
        // _endOffset = details.globalPosition - _startOffset;

        _angle = getAngle;
      });


  }

  void onPanEnd(DragEndDetails end) {
    print('onPanEnd');
    if (_restoreController.isAnimating) return;
    if (!_isPanEndTriggered) {
      double leftX = getCurrentTopLeftPosition.dx;
      double rightX = getCurrentTopRightPosition.dx;

      if (leftX < outSizeLimitLeft) {
        // Entire widget has moved past the left limit
        handleSlideOut(angle: getAngle,
            endOffset: _endOffset,
            startOffset: _startOffset,
            direction: -1);
      } else if (rightX > outSizeLimitRight) {
        // Entire widget has moved past the right limit
        handleSlideOut(angle: getAngle,
            endOffset: _endOffset,
            startOffset: _startOffset,
            direction: 1);
      } else {
        restorePosition();
      }
      setState(() {
        _isPanEndTriggered = true;
      });
    }


    // restorePosition();
  }


  @override
  Widget build(BuildContext context) {
    final child = SizedBox(key: _widgetKey, child: widget.widget,);
    return
      GestureDetector(
        onPanStart: (details) => onPanStart(details),
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: AnimatedBuilder(
            animation: _restoreController,
            builder: (context, _) {
              final value = 1 - _restoreController.value;
              print('value of restore animation : $value');
              return Transform.translate(
                  offset: _endOffset * value,
                  child: Transform.rotate(
                    angle: _angle * value,
                    child: child,
                  )
              );
            }
        ),
      );
  }
}