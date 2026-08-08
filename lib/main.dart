import 'package:flutter/material.dart';
import 'package:get/get.dart';
//test
import 'package:taei_gov/src/home/controller/home_controller.dart';
import 'package:taei_gov/src/home/views/home.dart';

import 'config/app_theme.dart';
import 'constants/constant.dart';
import 'src/enter/enter_page.dart';
import 'src/login/controller/login_controller.dart';
import 'utils/helpers/local_data_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDataHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    final LoginController controller = Get.put(LoginController());
    return GetMaterialApp(
      title: 'TAEI',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: homeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      home: LocalDataHelper.getString(Constant.token).isEmpty
          ? EntranceScreen()
          : Home(),
    );
  }
}
