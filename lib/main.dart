import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendor/Drawer/new_orders_drawer.dart';
import 'package:vendor/networking/my_http_client.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Pages/Login/sign_in.dart';
import 'package:vendor/Routes/routes.dart';
import 'package:vendor/Theme/colors.dart';
import 'package:vendor/Theme/style.dart';
import 'package:vendor/language_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint(e.toString());
  }

  AwesomeNotifications().initialize('resource://drawable/icon', [
    NotificationChannel(
      channelKey: '2121',
      channelName: 'Grocery Notification',
      channelDescription: 'Incoming Order Notification',
      defaultColor: kMainColor,
      ledColor: kWhiteColor,
      importance: NotificationImportance.High,
    )
  ]);
  HttpOverrides.global = MyHttpOverrides();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? result = prefs.getBool('islogin');
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(Phoenix(child: (result != null && result) ? const GroceryStoreHome() : const GroceryStoreLogin()));
}

class GroceryStoreLogin extends StatelessWidget {
  const GroceryStoreLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageCubit>(
      create: (context) => LanguageCubit(),
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) {
          return MaterialApp(
            title: 'Go Grocer Vendor',
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
              Locale('pt'),
              Locale('fr'),
              Locale('id'),
              Locale('es'),
              Locale('bg'),
            ],
            locale: locale,
            theme: ThemeUtils.defaultAppThemeData,
            darkTheme: ThemeUtils.darkAppThemData,
            home: const SignIn(),
            routes: PageRoutes().routes(),
          );
        },
      ),
    );
  }
}

class GroceryStoreHome extends StatelessWidget {
  const GroceryStoreHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LanguageCubit>(
      create: (context) => LanguageCubit(),
      child: BlocBuilder<LanguageCubit, Locale>(
        builder: (_, locale) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('ar'),
              Locale('pt'),
              Locale('fr'),
              Locale('id'),
              Locale('es'),
              Locale('bg'),
            ],
            locale: locale,
            theme: ThemeUtils.defaultAppThemeData,
            darkTheme: ThemeUtils.darkAppThemData,
            home: const NewOrdersDrawer(),
            routes: PageRoutes().routes(),
          );
        },
      ),
    );
  }
}
