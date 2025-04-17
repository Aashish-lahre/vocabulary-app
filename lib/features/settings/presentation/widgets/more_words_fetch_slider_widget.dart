
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/features/dictionary/bloc/word_bloc.dart';


class MoreWordFetchSliderWidget extends StatefulWidget {
  final BoxConstraints constraints;
  final ValueNotifier<int> moreWordFetchCountController;
  const MoreWordFetchSliderWidget({super.key, required this.constraints, required this.moreWordFetchCountController});

  @override
  State<MoreWordFetchSliderWidget> createState() => MoreWordFetchSliderWidgetState();
}
class MoreWordFetchSliderWidgetState extends State<MoreWordFetchSliderWidget> {

@override
  void initState() {
  widget.moreWordFetchCountController.value = context.read<WordBloc>().moreWordFetchLimit;
  super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Row(
      children: [
        // Flexible(
        //   child:
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Icon(Icons.text_fields_rounded),
              Text('Fetch Word', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),)
            ],
          ),
        // ),
        SizedBox(
          // color: Colors.cyan.shade200,
          width: widget.constraints.maxWidth * .6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('1', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0), ),// Default is 24.0
                child: Slider.adaptive(
                
                              value: widget.moreWordFetchCountController.value.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: widget.moreWordFetchCountController.value.toString(),
                              onChanged: (changedValue) {
                                setState(() {
                                  widget.moreWordFetchCountController.value = changedValue.toInt();
                                  context.read<WordBloc>().add(MoreWordsFetchLimitChangedEvent(changedLimit: changedValue.toInt()));

                                });
                              },
                
                
                            ),

              ),
              Text('10', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),)
            ],
          ),
        ),
      ],
    );
  }
}

