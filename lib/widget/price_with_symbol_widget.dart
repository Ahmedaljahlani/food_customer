import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/constant.dart';

class PriceWithSymbol extends StatelessWidget {
  final String price;
  final TextStyle style;
  final bool isStrikethrough;
  final Color? color;
  final double? maxWidth;

  const PriceWithSymbol({
    super.key,
    required this.price,
    required this.style,
    this.isStrikethrough = false,
    this.color,
    this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    // Clean price string to remove dollar sign and other currency characters
    // Strip currency symbols ($, SAR, ر.س, etc.) but preserve digits and decimal points
    final cleanedPrice = price
        .replaceAll(RegExp(r'\$'), '')           // dollar sign
        .replaceAll(RegExp(r'\bSAR\b', caseSensitive: false), '') // SAR text
        .replaceAll(RegExp(r'ر\.س'), '')          // Arabic ر.س
        .replaceAll(RegExp(r'[ريال]+'), '')       // Arabic ريال
        .trim();

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? 120.w),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            child: Text(
              cleanedPrice,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: isStrikethrough
                  ? style.copyWith(
                      decoration: TextDecoration.lineThrough,
                      color: color ?? AppColor.gray.withOpacity(0.6),
                    )
                  : style.copyWith(color: color ?? Colors.black),
            ),
          ),
          SizedBox(width: 2.w),
          Padding(
            padding: EdgeInsets.only(bottom: (style.fontSize ?? 14.sp) * 0.1),
            child: SvgPicture.asset(
              Images.ryalSymbol,
              height: (style.fontSize ?? 14.sp) * 0.9,
              color: color ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
