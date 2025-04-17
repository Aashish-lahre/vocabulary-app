
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget{
  const AppbarWidget({super.key});

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

