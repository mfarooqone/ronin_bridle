import 'package:clay_rigging_bridle/features/splash_screen/splash_screen.dart';
import 'package:clay_rigging_bridle/utils/app_colors.dart';
import 'package:clay_rigging_bridle/utils/app_labels.dart';
import 'package:clay_rigging_bridle/features/common/measurement_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Initialize measurement service
    Get.put(MeasurementService());

    return GetMaterialApp(
      title: AppLabels.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.white,
      ),
      // initialBinding: createBindings(context),
      navigatorObservers: [routeObserver],
      home: SplashScreen(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
  }
}
