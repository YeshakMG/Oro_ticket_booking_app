import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oro_ticket_booking_app/app/data/models/user_model.dart';
import 'package:oro_ticket_booking_app/app/data/models/trip_model.dart';
import 'package:oro_ticket_booking_app/app/modules/auth/authtabs/authtabs_controller.dart';
import 'package:oro_ticket_booking_app/app/modules/signup/controllers/signup_controller.dart';
import 'package:oro_ticket_booking_app/core/translations.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


    await dotenv.load(fileName: ".env");
    print("Loaded .env successfully");

    await GetStorage.init();
    await Hive.initFlutter();
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(TripModelAdapter());
    final box = await Hive.openBox('appBox');
   Get.lazyPut(() => SignUpController()); // ✅ Add this
   Get.lazyPut(() => AuthtabsController()); // ✅ Add this

  String? token = box.get("token");

  // Set initial locale based on saved language
  final savedLang = box.get("language") ?? "en";
  final initialLocale = Locale(savedLang);

  runApp(MyApp(initialRoute: token != null ? Routes.HOME : Routes.LOGIN, initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final Locale initialLocale;
  const MyApp({super.key, required this.initialRoute, required this.initialLocale});

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
      translations: AppTranslations(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
