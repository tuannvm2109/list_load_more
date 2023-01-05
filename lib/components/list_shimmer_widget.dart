import 'package:flutter/material.dart';
import 'package:list_load_more/components/shimmer_shape.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmerWidget extends StatelessWidget {
  const ListShimmerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      period: const Duration(milliseconds: 1500),
      baseColor: const Color(0xFFfcf9f6),
      highlightColor: const Color(0xFFD9D9D9),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: 30,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ClipOval(child: ShimmerShape(width: 60, height: 60)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      ShimmerShape(width: 250),
                      SizedBox(height: 5),
                      ShimmerShape(width: 150)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
