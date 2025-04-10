import 'package:flutter/material.dart';

class DefinitionWidget extends StatelessWidget {
  const DefinitionWidget({required this.definitions, super.key});

  final List<String> definitions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 20,
        children: [
          // "Definitions :" text
          Text(
            'Definitions :',
            style: textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w900, color: colorScheme.onSurface),
          ),
          ...List.generate(definitions.length, (index) {
            return _buildDefinitionContainer(context, definitions[index]);
          }),
        ],
      ),
    );
  }

  Widget _buildDefinitionContainer(BuildContext context,
      String definition) {
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
            .primaryFixedDim,
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
        definition,
        style:
        textTheme.bodyMedium?.copyWith(color: colorScheme.onPrimaryFixed),
      ),
    );
  }
}