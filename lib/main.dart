import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screen/main_screen/main_screen.dart';
import 'service/firebase_service.dart';
import 'service/location_service.dart';
import 'service/notification_service.dart';
import 'service/shered_preferences_service.dart';
import 'tools/custom_color.dart';
import 'tools/repository/config_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: CustomColor.background));

  //==========Init Service==============
  await ConfigRepository.instance.init();
  await SheredPreferencesService().init();
  await LocationService().init();
  await NotificationService().init();
  await FirebaseService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      dialogBackgroundColor: CustomColor.backgroundCard,
      dialogTheme: DialogTheme(
        
          shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      )),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.all(8)),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> state) {
            if (state.contains(MaterialState.disabled)) {
              return CustomColor.actionColor.withOpacity(0.4);
            }
            return CustomColor.actionColor;
          }),
          textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(color: CustomColor.textColor, fontWeight: FontWeight.w600, fontSize: 16)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              side: const BorderSide(color: CustomColor.actionColor),
            ),
          ),
        ),
      ),
      colorScheme: ThemeData.dark().colorScheme.copyWith(
            secondary: CustomColor.background.withOpacity(0.1),
          ),
    );
  }
}
