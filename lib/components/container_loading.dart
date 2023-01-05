import 'package:flutter/material.dart';

class ContainerLoading extends StatelessWidget {
  const ContainerLoading({
    Key? key,
    required this.loadingWidget,
    required this.child,
    this.isLoading = true,
    this.width,
    this.height,
  }) : super(key: key);

  final Widget loadingWidget;
  final Widget child;
  final bool isLoading;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 700),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: Tween<double>(
                begin: 0,
                end: 1,
              ).animate(animation),
              child: child,
            );
          },
          child: isLoading ? loadingWidget : child,
        ),
      ),
    );
  }
}
