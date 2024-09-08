import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class GradientProgressBar extends StatelessWidget {
  final Widget child;

  const GradientProgressBar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
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
