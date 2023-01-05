import 'package:flutter/material.dart';

class LoadingMoreWidget extends StatelessWidget {
  const LoadingMoreWidget({
    Key? key,
    this.size = 50,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
