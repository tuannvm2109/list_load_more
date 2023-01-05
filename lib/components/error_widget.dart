import 'package:flutter/material.dart';

class ErrorListWidget extends StatelessWidget {
  const ErrorListWidget({
    Key? key,
    this.text,
    this.onTapReload,
    this.textReload,
  }) : super(key: key);

  final String? text;
  final String? textReload;
  final VoidCallback? onTapReload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10, width: double.infinity),
        Text(
          text ?? 'An error has occurred',
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
