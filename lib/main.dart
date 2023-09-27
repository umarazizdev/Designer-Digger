import 'package:designerdigger/Utilities/Provider/adonesprovider.dart';
import 'package:designerdigger/Utilities/Provider/cartprovider.dart';
import 'package:designerdigger/Utilities/Provider/categoryprovider.dart';
import 'package:designerdigger/Utilities/Provider/favouriteprovider.dart';
import 'package:designerdigger/Utilities/Provider/itemquantityprovider.dart';
import 'package:designerdigger/Utilities/Provider/searchprovider.dart';
import 'package:designerdigger/Utilities/Provider/securepass.dart';
import 'package:designerdigger/Utilities/Provider/themeprovider.dart';
import 'package:designerdigger/Utilities/Routes/approutes.dart';
import 'package:designerdigger/Utilities/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

final box = GetStorage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final box = GetStorage();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ItemQuantityProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => CartProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => AdOnesProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => ThemeChanger(),
          ),
          ChangeNotifierProvider(
            create: (_) => SecurePass(),
          ),
          ChangeNotifierProvider(
            create: (_) => CategoryProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => FavouriteProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => SearchProvider(),
          ),
        ],
        child: Builder(
          builder: (context) {
            final darkprovider = Provider.of<ThemeChanger>(context);

            return GetMaterialApp.router(
              title: 'Flutter Demo',
              darkTheme: ThemeData(
                  brightness: Brightness.dark,
                  appBarTheme: const AppBarTheme(color: ldarkbackgroundclr)),
              theme: ThemeData(
                brightness: Brightness.light,
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              themeMode: darkprovider.themeMode,
              routerDelegate: AppRoute.router.routerDelegate,
              routeInformationProvider:
                  AppRoute.router.routeInformationProvider,
              routeInformationParser: AppRoute.router.routeInformationParser,
              debugShowCheckedModeBanner: false,
            );
          },
        ));
  }
}
