import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/blocs/ViewSwitcherCubit/view_switcher_cubit.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/bloc/gemini_bloc.dart';
import 'package:flutter_improve_vocabulary/features/dictionary/bloc/word_bloc.dart';

class DraggableSlider extends StatefulWidget {
  final Widget widget;
  final void Function({required double angleInDegree, required Offset endOffset, required Offset startOffset,required int direction}) slideOut;
  const DraggableSlider({required this.widget,  required this.slideOut, super.key});

  @override
  State<DraggableSlider> createState() => _DraggableSliderState();
}

class _DraggableSliderState extends State<DraggableSlider> with SingleTickerProviderStateMixin {
  // Global key to get the size and position of the card widget.
  final GlobalKey _widgetKey = GlobalKey();
  // start offset of the drag
  Offset _startOffset = Offset.zero;
  // end offset of the drag
  Offset _endOffset = Offset.zero;
  // angle of the drag
  double _angle = 0;
  // restore controller to restore the position of the card widget.
  late AnimationController _restoreController;
  // screen size of the device
  late Size screenSize;
  // size of the card widget
  Size  cardSize = Size.zero;

  late Offset initialCardTopLeftPosition;
  late Offset initialCardTopRightPosition;
  // flag to check if the drag is enabled, used to prevent the drag when the card is at the last index.
  bool isEnableDrag = true;
  bool _isPanEndTriggered = false; // To prevent multiple manual panEnd triggers


  // left limit to remove the card
  double get outSizeLimitLeft => -50;

  // right limit to remove the card
  double get outSizeLimitRight => screenSize.width + 50;

  @override
  void initState() {
    _restoreController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      ..addListener(animationListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCardSize();
      getInitialCardTopLeftGlobalPosition();
      getInitialCardTopRightGlobalPosition();
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


  void getCardSize() {
     cardSize =
        (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size ??
            Size.zero;
  }

  void getInitialCardTopLeftGlobalPosition() {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    initialCardTopLeftPosition =
        renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  void getInitialCardTopRightGlobalPosition() {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    initialCardTopRightPosition =
        renderBox?.localToGlobal(Offset(renderBox.size.width, 0)) ??
            Offset.zero;
  }

  void animationListener() {
    if (_restoreController.isCompleted) {
       


      setState(() {
        _restoreController.reset();
        _angle = 0;
        _startOffset = Offset.zero;
        _endOffset = Offset.zero;
      });
    }
  }


  Offset get getCardCurrentTopLeftPosition {
    // 1. localToGlobal(Offset.zero) means widget's screen position of widgets top-left corner.
    // 2. localToGlobal(renderBox.size.center(Offset.zero)) means widget's screen position of widgets center.
    //    we use Offset.zero again because center(Offset) requires a reference point to calculate center point.
    // 3. localToGlobal(Offset(widgetWidth * .6, widgetHeight * .3)) means widget's screen position of
    //    widgets 60 percent of width point and 30 percent of height point offset's position.

    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?)?.localToGlobal(Offset.zero);
    return renderBox ?? Offset.zero;
  }

  Offset get getCardCurrentTopRightPosition {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    return renderBox?.localToGlobal(Offset(renderBox.size.width, 0)) ??
        Offset.zero;
  }

  Offset get getCardCurrentBottomLeftPosition {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    return renderBox?.localToGlobal(Offset(0, renderBox.size.height)) ??
        Offset.zero;
  }

  Offset get getCardCurrentBottomRightPosition {
    final renderBox = (_widgetKey.currentContext
        ?.findRenderObject() as RenderBox?);
    return renderBox?.localToGlobal(
        Offset(renderBox.size.width, renderBox.size.height)) ?? Offset.zero;
  }


  double get getAngle {
    if ( cardSize == Size.zero || screenSize == Size.zero) return 0;

    double leftDx = getCardCurrentTopLeftPosition.dx;
    double rightDx = getCardCurrentTopRightPosition.dx;

    // Calculate card's center X position
    double cardCenterDx = (leftDx + rightDx) / 2;

    // Get screen center X position
    double screenCenterDx = screenSize.width / 2;

    // Normalize the deviation (-1 to 1 range)
    double normalizedDeviation = (cardCenterDx - screenCenterDx) /
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
 
    // is using Gemini AI to fetch words or no.
    if (context
        .read<GeminiBloc>()
        .isAiWordsGenerationOn) {
 
      if(context.read<GeminiBloc>().state.runtimeType != AiWordsLoadingState) {

 
        context.read<GeminiBloc>().add(LoadAiWordsEvent(autoLoad: false, noOfAiWordsToLoad: context
            .read<WordBloc>()
            .moreWordFetchLimit));
        context.read<ViewSwitcherCubit>().changeViewMode(ViewMode.geminiAi);
      }


    } else {
        // fetching words from dictionary api.
      if(context.read<WordBloc>().state.runtimeType != WordsLoadingState) {

 
        context.read<WordBloc>().add(LoadWords(
          autoLoad: false,
          noOfWordToSearch: context
            .read<WordBloc>()
            .moreWordFetchLimit));
        context.read<ViewSwitcherCubit>().changeViewMode(ViewMode.dictionaryApi);
      }


    }
  }

  void restorePosition() {
    if (_restoreController.isAnimating) return;
     
    _restoreController.forward();
  }

  void handleSlideOut(
      {required double angle, required Offset endOffset, required Offset startOffset, required int direction}) {
     
    // provided angle is in radians, converting to degree
    widget.slideOut(angleInDegree: radiansToDegrees(angle),
        endOffset: endOffset,
        startOffset: startOffset,
        direction: direction);
  }

  // current mode = Gemini AI or Dictionary API.
  int getCurrentModeWordIndex() {
    if(context.read<ViewSwitcherCubit>().viewMode == ViewMode.dictionaryApi) {
       
      return context
          .read<WordBloc>()
          .wordIndex;
    } else {
       
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

     
     

    setState(() {
      // if the current index is not the last index(means there are more words to load in the home screen), then enable the drag.
      isEnableDrag = currentIndex != allWordsLength - 1;
       
      _startOffset = details.localPosition;
      _isPanEndTriggered = false;
    });
  }

  void onPanUpdate(DragUpdateDetails details) {
    // Don't process updates if a restore animation is currently running
    if (_restoreController.isAnimating) return;

    // This block handles the case when we're at the last card (dragging is disabled)
    if (!isEnableDrag) {





        // PROTECTION MECHANISM:
        // This flag prevents multiple animations and word fetches from triggering
        // when the card hits screen boundaries. Without this, rapid successive
        // onPanUpdate calls could cause visual glitches and state inconsistencies.

// Without _isPanEndTriggered Flag:
// User Drags → Hit Boundary → onPanUpdate
//                          → restore animation starts
//                          → fetch words starts
//                          → onPanUpdate (again)
//                          → another restore animation tries to start
//                          → another fetch words starts
//                          → [VISUAL GLITCHES]


// With _isPanEndTriggered Flag:
// User Drags → Hit Boundary → onPanUpdate
//                          → _isPanEndTriggered = false
//                          → restore animation starts
//                          → fetch words starts
//                          → _isPanEndTriggered = true
//                          → onPanUpdate (again)
//                          → [Blocked by flag ✓]
//                          → [SMOOTH ANIMATION]



        if (_isPanEndTriggered != true) {
            // LEFT BOUNDARY CHECK
            if (getCardCurrentTopLeftPosition.dx <= 0 ||
                getCardCurrentBottomLeftPosition.dx <= 0) {
                // When card hits the left boundary:
                // 1. Mark that we've handled this boundary hit
                // 2. Restore card to center
                // 3. Load more words
                setState(() {
                    _isPanEndTriggered = true;
                });
                restorePosition();
                _fetchMoreWords();
                return;
            }

            // RIGHT BOUNDARY CHECK
            if (getCardCurrentTopRightPosition.dx >= screenSize.width ||
                getCardCurrentBottomRightPosition.dx >= screenSize.height) {
                // Same protection mechanism for right boundary
                setState(() {
                    _isPanEndTriggered = true;
                });
                restorePosition();
                _fetchMoreWords();
                return;
            }

            // TOP BOUNDARY CHECK
            if (getCardCurrentTopLeftPosition.dy <= 0 ||
                getCardCurrentTopRightPosition.dy <= 0) {
                // Same protection mechanism for top boundary
                setState(() {
                    _isPanEndTriggered = true;
                });
                restorePosition();
                _fetchMoreWords();
                return;
            }

            // BOTTOM BOUNDARY CHECK
            if (getCardCurrentBottomLeftPosition.dy >= screenSize.height ||
                getCardCurrentBottomRightPosition.dy >= screenSize.height) {
                // Same protection mechanism for bottom boundary
                setState(() {
                    _isPanEndTriggered = true;
                });
                restorePosition();
                _fetchMoreWords();
                return;
            }
        } else {
            // If we've already handled a boundary hit, ignore further pan updates
            // This prevents multiple animations from conflicting with each other
            return;
        }
    }

    // Normal dragging behavior when not at the last card:
    // Update the card's position and rotation based on the drag movement
    setState(() {
        _endOffset = details.localPosition - _startOffset;
        _angle = getAngle;
    });
  }

  void onPanEnd(DragEndDetails end) {
     
    if (_restoreController.isAnimating) return;


    // SCENARIO HANDLING:
    // Scenario 1 (Normal Swipe): _isPanEndTriggered is false
    //   → Process the natural swipe animation
    //   → Card can slide out or restore based on position
    //
    // Scenario 2 (Boundary Hit): _isPanEndTriggered is true
    //   → Skip this entirely as animation is already handled
    //   → Prevents conflict with boundary hit animation
    if (!_isPanEndTriggered) {
      double leftX = getCardCurrentTopLeftPosition.dx;
      double rightX = getCardCurrentTopRightPosition.dx;

      if (leftX < outSizeLimitLeft) {
        // Card has moved past the left limit
        handleSlideOut(angle: getAngle,
            endOffset: _endOffset,
            startOffset: _startOffset,
            direction: -1);
      } else if (rightX > outSizeLimitRight) {
        // Card has moved past the right limit
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