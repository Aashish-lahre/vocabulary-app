
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../features/gemini_ai/bloc/gemini_bloc.dart';
import '../../blocs/ViewSwitcherCubit/view_switcher_cubit.dart';
import '../../models/word.dart';
import '../../utility/above_banner.dart';

class ExampleWidget extends StatefulWidget {
  final Word word;
  const ExampleWidget({required this.word, super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  late Word word;

  @override
  void initState() {
    word = widget.word;
    super.initState();
  }

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
              return [GeminiFailureState, GeminiInvalidApiKeyState].contains(currentState.runtimeType);
            },
            listener:(context, state) {
              if(state is GeminiInvalidApiKeyState) {
          String message = 'Cannot Generate Examples with Invalid API Key.';
                            ContentType contentType = ContentType.failure;

                            showOverlayBanner(context,
                                message: message, contentType: contentType);
        }
            },
            buildWhen: (previousState, currentState) {
              return [ExamplesLoadedState, ExamplesLoadingState, GeminiInvalidApiKeyState].contains(currentState.runtimeType);
            },
            builder:(context, state) {

              switch (state) {
                case ExamplesLoadedState _ :
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(word.examples.length, (index) {
                      return _buildExampleContainer(context, word.examples[index]);
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
                      ...List.generate(word.examples.length, (index) {
                        return _buildExampleContainer(context, word.examples[index]);
                      }),

                      ...List.generate(3, (index) {
                        return Shimmer.fromColors(
                            baseColor: Theme.of(context).colorScheme.surfaceContainer,
                            highlightColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                            child: Container(width: double.infinity, height: 30, decoration: BoxDecoration(color: colorScheme.surfaceContainer, borderRadius: BorderRadius.circular(10)),));
                      }),
                    ],
                  );
                case GeminiInvalidApiKeyState _ :
                  return SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: Text(state.errorMessage, style: textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),),
                  );
                default :
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(word.examples.length, (index) {
                      return _buildExampleContainer(context, word.examples[index]);
                    }),
                  );
              }
            },

          ),
          GestureDetector(
            onTap: () => context.read<GeminiBloc>().add(LoadExamplesEvent(word: word, limit: 3, filterOut: word.examples)),
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