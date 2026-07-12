// ignore_for_file: must_be_immutable, sort_child_properties_last, deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../util/constant.dart';
import '../../../../util/style.dart';
import '../../../../widget/bottom_cart_widget.dart';
import '../../../../widget/item_card_grid.dart';
import '../../../../widget/item_card_list.dart';
import '../../../../widget/no_items_available.dart';
import '../../home/widget/home_vew_shimmer.dart';
import '../../search/views/search_view.dart';
import '../controllers/menu_controller.dart';
import '../widget/menu_view_shimmer.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MenuView extends StatefulWidget {
  final bool? fromHome;
  final int? categoryId;

  const MenuView({
    Key? key,
    this.fromHome,
    this.categoryId,
  }) : super(key: key);

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  final box = GetStorage();
  final MenuuController menuController = Get.put(MenuuController());
  late ScrollController _scrollController;
  final double _itemWidth = 120.0; // Approximate width of each category item
  final double _spacing = 8.0; // Spacing between items

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();

    if (box.read('viewValue') == null) {
      box.write('viewValue', 0);
    }

    if (menuController.categoryDataList.isNotEmpty) {
      menuController.getCategoryWiseItemDataList(
          menuController.categoryDataList[widget.categoryId!].slug!
      );
      menuController.fromHome = widget.fromHome ?? false;
      menuController.currentIndex = widget.categoryId!;

      // Scroll to the selected category after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToIndex(widget.categoryId!);
      });
    }
  }

  void _scrollToIndex(int index) {
    if (!_scrollController.hasClients ||
        menuController.categoryDataList.isEmpty) return;

    // Calculate the position to scroll to
    final double position = index * (_itemWidth + _spacing) -
        (MediaQuery.of(Get.context!).size.width / 2 - _itemWidth / 2);

    // Ensure we don't scroll beyond bounds
    final double maxScroll = _scrollController.position.maxScrollExtent;
    final double adjustedPosition = position.clamp(0.0, maxScroll);

    _scrollController.animateTo(
      adjustedPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MenuuController>(
      builder: (menuController) => Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 1.h),

                menuController.categoryDataList.isNotEmpty
                    ? _buildCategoryList()
                    : _buildCategoryShimmer(),
                SizedBox(height: 4.h),

                // Use GetBuilder to rebuild when viewValue changes
                GetBuilder<MenuuController>(
                  builder: (_) {
                    // This will force rebuild when viewValue changes
                    final viewValue = box.read('viewValue') ?? 0;
                    return menuController.categoryDataList.isNotEmpty
                        ? menuVegNonVegSection(
                          context,
                          box,
                          widget.fromHome!,
                          widget.categoryId!,
                        )
                        : Expanded(child: menuItemSectionGridShimmer());
                  },
                ),
              ],
            ),
            if (widget.fromHome!) const BottomCartWidget(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return widget.fromHome! ? AppBar(
      leadingWidth: 150.w,
      leading: Row(
        children: [
          IconButton(
            icon: SvgPicture.asset(
              Images.back,
              height: 24.h,
              width: 24.w,
              colorFilter: const ColorFilter.mode(
                  AppColor.primaryColor, BlendMode.srcIn),
            ),
            onPressed: () => Get.back(),
          ),
          SizedBox(width: 5.w),
          Image.asset(Images.logo, width: 85.w),

          // const Center(
          //   child: Text(
          //     AppConstant.appName,
          //     style: TextStyle(
          //       fontSize: 22,
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
        ],
      ),
      actions: [_buildSearchButton()],
      elevation: 0,
      backgroundColor: Colors.white,
    ) : AppBar(
      leadingWidth: 110.w,
      leading: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w),
        child: Image.asset(Images.logo, width: 85.w),

        // child: const Center(
        //   child: Text(
        //     AppConstant.appName,
        //     style: TextStyle(
        //       fontSize: 22,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
      ),
      actions: [_buildSearchButton()],
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildSearchButton() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, right: 16.w, left: 16.w),
      child: SizedBox(
        height: 25.h,
        width: 25.w,
        child: InkWell(
          splashColor: Colors.transparent,
          onTap: () => Get.to(() => const SearchView()),
          child: SvgPicture.asset(
            Images.iconSearch,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 35.h,
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: menuController.categoryDataList.length,
        itemBuilder: (context, index) {
          final isSelected = menuController.currentIndex == index;
          final category = menuController.categoryDataList[index];

          return GestureDetector(
            onTap: () {
              menuController.getCategoryWiseItemDataList(category.slug!);
              menuController.setCategoryIndex(index);
              menuController.fromHome = false;
              menuController.currentIndex = index;
              _scrollToIndex(index);
            },
            child: Container(
              margin: EdgeInsets.only(right: _spacing.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected ? AppColor.primaryColor : AppColor.searchBgColor,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCategoryImage(category.cover!),
                  SizedBox(width: 8.w),
                  Text(
                    category.name!,
                    style: TextStyle(
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
    );
  }

  Widget _buildCategoryImage(String imageUrl) {
    return Container(
      width: 25.w,
      height: 40.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.grey[300]),
          errorWidget: (context, url, error) => Icon(Icons.error, size: 20.w),
        ),
      ),
    );
  }

  Widget _buildCategoryShimmer() {
    return SizedBox(
      height: 35.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            width: _itemWidth.w,
            margin: EdgeInsets.only(right: _spacing.w),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(50.r),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItems() {
    return menuVegNonVegSection(
        Get.context!,
        box,
        widget.fromHome!,
        widget.categoryId!,
    );
  }

  Widget _buildMenuItemsShimmer() {
    return Expanded(child: menuItemSectionGridShimmer());
  }
}

Widget menuSection(bool fromHome, int categoryId) {
  return GetBuilder<MenuuController>(
    builder: (menuController) => Column(
      children: [
        SizedBox(height: 0.h),
        SizedBox(
          height: 35.h,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: menuController.categoryDataList.length,
            itemBuilder: (BuildContext context, index) {
              // final isSelected = fromHome
              //     ? categoryId == index
              //     : menuController.currentIndex == index;

              // final category = menuController.categoryDataList[index];
              final isSelected = menuController.currentIndex == index;

              return InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  menuController.getCategoryWiseItemDataList(menuController.categoryDataList[index].slug!);
                  menuController.setCategoryIndex(index);
                  menuController.fromHome = false;
                  menuController.currentIndex = index;
                  (context as Element).markNeedsBuild();
                },
                child: Container(
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
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: menuController.categoryDataList[index].cover!,
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
                        menuController.categoryDataList[index].name.toString(),
                        style: TextStyle(
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
        ),
        SizedBox(height: 4.h),


      ],
    ),
  );
}


Widget menuVegNonVegSection(context, box, bool fromHome, int categoryId) {
  return GetBuilder<MenuuController>(
    builder: (menuController) => Expanded(
      child: RefreshIndicator(
        color: AppColor.primaryColor,
        onRefresh: () async {
          menuController.getCategoryWiseItemDataList(menuController
              .categoryDataList[menuController.currentIndex].slug!);
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),

              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Column(
                children: [

                  Padding(
                    padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            menuController.getItemVgDataList(10, menuController.categoryDataList[menuController.currentIndex].slug!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21.r),
                              color: menuController.vegNonVegActiveList == 10
                                  ? Colors.white
                                  : AppColor.itembg,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.itembg,
                                  offset: const Offset(
                                    0.0,
                                    0.0,
                                  ),
                                  blurRadius: 10.r,
                                  spreadRadius: 2.r,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      Images.nonVeg,
                                      height: 20.h,
                                      width: 30.w,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      "NON_VEG".tr,
                                      style: fontRegularBold,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    menuController.vegNonVegActiveList == 10
                                        ? SvgPicture.asset(Images.IconClose,
                                            width: 20.w,
                                            height: 20.h,
                                            fit: BoxFit.contain,
                                            colorFilter: const ColorFilter.mode(
                                                AppColor.primaryColor,
                                                BlendMode.srcIn))
                                        : const SizedBox(),
                                  ]),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 24.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            menuController.getItemVgDataList(
                                5,
                                menuController
                                    .categoryDataList[
                                        menuController.currentIndex]
                                    .slug!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(21.r),
                              color: menuController.vegNonVegActiveList == 5
                                  ? Colors.white
                                  : AppColor.itembg,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColor.itembg,
                                  offset: const Offset(
                                    0.0,
                                    0.0,
                                  ),
                                  blurRadius: 10.r,
                                  spreadRadius: 2.r,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 6.h),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      Images.veg,
                                      height: 20.h,
                                      width: 30.w,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      "VEG".tr,
                                      style: fontRegularBold,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    menuController.vegNonVegActiveList == 5
                                        ? SvgPicture.asset(Images.IconClose,
                                            width: 20.w,
                                            height: 20.h,
                                            fit: BoxFit.contain,
                                            colorFilter: const ColorFilter.mode(
                                                AppColor.primaryColor,
                                                BlendMode.srcIn))
                                        : const SizedBox(),
                                  ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 34.h,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              menuController.fromHome
                                  ? menuController
                                      .categoryDataList[categoryId].name!
                                  : menuController
                                      .categoryDataList[
                                          menuController.selectedCategoryIndex]
                                      .name!,
                              style: fontBoldWithColor,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          SizedBox(
                              height: 24.h,
                              width: 66.w,
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      box.write('viewValue', 0);
                                      (context as Element).markNeedsBuild();
                                    },
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: SvgPicture.asset(
                                        Images.iconListView,
                                        fit: BoxFit.cover,
                                        color: box.read('viewValue') == 0
                                            ? AppColor.primaryColor
                                            : AppColor.fontColor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 18.w,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      box.write('viewValue', 1);
                                      (context as Element).markNeedsBuild();
                                    },
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: SvgPicture.asset(
                                        Images.iconGridView,
                                        fit: BoxFit.cover,
                                        color: box.read('viewValue') == 1
                                            ? AppColor.primaryColor
                                            : AppColor.fontColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ]),
                  ),
                  !menuController.iSmenuItemEmpty
                      ? Column(
                          children: [
                            if (box.read('viewValue') == 1)
                              menuItemSectionGrid(),
                            if (box.read('viewValue') == 0)
                              menuItemSectionList(),
                          ],
                        )
                      : const NoItemsAvailable()
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget menuItemSectionGrid() {
  return GetBuilder<MenuuController>(
    builder: (menuController) => !menuController.menuItemLoader
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 16.w),
            child: Column(
              children: [
                MasonryGridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  itemCount: menuController.categoryItemDataList.length,
                  itemBuilder: (context, index) {
                    return itemCardGrid(
                        menuController.categoryItemDataList, index, context);
                  },
                ),
                SizedBox(
                  height: 40.h,
                )
              ],
            ),
          )
        : menuItemSectionGridShimmer(),
  );
}

Widget menuItemSectionList() {
  return GetBuilder<MenuuController>(
    builder: (menuController) => !menuController.menuItemLoader
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              children: [
                ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: menuController.categoryItemDataList.length,
                    itemBuilder: (BuildContext context, index) {
                      return itemCardList(
                          menuController.categoryItemDataList, index, context);
                    }),
                SizedBox(
                  height: 40.h,
                )
              ],
            ),
          ) : menuItemSectionListShimmer(),
  );
}
