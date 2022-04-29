import 'package:internet_connection_checker/internet_connection_checker.dart';

Future<bool> internetConnectionCheker() async {
  return await InternetConnectionChecker().hasConnection;
}
