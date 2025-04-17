
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/color_theme.dart';
import '../../../../core/theme/cubit/theme_cubit.dart';


class AppearanceWidget extends StatefulWidget {
  final BoxConstraints constraints;
  const AppearanceWidget({super.key, required this.constraints});

  @override
  State<AppearanceWidget> createState() => AppearanceWidgetState();
}
class AppearanceWidgetState extends State<AppearanceWidget> {

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


