import 'package:clay_rigging_bridle/features/bottom_nav_bar/measurement/measurement.dart';
import 'package:clay_rigging_bridle/features/bottom_nav_bar/setting_screen/setting_screen.dart';
import 'package:clay_rigging_bridle/features/bottom_nav_bar/weight_screen/weight_screen.dart';
import 'package:clay_rigging_bridle/utils/app_assets.dart';
import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class BottomNavBarScreen extends StatefulWidget {
  const BottomNavBarScreen({super.key});

  @override
  State<BottomNavBarScreen> createState() =>
      _BottomNavBarScreenState();
}

class _BottomNavBarScreenState
    extends State<BottomNavBarScreen> {
  ///
  ///
  ///
  late PersistentTabController controller;

  @override
  void initState() {
    super.initState();
    updateData();

    controller = PersistentTabController(initialIndex: 0);
  }

  Future<void> updateData() async {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    double height = size.height;
    // double width = size.width;
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            PersistentTabView(
              controller: controller,
              navBarHeight: height * 0.08,
              navBarBuilder:
                  (navBarConfig) => Style12BottomNavBar(
                    navBarConfig: navBarConfig,
                    navBarDecoration:
                        const NavBarDecoration(
                          color: AppColors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x3F000000),
                              blurRadius: 4,
                              offset: Offset(0, -2),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                  ),
              onTabChanged: (index) async {},
              tabs: [
                PersistentTabConfig(
                  screen: const MeasurementPage(),
                  item: ItemConfig(
                    icon: Image.asset(
                      AppAssets.selectMeasurement,
                    ),
                    inactiveIcon: Image.asset(
                      AppAssets.measurement,
                    ),
                    activeForegroundColor:
                        AppColors.primaryColor,
                    inactiveForegroundColor:
                        AppColors.black,
                    title: "Measurement",
                    textStyle: AppTextStyle.titleSmall
                        .copyWith(color: AppColors.white),
                  ),
                ),

                // PersistentTabConfig(
                //   screen: MaterialScreen(),
                //   item: ItemConfig(
                //     icon: Image.asset(
                //       AppAssets.selectMaterial,
                //     ),
                //     inactiveIcon: Image.asset(
                //       AppAssets.material,
                //     ),
                //     activeForegroundColor:
                //         AppColors.primaryColor,
                //     inactiveForegroundColor:
                //         AppColors.black,
                //     title: "Material",
                //     textStyle: AppTextStyle.titleSmall
                //         .copyWith(color: AppColors.white),
                //   ),
                // ),
                PersistentTabConfig(
                  screen: WeightScreen(),
                  item: ItemConfig(
                    icon: Image.asset(
                      AppAssets.selectWeight,
                    ),
                    inactiveIcon: Image.asset(
                      AppAssets.weight,
                    ),
                    activeForegroundColor:
                        AppColors.primaryColor,
                    inactiveForegroundColor:
                        AppColors.black,
                    title: "Weight",
                    textStyle: AppTextStyle.titleSmall
                        .copyWith(color: AppColors.white),
                  ),
                ),
                PersistentTabConfig(
                  screen: const SettingScreen(),
                  item: ItemConfig(
                    icon: Image.asset(
                      AppAssets.selectSetting,
                    ),
                    inactiveIcon: Image.asset(
                      AppAssets.setting,
                    ),
                    activeForegroundColor:
                        AppColors.primaryColor,
                    inactiveForegroundColor:
                        AppColors.black,
                    title: "Setting",
                    textStyle: AppTextStyle.titleSmall
                        .copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
