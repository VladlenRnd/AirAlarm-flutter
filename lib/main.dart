import 'package:alarm/screen/loader/loader_screan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'tools/custom_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: CustomColor.backgroundLight));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoaderScrean(),
      theme: ThemeData(
        fontFamily: "Days",
        colorScheme: ThemeData.dark().colorScheme.copyWith(
              secondary: CustomColor.backgroundLight.withOpacity(0.1),
            ),
      ),
    );
  }
}
