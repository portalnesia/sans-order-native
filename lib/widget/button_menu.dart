import 'package:flutter/material.dart';
import 'package:sans_order/widget/card.dart';

class ButtonMenu extends StatelessWidget {
  final void Function()? onPress;
  final Widget icon;
  final Widget text;

  const ButtonMenu({super.key, this.onPress,required this.icon,required this.text});

  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: shapeBorder,
        child: InkWell(
          onTap: onPress,
          borderRadius: borderRadius,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(height: 20),
                text
              ],
            ),
          ),
        )
      )
    );
  }

}