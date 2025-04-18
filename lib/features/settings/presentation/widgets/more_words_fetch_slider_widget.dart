
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/features/dictionary/bloc/word_bloc.dart';


class MoreWordFetchSliderWidget extends StatefulWidget {
  final BoxConstraints constraints;
  const MoreWordFetchSliderWidget({super.key, required this.constraints});

  @override
  State<MoreWordFetchSliderWidget> createState() => MoreWordFetchSliderWidgetState();
}
class MoreWordFetchSliderWidgetState extends State<MoreWordFetchSliderWidget> {

  late int moreWordFetchLimitCountController;

@override
  void initState() {
  moreWordFetchLimitCountController = context.read<WordBloc>().moreWordFetchLimit;
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
                
                              value: moreWordFetchLimitCountController.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: moreWordFetchLimitCountController.toString(),
                              onChanged: (changedValue) {
                                setState(() {
                                  moreWordFetchLimitCountController = changedValue.toInt();
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

