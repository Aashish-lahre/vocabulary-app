import 'package:easy_radio/easy_radio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_improve_vocabulary/core/shared_preference/word_fetch_limit.dart';
import 'package:flutter_improve_vocabulary/core/theme/color_theme.dart';
import 'package:flutter_improve_vocabulary/features/gemini_ai/shared_Preference/gemini_status_storage.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../gemini_ai/bloc/gemini_bloc.dart';
import '../../blocs/LaterWordFetchBloc/later_word_fetch_bloc.dart';




enum AccentColor {
  blue(color: Colors.blue),
  yellow(color: Colors.yellow),
  green(color: Colors.green),
  purple(color: Colors.purple),
  red(color: Colors.red);

  const AccentColor({required this.color}); // Correct constructor
  final Color color;
}

enum AnimationType {
  rotate,
  fade,
  typer,
  typewriter,
  scale,
  colorize,
  textLiquidFill,
  wavy,
  flicker
}




List<AccentColor> _accentColors = [AccentColor.blue, AccentColor.yellow, AccentColor.green, AccentColor.purple, AccentColor.red];

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

late final ValueNotifier<int> _laterWordFetchCountController;

@override
  void initState() {
    int limit = context.read<LaterWordFetchBloc>().laterWordFetchLimit;
    _laterWordFetchCountController  = ValueNotifier<int>(limit);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return

     Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
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
                     color: Theme.of(context).colorScheme.surfaceContainer,
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
                 Container(
                   width: constraints.maxWidth,
                   padding: EdgeInsets.all(15),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     color: Theme.of(context).colorScheme.surfaceContainer,
                     // color: Colors.pink.shade200,

                   ),
                   child: Column(
                     spacing: 30,
                     mainAxisSize: MainAxisSize.min,
                     children: [
                       _LaterWordFetchSliderWidget(constraints: constraints, laterWordFetchCountController: _laterWordFetchCountController,),

                       _TextAnimationWidget(constraints: constraints),

                       _GeminiAiSwitch(),

                     ],
                   ),
                 ),
                 // Row(
                 //   mainAxisAlignment: MainAxisAlignment.end,
                 //   children: [
                 //     FilledButton(
                 //
                 //         onPressed: () {
                 //       context.read<LaterWordFetchBloc>().add(ChangeLaterWordFetchCount(changedCount: _laterWordFetchCountController.value));
                 //       Navigator.of(context).pop();
                 //     }, child: Text('Save'))
                 //   ],
                 // ),
               ],
             );
           }
         ),
       ),
     );


  }
}

class _Appbar extends StatelessWidget implements PreferredSizeWidget{
  const _Appbar({super.key});

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
  const _AppearanceWidget({required this.constraints, super.key});

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

  int _selectedIndex = 0;
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
                        color: themes[themes.keys.toList()[index]]!.primary,
                        borderRadius: BorderRadius.circular(10),
                        border:
                         _selectedIndex == index ? Border.all(color: Theme.of(context).colorScheme.onPrimary, style: BorderStyle.solid, width: 4) : null,
                      ),

                      width: widget.constraints.maxWidth * 0.28,
                      height: widget.constraints.maxWidth * 0.20,

                      // child:
                      // ClipRRect(
                      //     borderRadius: BorderRadius.circular(5),
                      //     child: Image.asset('assets/images/mode_$index.png', fit: BoxFit.cover,)),
                    ),
                    Text(themes.keys.toList()[index].name, style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),)
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




class _TextSizeSliderWidget extends StatefulWidget {
  final BoxConstraints constraints;
  const _TextSizeSliderWidget({required this.constraints, super.key});

  @override
  State<_TextSizeSliderWidget> createState() => _TextSizeSliderWidgetState();
}

class _TextSizeSliderWidgetState extends State<_TextSizeSliderWidget> {

  double _textSize = 12;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.constraints.maxWidth * .3,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 10,
            children: [
              Icon(Icons.text_fields_rounded),
              Text('Text size')
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('A', style: Theme.of(context).textTheme.bodyMedium,),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  overlayShape: RoundSliderOverlayShape(overlayRadius: 8.0), ),// Default is 24.0
                child: Slider.adaptive(

                    value: _textSize,
                  min: 12,
                  max: 18,
                  divisions: 3,
                  label: _textSize.toString(),
                    onChanged: (changedValue) {
                  setState(() {
                    _textSize = changedValue;
                  });
                },


                ),
              ),
              Text('A', style: Theme.of(context).textTheme.bodyLarge,)
            ],
          ),
        ),
      ],
    );
  }
}


class _LaterWordFetchSliderWidget extends StatefulWidget {
  final BoxConstraints constraints;
  final ValueNotifier<int> laterWordFetchCountController;
  const _LaterWordFetchSliderWidget({required this.constraints, required this.laterWordFetchCountController, super.key});

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


class _TextAnimationWidget extends StatefulWidget {
  final BoxConstraints constraints;
  const _TextAnimationWidget({required this.constraints, super.key});

  @override
  State<_TextAnimationWidget> createState() => _TextAnimationWidgetState();
}

class _TextAnimationWidgetState extends State<_TextAnimationWidget> {


  List<DropdownMenuItem<AnimationType>> _animationType(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer);

    return [
      DropdownMenuItem(value: AnimationType.rotate,child: Text('Rotate', style: textStyle,),),
      DropdownMenuItem(value: AnimationType.fade,child: Text('Fade', style: textStyle,),),
      DropdownMenuItem(value: AnimationType.typer,child: Text('Typer', style: textStyle,),),
      DropdownMenuItem(value: AnimationType.typewriter,child: Text('Typewriter', style: textStyle,),),
      DropdownMenuItem(value: AnimationType.scale,child: Text('Scale', style: textStyle,),),
      DropdownMenuItem(value: AnimationType.colorize,child: Text('Colorize', style: textStyle,),),
      DropdownMenuItem(value: AnimationType.textLiquidFill,child: Text('TextLiquidFill', style: textStyle,),),
      DropdownMenuItem(value: AnimationType.wavy,child: Text('Wavy', style: textStyle,),),
      DropdownMenuItem(value: AnimationType.flicker,child: Text('Flicker', style: textStyle,),),


    ];
  }

  AnimationType? _selectedAnimationType = AnimationType.typer;

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(

            child: Row(
              spacing: 10,
              children: [
          Icon(Icons.animation),
          Text('Text animation', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondaryContainer),),
        ],)),

        Expanded(
            child: DropdownButton(
                items: _animationType(context),
                value: _selectedAnimationType,
                onChanged: (changedType) {
                  setState(() {
                    _selectedAnimationType = changedType;
                  });
                },)
        ),



      ],
    );
  }
}


class _GeminiAiSwitch extends StatefulWidget {

  const _GeminiAiSwitch({super.key});

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
      title: Row(
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

          context.read<GeminiBloc>().add(ToggleGenerateWordsWithAiSwitchEvent(isOn: _isOn));
          GeminiStatusStorage().changeGeminiStatus(_isOn);
        });
      },
    );
  }
}
