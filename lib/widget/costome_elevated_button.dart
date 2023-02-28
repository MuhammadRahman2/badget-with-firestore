import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CostomElevatedButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final double width;
  final double height;
  const CostomElevatedButton({super.key, this.title,this.onTap, this.width = double.infinity , this.height = 40});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, height),
      ),
      onPressed: onTap,
      child: Text(title!));
  }
}
