

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../gemini_ai/word/bloc/gemini_bloc.dart';
import '../../../gemini_ai/gemini_models.dart';

class GeminiModelsWidget extends StatefulWidget {
  final BoxConstraints constraints;
  const GeminiModelsWidget({super.key, required this.constraints});

  @override
  State<GeminiModelsWidget> createState() => GeminiModelsWidgetState();
}
class GeminiModelsWidgetState extends State<GeminiModelsWidget> {




  List<DropdownMenuItem<GeminiModels>> _geminiModelType(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer);

    return List.generate(GeminiModels.values.length, (index) {
      return DropdownMenuItem(value: GeminiModels.values[index], child: Text(GeminiModels.values[index].label, style: textStyle),);
    });


  }

  GeminiModels? _selectedGeminiModelType;

  @override
  void initState() {
    _selectedGeminiModelType  = context.read<GeminiBloc>().defaultModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = widget.constraints.maxWidth;

    return Row(
      children: [
        /// 👈 First section (Icon + Text)
        SizedBox(
          width: maxWidth * 0.4,
          child: Row(
            children: [
              Icon(Icons.animation, size: 20), // Optional: reduce icon size
              SizedBox(width: 8), // spacing
              Expanded( // ensures text wraps or shrinks
                child: Text(
                  'Gemini Models',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),
                ),
              ),
            ],
          ),
        ),

        /// 👉 Second section (Dropdown)
        SizedBox(
          width: maxWidth * 0.5,
          child: Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: DropdownButton(
                isDense: true, // ✅ reduces internal spacing
                underline: SizedBox(), // ✅ removes underline
                value: _selectedGeminiModelType,
                items: _geminiModelType(context),
                onChanged: (changedType) {
                  setState(() {
                    _selectedGeminiModelType = changedType;
                    if (changedType != null) {
                      context
                          .read<GeminiBloc>()
                          .add(ChangeGeminiModelEvent(modelType: changedType));
                    }
                  });
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

}

