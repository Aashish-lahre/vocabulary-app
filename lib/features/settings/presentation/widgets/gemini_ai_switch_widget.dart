
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gemini_ai/word/bloc/gemini_bloc.dart';

class GeminiAiSwitch extends StatefulWidget {
  const GeminiAiSwitch({super.key,});

  @override
  State<GeminiAiSwitch> createState() => GeminiAiSwitchState();
}
class GeminiAiSwitchState extends State<GeminiAiSwitch> {
  late bool _isOn;
  @override
  void initState() {
    _isOn = context.read<GeminiBloc>().isAiWordsGenerationOn;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: EdgeInsets.only(left: 0, right: 20),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.psychology_rounded), // Leading icon
          SizedBox(width: 10), // Spacing
          Text("Gemini AI"), // Title text
        ],
      ),
      value: _isOn,
      onChanged: (bool value) {
        setState(() {
          _isOn = value;
          // widget.isGeminiAiOn.value = value;
          context.read<GeminiBloc>().add(ToggleGenerateWordsWithAiSwitchEvent(isOn: value));

        });
      },
    );
  }
}

