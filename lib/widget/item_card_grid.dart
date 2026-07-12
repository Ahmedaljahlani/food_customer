import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foodking/app/modules/home/controllers/home_controller.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'item_caution.dart';
import '../app/modules/item/views/item_view.dart';
import '../util/constant.dart';
import '../util/style.dart';
import 'price_with_symbol_widget.dart';

Widget itemCardGrid(item, index, context) {

  Widget priceWithSymbol(String price, TextStyle style, {bool isStrikethrough = false, Color? color}) {
    return PriceWithSymbol(
      price: price,
      style: style,
      isStrikethrough: isStrikethrough,
      color: color,
      maxWidth: 100.w,
    );
  }

  return InkWell(
    onTap: () async {
      await Get.find<HomeController>().getItemDetails(itemID: item[index].id!);
      showBottomSheet(
        context: context,
        builder: (context) => SingleChildScrollView(
          child: ItemView(
            itemDetails: item[index],
            indexNumber: index,
          ),
        ),
      );
    },
    borderRadius: BorderRadius.circular(24.r),
    child: Container(
      height: 240.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12.r,
            spreadRadius: 2.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image section
          Container(
            height: 120.h,
            decoration: BoxDecoration(
              color: AppColor.itembg.withOpacity(0.3),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                    child: CachedNetworkImage(
                      imageUrl: item[index].cover!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[100],
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.r,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColor.primaryColor),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(Icons.image_not_supported_outlined,
                          color: Colors.grey[400],
                          size: 32.r,
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4.r,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.favorite_border,
                        size: 16.r,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),

                if (item[index].offer.isNotEmpty)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        // color: AppColor.accentColor,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        '${calculateDiscountPercentage(item[index].currencyPrice!, item[index].offer[0].currencyPrice!)}% OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content section
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title and caution icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item[index].name!,
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.w700,
                            fontSize: 12.sp,
                            height: 1.3,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
                              ),
                              child: SafeArea(
                                child: ItemCaution(
                                  itemName: item[index].name,
                                  itemCaution: item[index].caution,
                                ),
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.info_outline,
                          size: 18.r,
                          color: AppColor.gray.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),

                  // Description
                  Text(
                    item[index].description == "" ? "لايوجد تفاصيل" :  item[index].description!,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.w400,
                      fontSize: 11.sp,
                      height: 1.4,
                      color: AppColor.gray,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Price and CTA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: item[index].offer.isNotEmpty ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 100.w, // Constrain width
                              child: priceWithSymbol(
                                item[index].currencyPrice!,
                                TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                ),
                                isStrikethrough: true,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            SizedBox(
                              width: 100.w, // Constrain width
                              child: priceWithSymbol(
                                item[index].offer[0].currencyPrice!,
                                TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                ),
                                // color: AppColor.accentColor,
                              ),
                            ),
                          ],
                        )
                            : SizedBox(
                          width: 100.w, // Constrain width
                          child: priceWithSymbol(
                            item[index].currencyPrice!,
                            TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
                            ),
                          ),
                        ),
                      ),

                     // Add to cart button
                      InkWell(
                        onTap: () async {
                          await Get.find<HomeController>().getItemDetails(itemID: item[index].id!);
                          showBottomSheet(
                            context: context,
                            builder: (context) => SingleChildScrollView(
                              child: ItemView(
                                itemDetails: item[index],
                                indexNumber: index,
                              ),
                            ),
                          );                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.r),
                            gradient: const LinearGradient(
                              colors: [
                                AppColor.primaryColor,
                                AppColor.primaryColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 16.r,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/* Helper function to calculate discount percentage */
String calculateDiscountPercentage(String originalPrice, String discountedPrice) {
  try {
    double original = double.parse(originalPrice);
    double discounted = double.parse(discountedPrice);
    double discount = ((original - discounted) / original) * 100;
    return discount.toStringAsFixed(0);
  } catch (e) {
    return '0';
  }
}
