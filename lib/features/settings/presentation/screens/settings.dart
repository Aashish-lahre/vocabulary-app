import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/theme/color_theme.dart';
import 'package:flutter_improve_vocabulary/features/dictionary/bloc/word_bloc.dart';

import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../gemini_ai/bloc/gemini_bloc.dart';
import '../widgets/widgets.dart';



class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}
class _SettingScreenState extends State<SettingScreen> with SingleTickerProviderStateMixin {

late final ValueNotifier<int> _moreWordFetchCountController;
 final ValueNotifier<bool> isGeminiAiOn = ValueNotifier(false);

@override
  void initState() {
    int limit = context.read<WordBloc>().moreWordFetchLimit;
    _moreWordFetchCountController  = ValueNotifier<int>(limit);
    isGeminiAiOn.value = context.read<GeminiBloc>().isAiWordsGenerationOn;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return

     Scaffold(
       appBar: AppbarWidget(),
       body: Padding(
         padding: const EdgeInsets.all(8.0),
         child: LayoutBuilder(
           builder: (context, constraints) {
             return Column(
               spacing: 10,
               children: [
                 // Appearance container
                 Container(
                   width: constraints.maxWidth,
                   padding: EdgeInsets.all(15),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     border: Border.all(style: BorderStyle.solid, color: Theme.of(context).colorScheme.outline, width: 1,),
                     color: Theme.of(context).colorScheme.surfaceContainer,
                     gradient: themes[context.read<ThemeCubit>().themeType]!.containerGradient,
                   ),
                   // height: 200,
                   child: Column(
                     spacing: 30,
                     mainAxisSize: MainAxisSize.min,
                     children: [

                       AppearanceWidget(constraints: constraints),

                       
                     ],
                   ),
                 ),

                 // More FetchWord Slider container and Gemini Ai Switch
                 ValueListenableBuilder<bool>(
                   valueListenable: isGeminiAiOn,
                   builder: (context, isOn, _) {
                     return AnimatedSize(
                       duration: Duration(milliseconds: 500),
                       curve: Curves.easeInOut,
                       alignment: Alignment.topCenter,
                       child: Container(

                         width: constraints.maxWidth,
                         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                         decoration: BoxDecoration(
                           border: Border.all(style: BorderStyle.solid, color: Theme.of(context).colorScheme.outline, width: .5,),
                           borderRadius: BorderRadius.circular(20),
                           color: Theme.of(context).colorScheme.surfaceContainer,
                           gradient: themes[context.read<ThemeCubit>().themeType]!.containerGradient,

                         ),

                         child: Column(
                           spacing: 40,
                           mainAxisSize: MainAxisSize.min,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [

                             MoreWordFetchSliderWidget(
                               constraints: constraints,
                               moreWordFetchCountController: _moreWordFetchCountController,
                             ),
                             GeminiAiSwitch(isGeminiAiOn: isGeminiAiOn),

                             if(isOn)
                               GeminiModelsWidget(constraints: constraints),


                           ],
                         ),
                       ),
                     );
                   },
                 ),


               ],
             );
           }
         ),
       ),
     );


  }

}
