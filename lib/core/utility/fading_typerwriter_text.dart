import 'package:flutter/material.dart';



// class FadingTypewriterText extends StatefulWidget {
//   final String text;
//   final Duration speed;
//   final TextStyle? style;
//
//   const FadingTypewriterText(this.text, {this.style, super.key, this.speed = const Duration(milliseconds: 10)});
//
//   @override
//   State<FadingTypewriterText> createState() => _FadingTypewriterTextState();
// }
//
// class _FadingTypewriterTextState extends State<FadingTypewriterText> {
//   String _visibleText = "";
//   int _index = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _startTyping();
//   }
//
//   void _startTyping() {
//     Future.delayed(widget.speed, _updateText);
//   }
//
//   void _updateText() {
//     if (_index < widget.text.length) {
//       setState(() {
//         _visibleText += widget.text[_index];
//         _index++;
//       });
//       Future.delayed(widget.speed, _updateText);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       duration: Duration(milliseconds: 300),
//       opacity: 1.0, // Fade effect when characters appear
//       child: Text(
//         _visibleText,
//         style: widget.style,
//       ),
//     );
//   }
// }




class ChunkedFadingText extends StatefulWidget {
  final String text;
  final Duration speed;
  final int chunkSize;
  final TextStyle? style;

  ChunkedFadingText(
      this.text, {
        this.style,
        this.speed = const Duration(milliseconds: 500),
        this.chunkSize = 5, // Default is 5 words per chunk
      });

  @override
  _ChunkedFadingTextState createState() => _ChunkedFadingTextState();
}

class _ChunkedFadingTextState extends State<ChunkedFadingText> {
  List<String> words = [];
  int currentChunkIndex = 0;

  @override
  void initState() {
    super.initState();
    words = _splitIntoChunks(widget.text, widget.chunkSize);
    _startTyping();
  }

  List<String> _splitIntoChunks(String text, int chunkSize) {
    List<String> wordList = text.split(" ");
    List<String> chunks = [];

    if (wordList.length <= chunkSize) {
      // If the sentence has fewer words than chunkSize, add it as one chunk
      chunks.add(text);
    } else {
      for (int i = 0; i < wordList.length; i += chunkSize) {
        chunks.add(wordList.sublist(
            i, i + chunkSize > wordList.length ? wordList.length : i + chunkSize)
            .join(" "));
      }
    }

    return chunks;
  }

  void _startTyping() {
    if (currentChunkIndex < words.length) {
      Future.delayed(widget.speed, () {
        setState(() {
          currentChunkIndex++;
        });
        _startTyping();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(currentChunkIndex, (index) {
        return LeftToRightFadeText(words[index], style: widget.style,);
      }),
    );
  }
}

class LeftToRightFadeText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  const LeftToRightFadeText(this.text, {this.style});

  @override
  _LeftToRightFadeTextState createState() => _LeftToRightFadeTextState();
}

class _LeftToRightFadeTextState extends State<LeftToRightFadeText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )..forward();

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0x00FFFFFF), // Fully transparent at the start (left)
                Color.lerp(Colors.transparent, Colors.white, _fadeAnimation.value * 0.5)!, // Subtle fade in the middle
                Colors.white, // Fully visible text in the center
                Color.lerp(Colors.transparent, Colors.white, _fadeAnimation.value * 0.5)!, // Subtle fade out in the middle
                Color(0x00FFFFFF), // Fully transparent at the end (right)
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0], // Smooth transition between transparent & visible
            ).createShader(bounds);
          },




          child: Text(
            widget.text,
            style: widget.style,
          ),
        );
      },
    );
  }
}
