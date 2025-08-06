import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/main_screen/main_screen.dart';
import 'service/firebase_config_service.dart';
import 'service/firebase_crashlytics_service.dart';
import 'service/firebase_notification_service.dart';
import 'service/location_service.dart';
import 'service/notification_service.dart';
import 'service/shered_preferences_service.dart';
import 'tools/custom_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: CustomColor.background));

  //==========Init Service==============
  await SheredPreferencesService().init();
  await LocationService().init();
  await NotificationService().init();
  await FirebaseNotificationService().init();
  await FirebaseConfigService().init();
  await FirebaseCrashlyticsService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
      theme: _getTheme(),
    );
  }

  ThemeData _getTheme() {
    return ThemeData(
      fontFamily: "Roboto",
      dialogTheme: DialogThemeData(
          backgroundColor: CustomColor.backgroundCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(8)),
          backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> state) {
            if (state.contains(WidgetState.disabled)) {
              return CustomColor.actionColor.withValues(alpha: 0.4);
            }
            return CustomColor.actionColor;
          }),
          textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(color: CustomColor.textColor, fontWeight: FontWeight.w600, fontSize: 16)),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: CustomColor.actionColor),
            ),
          ),
        ),
      ),
      colorScheme: ThemeData.dark().colorScheme.copyWith(secondary: CustomColor.background.withValues(alpha: 0.1)),
    );
  }
}
