// ignore_for_file: sort_child_properties_last

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../menu/controllers/menu_controller.dart';
import '../../menu/views/menu_view.dart';
import 'home_vew_shimmer.dart';

Widget homeMenuSection() {
  return GetBuilder<MenuuController>(
    builder: (menuController) => Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "OUR_MENU".tr,
                  style: fontBold,
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => MenuView(
                      fromHome: true,
                      categoryId: 0,
                    ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: AppColor.primaryColor.withAlpha(30),
                    ),
                    child: Text(
                      "VIEW_ALL".tr,
                      style: fontRegularBoldwithColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        menuController.categoryDataList.isNotEmpty ? SizedBox(
          height: 35.h,
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: menuController.categoryDataList.length,
            itemBuilder: (BuildContext context, index) {
              final category = menuController.categoryDataList[index];
              final isSelected = menuController.currentIndex == index;

              return GestureDetector(
                onTap: () {
                  menuController.getCategoryWiseItemDataList(menuController.categoryDataList[index].slug!);
                  menuController.setCategoryIndex(index);
                  menuController.fromHome = true;
                  menuController.currentIndex = index;
                  (context as Element).markNeedsBuild();

                  Get.to(() => MenuView(
                    fromHome: true,
                    categoryId: index,
                  ));
                },
                child: Container(
                  height: 60, // Adjusted container height
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColor.primaryColor : AppColor.searchBgColor,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 25.w,
                        height: 40.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2), // Slight background
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: category.cover!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[400]!,
                              child: Container(color: Colors.grey),
                            ),
                            errorWidget: (context, url, error) => Icon(Icons.error, size: 20.w),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        category.name.toString(),
                        style: TextStyle(
                          // fontSize: 12, // Added font size back
                          fontSize: 12.sp,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),

                    ],
                  ),
                ),
              );
            },
          ),
        )
            : menuSectionShimmer(),
      ],
    ),
  );
}




// Widget homeMenuSection() {
//   return GetBuilder<MenuuController>(
//     builder: (menuController) => Column(
//       children: [
//         SizedBox(
//           child:
//           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//             Text(
//               "OUR_MENU".tr,
//               style: fontBold,
//             ),
//             InkWell(
//               onTap: () {
//                 Get.to(() => MenuView(
//                       fromHome: true,
//                       categoryId: 0,
//                     ));
//               },
//               child: Container(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.symmetric(vertical: 4.r, horizontal: 8.r),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16.r),
//                   color: AppColor.primaryColor.withAlpha(30),
//                 ),
//                 child: Text(
//                   "VIEW_ALL".tr,
//                   style: fontRegularBoldwithColor,
//                 ),
//               ),
//             )
//           ]),
//         ),
//         SizedBox(
//           height: 12.h,
//         ),
//         menuController.categoryDataList.isNotEmpty
//             ? SizedBox(
//                 width: double.infinity,
//                 height: 110.h,
//                 child: ListView.builder(
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: menuController.categoryDataList.length,
//                     itemBuilder: (BuildContext context, index) {
//                       return InkWell(
//                         onTap: () {
//                           Get.to(() => MenuView(
//                                 fromHome: true,
//                                 categoryId: index,
//                               ));
//                         },
//                         child: Padding(
//                           padding: EdgeInsets.only(top: 10, left: 4.w, right: 10.w, bottom: 10),
//                           child: Container(
//                             height: 80.h,
//                             width: 90.w,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16.r),
//                               color: Colors.white.withOpacity(0.8),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: AppColor.searchBarbg,
//                                   offset: const Offset(
//                                     0.0,
//                                     0.0,
//                                   ),
//                                   blurRadius: 10.r,
//                                   spreadRadius: 3.r,
//                                 ),
//                               ],
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   height: 30.h,
//                                   width: 40.w,
//                                   child: CachedNetworkImage(
//                                     imageUrl: menuController.categoryDataList[index].cover!,
//                                     imageBuilder: (context, imageProvider) =>
//                                         Container(
//                                       decoration: BoxDecoration(
//                                         image: DecorationImage(
//                                           image: imageProvider,
//                                           fit: BoxFit.contain,
//                                         ),
//                                       ),
//                                     ),
//                                     placeholder: (context, url) => Shimmer.fromColors(
//                                       child: Container(
//                                           height: 50.h,
//                                           width: 50.w,
//                                           color: Colors.grey),
//                                       baseColor: Colors.grey[300]!,
//                                       highlightColor: Colors.grey[400]!,
//                                     ),
//                                     errorWidget: (context, url, error) =>
//                                         const Icon(Icons.error),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 8.h,
//                                 ),
//                                 Padding(
//                                   padding:
//                                       EdgeInsets.symmetric(horizontal: 8.w),
//                                   child: Center(
//                                     child: Text(
//                                       menuController
//                                           .categoryDataList[index].name
//                                           .toString(),
//                                       style: fontSmallBold,
//                                       textAlign: TextAlign.center,
//                                       overflow: TextOverflow.ellipsis,
//                                       maxLines: 2,
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//               )
//             : menuSectionShimmer(),
//       ],
//     ),
//   );
// }
