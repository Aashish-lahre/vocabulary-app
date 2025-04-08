import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/shared_preference/word_fetch_limit.dart';
import 'package:flutter_improve_vocabulary/core/theme/color_theme.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/gemini_models/gemini_models.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/shared_Preference/gemini_status_storage.dart';
import 'package:gap/gap.dart';

// import '../../../../core/blocs/later_word_fetch_bloc/later_word_fetch_event.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../gemini_ai/bloc/gemini_bloc.dart';
import '../../../../core/blocs/later_word_fetch_bloc//later_word_fetch_bloc.dart';




class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}
class _SettingScreenState extends State<SettingScreen> with SingleTickerProviderStateMixin {

late final ValueNotifier<int> _laterWordFetchCountController;
 final ValueNotifier<bool> isGeminiAiOn = ValueNotifier(false);

@override
  void initState() {
    int limit = context.read<LaterWordFetchBloc>().laterWordFetchLimit;
    _laterWordFetchCountController  = ValueNotifier<int>(limit);
    isGeminiAiOn.value = context.read<GeminiBloc>().isAiWordsGenerationOn;

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return

     Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.surface,
       appBar: _Appbar(),
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

                       _AppearanceWidget(constraints: constraints),

                       // _AccentColorWidget(constraints: constraints,),

                       // _TextSizeSliderWidget(constraints: constraints),
                     ],
                   ),
                 ),

                 // LaterFetchWord Slider container and Gemini Ai Switch
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

                             _LaterWordFetchSliderWidget(
                               constraints: constraints,
                               laterWordFetchCountController: _laterWordFetchCountController,
                             ),
                             _GeminiAiSwitch(isGeminiAiOn: isGeminiAiOn),

                             if(isOn)
                               _GeminiModelsWidget(constraints: constraints),


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




class _Appbar extends StatelessWidget implements PreferredSizeWidget{
  const _Appbar();

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,

      child: Container(
        height: preferredSize.height,
        padding: EdgeInsets.all(10),
        child: Row(
          // spacing: 50,
          children: [
            Gap(20),
            IconButton(onPressed: () => Navigator.of(context).pop(), icon: Icon(Icons.arrow_back_rounded, color: Theme.of(context).colorScheme.onSurface
              ,)),
            Gap(20),
            Text('Settings', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSurface),),


          ],
        ),

      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight+50);
}




class _AppearanceWidget extends StatefulWidget {
  final BoxConstraints constraints;
  const _AppearanceWidget({required this.constraints});

  @override
  State<_AppearanceWidget> createState() => _AppearanceWidgetState();
}
class _AppearanceWidgetState extends State<_AppearanceWidget> {

  String  themeModeLabel(int index) {
    return {
      0: 'Light',
      1: 'Dark',
      2: 'Auto'
    }[index] ?? 'Light';
  }

  late int _selectedIndex;

  @override
  void initState() {
    _selectedIndex = themes.keys.toList().indexOf(context.read<ThemeCubit>().themeType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 10,
          children: [
            Icon(Icons.sunny, color: Theme.of(context).colorScheme.onSecondaryContainer,),
            Text('Appearance', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),),
          ],
        ),
        Gap(20),
        SizedBox(
          width: widget.constraints.maxWidth,
          height: MediaQuery.of(context).size.height * .15,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
              itemCount: themes.length,
              itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    context.read<ThemeCubit>().changeThemeType(themes.keys.toList()[index]);
                    _selectedIndex = index;
                  });


                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: themes[themes.keys.toList()[index]]!.colorScheme.primary,
                        gradient: themes[themes.keys.toList()[index]]!.containerGradient,
                        borderRadius: BorderRadius.circular(10),
                        border:
                         _selectedIndex == index ? Border.all(color: Color(0xFF6666FF), style: BorderStyle.solid, width: 4) : null,
                      ),

                      width: widget.constraints.maxWidth * 0.28,
                      height: widget.constraints.maxWidth * 0.20,

                      // child:
                      // ClipRRect(
                      //     borderRadius: BorderRadius.circular(5),
                      //     child: Image.asset('assets/images/mode_$index.png', fit: BoxFit.cover,)),
                    ),
                    Text(themes.keys.toList()[index].label, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),)
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}





class _LaterWordFetchSliderWidget extends StatefulWidget {
  final BoxConstraints constraints;
  final ValueNotifier<int> laterWordFetchCountController;
  const _LaterWordFetchSliderWidget({required this.constraints, required this.laterWordFetchCountController});

  @override
  State<_LaterWordFetchSliderWidget> createState() => _LaterWordFetchSliderWidgetState();
}
class _LaterWordFetchSliderWidgetState extends State<_LaterWordFetchSliderWidget> {

@override
  void initState() {
  widget.laterWordFetchCountController.value = context.read<LaterWordFetchBloc>().laterWordFetchLimit;
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
                
                              value: widget.laterWordFetchCountController.value.toDouble(),
                              min: 1,
                              max: 10,
                              divisions: 9,
                              label: widget.laterWordFetchCountController.value.toString(),
                              onChanged: (changedValue) {
                                setState(() {
                                  widget.laterWordFetchCountController.value = changedValue.toInt();
                                  context.read<LaterWordFetchBloc>().add(ChangeLaterWordFetchCount(changedCount: changedValue.toInt()));
                                  WordFetchLimit().changeWordFetchLimit(changedValue.toInt());
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




class _GeminiAiSwitch extends StatefulWidget {
  final ValueNotifier<bool> isGeminiAiOn;
  const _GeminiAiSwitch({required this.isGeminiAiOn});

  @override
  State<_GeminiAiSwitch> createState() => _GeminiAiSwitchState();
}
class _GeminiAiSwitchState extends State<_GeminiAiSwitch> {
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
          widget.isGeminiAiOn.value = value;
          context.read<GeminiBloc>().add(ToggleGenerateWordsWithAiSwitchEvent(isOn: value));
          GeminiStatusStorage().changeGeminiStatus(value);
        });
      },
    );
  }
}



class _GeminiModelsWidget extends StatefulWidget {
  final BoxConstraints constraints;
  const _GeminiModelsWidget({required this.constraints});

  @override
  State<_GeminiModelsWidget> createState() => _GeminiModelsWidgetState();
}
class _GeminiModelsWidgetState extends State<_GeminiModelsWidget> {


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