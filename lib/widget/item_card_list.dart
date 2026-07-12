// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../app/modules/home/controllers/home_controller.dart';
import 'item_card_grid.dart';
import 'item_caution.dart';
import '../app/modules/item/views/item_view.dart';
import '../util/constant.dart';
import '../util/style.dart';
import 'price_with_symbol_widget.dart';

Widget itemCardList(item, index, context) {
  Widget priceWithSymbol(String price, TextStyle style, {bool isStrikethrough = false, Color? color}) {
    return PriceWithSymbol(
      price: price,
      style: style,
      isStrikethrough: isStrikethrough,
      color: color,
      maxWidth: 100.w,
    );
  }

  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: InkWell(
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
        height: 100.h,
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
        child: Row(
          children: [
            // Image section with padding
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Container(
                width: 100.w,
                decoration: BoxDecoration(
                  color: AppColor.itembg.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.r),
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
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.grey[400],
                              size: 32.r,
                            ),
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
            ),

            // Content section
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 8.h,
                  horizontal: 12.w,
                ),
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
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24.r),
                                  ),
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
                      item[index].description == "" ? "لايوجد تفاصيل" : item[index].description!,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontWeight: FontWeight.w400,
                        fontSize: 11.sp,
                        height: 1.4,
                        color: AppColor.gray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Price and CTA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: item[index].offer.isNotEmpty
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              priceWithSymbol(
                                item[index].currencyPrice!,
                                TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                ),
                                isStrikethrough: true,
                              ),
                              SizedBox(height: 2.h),
                              priceWithSymbol(
                                item[index].offer[0].currencyPrice!,
                                TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.sp,
                                ),
                                // color: AppColor.accentColor,
                              ),
                            ],
                          )
                              : priceWithSymbol(
                            item[index].currencyPrice!,
                            TextStyle(
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.w700,
                              fontSize: 12.sp,
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
                            );
                          },
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
    ),
  );
}

