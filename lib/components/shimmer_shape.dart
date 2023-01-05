import 'package:flutter/material.dart';

class ShimmerShape extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final double? roundRadius;

  const ShimmerShape({
    Key? key,
    this.height,
    this.width,
    this.margin,
    this.roundRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 20,
      width: width ?? 260,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(roundRadius ?? 20)),
        color: const Color(0xFFfcf9f6),
      ),
    );
  }
}
