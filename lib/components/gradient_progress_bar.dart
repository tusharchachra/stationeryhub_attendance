import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GradientProgressBar extends StatelessWidget {
  final Widget? child;
  final Color? baseCol;
  final Color? highlightCol;
  final ShimmerDirection? shimmerDirection;
  final Duration? period;
  final Size? size;

  const GradientProgressBar({
    super.key,
    required this.size,
    this.child,
    this.baseCol,
    this.highlightCol,
    this.shimmerDirection,
    this.period,
  });

  @override
  Widget build(BuildContext context) {
    /* return Shimmer(
        //period: period ?? Duration(milliseconds: 1500),
        //direction: shimmerDirection ?? ShimmerDirection.ltr,
        gradient: LinearGradient(colors: [
          //baseCol ?? Colors.grey.shade300,
          //baseCol ?? Colors.grey.shade300,
          highlightCol ?? Colors.grey.shade100,
          baseCol ?? Colors.grey.shade300,
          baseCol ?? Colors.grey.shade300,
          baseCol ?? Colors.grey.shade300,
          highlightCol ?? Colors.grey.shade100,
        ]),
        child: child ?? Container());*/

    return Shimmer.fromColors(
      period: period ?? const Duration(milliseconds: 1500),
      baseColor: baseCol ?? Colors.grey.shade300,
      highlightColor: highlightCol ?? Colors.grey.shade100,
      direction: shimmerDirection ?? ShimmerDirection.ltr,
      child: child ??
          Container(
            width: size?.width,
            height: size?.height,
            color: Colors.black,
          ),
    );
  }
  /*final aspectRatio = widget.size.height / widget.size.width;
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          */ /*width: widget.size.width,
          height: widget.size.height,*/ /*
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              tileMode: TileMode.repeated,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              transform: SlideGradient(
                controller.value,
                widget.size.height * aspectRatio,
              ),
              colors: [Colors.black26, Colors.black12] */ /*_colors*/ /*,
            ),
          ),
        );
      },
    );
  }*/
}
/*

class SlideGradient implements GradientTransform {
  final double value;
  final double offset;
  const SlideGradient(this.value, this.offset);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final dist = value * (bounds.width + offset);
    return Matrix4.identity()..translate(dist);
  }
}
*/
