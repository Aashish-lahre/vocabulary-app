
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

  // String  themeModeLabel(int index) {
  //   return {
  //     0: 'Light',
  //     1: 'Dark',
  //     2: 'Auto'
  //   }[index] ?? 'Light';
  // }

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
        children: [
          Icon(
            Icons.sunny,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 10),
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
          ),
        ],
      ),
      const Gap(20),
      SizedBox(
  width: widget.constraints.maxWidth,
  height: MediaQuery.of(context).size.height * 0.20,
  child: Padding(
    padding: const EdgeInsets.only(left: 20.0), // Move start position slightly forward
    child: PageView.builder(
      controller: PageController(viewportFraction: 0.35),
      itemCount: themes.length,
      padEnds: false, // prevents the first and last items from centering
      itemBuilder: (context, index) {
        final themeKey = themes.keys.toList()[index];
        final theme = themes[themeKey]!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0), // spacing between items
          child: GestureDetector(
            onTap: () {
              setState(() {
                context.read<ThemeCubit>().changeThemeType(themeKey);
                _selectedIndex = index;
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    gradient: theme.containerGradient,
                    borderRadius: BorderRadius.circular(10),
                    border: _selectedIndex == index
                        ? Border.all(
                            color: const Color(0xFF6666FF),
                            width: 4,
                          )
                        : null,
                  ),
                  width: widget.constraints.maxWidth * 0.3,
                  height: widget.constraints.maxWidth * 0.22,
                ),
                const SizedBox(height: 10),
                Text(
                  themeKey.label,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSecondaryContainer,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ),
),

    ],
  );
}

}


