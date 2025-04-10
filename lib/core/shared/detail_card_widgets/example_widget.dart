
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/utility/base_class.dart';
import 'package:shimmer/shimmer.dart';

import '../../../features/gemini_ai/bloc/gemini_bloc.dart';

class ExampleWidget extends StatefulWidget {
  final BaseWord word;
  final List<String> examples;
  const ExampleWidget({required this.word, required this.examples, super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;


    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Column(
        spacing: 20,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // "Examples :" text
          Text(
            'Examples :',
            style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w900, color: colorScheme.onSurface),
          ),

          BlocConsumer<GeminiBloc, GeminiState>(
            listenWhen: (previousState, currentState) {
              return [GeminiFailureState].contains(currentState.runtimeType);
            },
            listener:(context, state) {},
            buildWhen: (previousState, currentState) {
              return [ExamplesLoadedState, ExamplesLoadingState, GeminiFailureState].contains(currentState.runtimeType);
            },
            builder:(context, state) {

              switch (state) {
                case ExamplesLoadedState _ :
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.examples.length, (index) {
                      return _buildExampleContainer(context, widget.examples[index]);
                    }),
                  );
                case SingleAiWordFetchedState _ :
                case AiWordsLoadedState _ :
                case GeminiInitial _ :
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(widget.examples.length, (index) {
                      return _buildExampleContainer(context, widget.examples[index]);
                    }),
                  );

                case ExamplesLoadingState _ :
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 10,
                    children: [
                      // ...List.generate(examples.length, (index) {
                      //   return _buildExampleContainer(context, examples[index]);
                      // }),
                      ...List.generate(widget.examples.length, (index) {
                        return _buildExampleContainer(context, widget.examples[index]);
                      }),

                      ...List.generate(3, (index) {
                        return Shimmer.fromColors(
                            baseColor: Theme.of(context).colorScheme.surfaceContainer,
                            highlightColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                            child: Container(width: double.infinity, height: 30, decoration: BoxDecoration(color: colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(10)),));
                      }),
                    ],
                  );
                case GeminiFailureState _ :
                  return SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Text(state.errorMessage, style: textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),),
                  );
                default :
                  return SizedBox();
              }
            },

          ),
          GestureDetector(
            onTap: () => context.read<GeminiBloc>().add(LoadExamplesEvent(word: widget.word, limit: 3, filterOut: widget.examples)),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorScheme.primaryContainer,
              ),
              padding: EdgeInsets.all(8),
              child: Text('Generate examples with AI',
                style: textTheme.bodyMedium!.copyWith(
                    color: colorScheme.onPrimaryContainer),),
            ),
          ),
        ],
      ),

    );
  }

  Widget _buildExampleContainer(BuildContext context,
      String example,) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surfaceContainer,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Text(
        example,
        style:
        textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
      ),
    );
  }
}