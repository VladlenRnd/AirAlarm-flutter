import '../tools/connection/connection.dart';
import '../tools/connection/response/alarm_response.dart';
import '../tools/eregion.dart';
import '../tools/region_title.dart';
import 'notification_service.dart';

enum _StatusNotification {
  notShow,
  showWarning,
  showCanceled,
}

class AlertDataService {
  static Map<String, dynamic> _oldData = {};

  ///************* */
  static bool isAlarmTest = false;
  static int isAlarmCountTest = 0;
//***************** */

  static Future<AlarmRespose> runDataService() async {
    try {
      AlarmRespose alarm = await _getAlarm();
      print(_oldData);
      await _isShowNotification(alarm.states);
      print("DONE!!!");
      return alarm;
    } catch (e) {
      print("EXEPTION");
      throw Exception("NO DATA EXEPTION");
    }
  }

  static bool getData(bool isTest, bool value) {
    if (!isTest) return value;

    if (isAlarmCountTest % 13 == 0) {
      isAlarmTest = !isAlarmTest;
    }
    isAlarmCountTest++;

    return isAlarmTest;
  }

  static Future<void> _isShowNotification(States states) async {
    _StatusNotification data = _isChekSubscribe(ERegion.dnipro, getData(false, states.dnipro.enabled));

    switch (data) {
      case _StatusNotification.notShow:
        print("==DONT SHOW MESSAGE==");
        break;
      case _StatusNotification.showWarning:
        await NotificationService.showAlertNotification(body: RegionTitle.getRegionByEnum(ERegion.dnipro), notificationId: ERegion.dnipro.index);
        break;
      case _StatusNotification.showCanceled:
        await NotificationService.showCanceledAlertNotification(
            body: RegionTitle.getRegionByEnum(ERegion.dnipro), notificationId: ERegion.dnipro.index);
        break;
    }
  }

  static _StatusNotification _isChekSubscribe(ERegion region, bool isAlarm) {
    _StatusNotification result = _StatusNotification.notShow;

    bool? oldState = _oldData[region.name];
    if (_oldData.isNotEmpty) {
      if (oldState != null) {
        if (oldState != isAlarm) {
          if (isAlarm) {
            print("SHOW WARNING ALARM");
            result = _StatusNotification.showWarning;
          } else {
            print("SHOW CANCELED WARNING ALARM");
            result = _StatusNotification.showCanceled;
          }
        }
      } else {
        if (isAlarm) {
          print("SHOW WARNING ALARM INIT");
          result = _StatusNotification.showWarning;
        }
      }
    }

    _oldData[region.name] = isAlarm;
    return result;
  }

  static Future<AlarmRespose> _getAlarm() async {
    try {
      return await Conectrion.getAlarm();
    } catch (e) {
      throw Exception("Not data Alarm");
    }
  }
}
