
import 'package:better_skeleton/better_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';



class WordCardShimmer extends StatefulWidget {

  const WordCardShimmer({super.key});

  @override
  State<WordCardShimmer> createState() => _WordCardShimmerState();
}

class _WordCardShimmerState extends State<WordCardShimmer> with SingleTickerProviderStateMixin{

  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 800))..forward()..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController..stop()..dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: Theme.of(context).colorScheme.primaryContainer,

      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(50),
            // wordName and volume icon
            Row(
              // mainAxisAlignment: MainAxisAlignment.start,
        
              mainAxisAlignment: MainAxisAlignment.start,
        
        
              spacing: 20,
              children: [
                Gap(10),
                buildAnimatedSkeleton(width: 150, height: 40),
                IconButton(onPressed: () {}, icon: Icon(Icons.volume_up_rounded, color: colorScheme.onSurface,)),
              ],
            ),
            Gap(20),
        
            // black banner container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: colorScheme.secondary,
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                spacing: 30,
                children: [
                  Icon(Icons.arrow_downward_rounded, color: colorScheme.onSecondary,),
                  Text('Chose Definition to learn.', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSecondary),),
                ],
              ),
            ),
        
            // Noun and Verb definitions....
            ...List.generate(3, (index) {
              return Definitions(animationController: _animationController,);
        
            }),
        
        
        
        
        
          ],
        ),
      ),
    );
  }

  AnimatedSkeleton buildAnimatedSkeleton({required double width, required double height}) => AnimatedSkeleton(listenable: _animationController, child: Container(width: width, height: height, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).colorScheme.primary),),);
}

Widget _buildDefinitionContainer(BuildContext context, AnimationController animationController) {
  return AnimatedSkeleton(
    listenable: animationController,
    child: Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(8),
      // alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 2,
            offset: Offset(0,1),

          )
        ],
      ),
    ),
  );
}

class Definitions extends StatelessWidget {
  final AnimationController animationController;
  const Definitions({required this.animationController, super.key});




  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSkeleton(listenable: animationController, child: Container(width: 100, height: 40, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).colorScheme.primary),),),
          ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              itemBuilder: (_, index) {
                return _buildDefinitionContainer(context, animationController);
              }),
        ],
      ),
    );
  }


}


