import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './firebase_options.dart';
import 'ui/views/tabs_screen.dart';
import 'ui/views/add_images_screen.dart';
import 'ui/views/splash_screen.dart';
import 'ui/views/auth_screen.dart';
import 'ui/views/image_detail_screen.dart';
import 'ui/views/by_date_detail_view.dart';
import 'ui/views/list_all_zips_view.dart';

import 'locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Car Gallery",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: false,
      ),
      home: StreamBuilder(
          stream: locator<AuthService>().stream,
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const SplashScreen();
            }
            if (snapShot.hasData) {
              return const TabsSreen();
            }
            return const AuthScreen();
            // return const Text("auth page");
          }),
      routes: {
          AddImagesScreen.routeName: (ctx) => const AddImagesScreen(),
          ImageDetailScreen.routeName: (ctx) => const ImageDetailScreen(),
          ByDateDetailView.routeName: (ctx) => const ByDateDetailView(),
          ListAllZipsView.routeName: (ctx) => ListAllZipsView(),

      },
    );
  }
}
