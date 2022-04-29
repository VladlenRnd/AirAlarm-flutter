import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../service/alert_data_service.dart';
import '../service/notification_service.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("_____________BACKGROUND MESSAGE________________");
  await Firebase.initializeApp();
  await NotificationService.init();

  testNotification(message.data);

  try {
    await AlertDataService.runDataService();
  } catch (e) {
    print(e);
  }
  print("___________________________________________");
}

void testNotification(Map<String, dynamic> testStr) {
  if (testStr.isNotEmpty && testStr["test"] != null) {
    NotificationService.showTestNotification(notificationId: 111, body: testStr["test"]);
  }
}