import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
    print("Loaded .env successfully");
  } catch (e) {
    print("No .env file found, skipping dotenv load");
  }

  await Hive.initFlutter();
  final box = await Hive.openBox('appBox');

  String? token = box.get("token");

  runApp(MyApp(initialRoute: token != null ? Routes.HOME : Routes.LOGIN));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    );
  }
}
