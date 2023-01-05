import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key? key,
    this.assetImage = "assets/images/empty_filter_product.png",
    this.text,
    this.onTapReload,
    this.textReload,
    this.assetHeight = 150,
    this.assetWidth = 220,
    this.marginText = 10,
  }) : super(key: key);

  final String assetImage;
  final double assetHeight;
  final double assetWidth;
  final double marginText;

  final String? text;
  final String? textReload;
  final VoidCallback? onTapReload;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: assetWidth,
          height: assetHeight,
          child: Image.asset(
            assetImage,
            colorBlendMode: BlendMode.colorDodge,
          ),
        ),
        SizedBox(height: marginText),
        Text(
          text ?? 'Empty',
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        if (onTapReload != null)
          InkWell(
            onTap: () {
              onTapReload?.call();
            },
            child: Text(
              textReload ?? 'Press to reload',
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          )
      ],
    );
  }
}
